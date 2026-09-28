`timescale 1ns/1ps

module flash_controller (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] paddr,
    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    output logic        pslverr,

    output logic        spi_csn,
    output logic        spi_clk,
    inout  wire         spi_dq0,
    inout  wire         spi_dq1,
    inout  wire         spi_dq2,
    inout  wire         spi_dq3
);

    localparam logic [31:0] FLASH_END = 32'h00ff_ffff;
    localparam logic [31:0] REG_BASE  = 32'h0100_0000;
    localparam logic [31:0] REG_ADDR  = REG_BASE + 32'h00;
    localparam logic [31:0] REG_LEN   = REG_BASE + 32'h04;
    localparam logic [31:0] REG_CMD   = REG_BASE + 32'h08;
    localparam logic [31:0] REG_CTRL  = REG_BASE + 32'h0c;
    localparam logic [31:0] REG_STAT  = REG_BASE + 32'h10;
    localparam logic [31:0] REG_DATA  = REG_BASE + 32'h14;
    localparam logic [31:0] REG_CFG   = REG_BASE + 32'h18;

    localparam logic [1:0] MODE_SINGLE = 2'd0;
    localparam logic [1:0] MODE_DUAL   = 2'd1;
    localparam logic [1:0] MODE_QUAD   = 2'd2;

    typedef enum logic [3:0] {
        ST_IDLE,
        ST_CMD,
        ST_ADDR,
        ST_DUMMY,
        ST_DATA,
        ST_RESP,
        ST_ERROR
    } state_t;

    state_t state;

    logic [31:0] addr_reg;
    logic [7:0]  len_reg;
    logic [7:0]  cmd_reg;
    logic [15:0] half_period_reg;
    logic [7:0]  dummy_reg;
    logic [1:0]  mode_reg;

    logic [31:0] current_addr;
    logic [7:0]  current_len;
    logic [1:0]  current_mode;
    logic        indirect_active;

    logic [127:0] data_buffer;
    logic [7:0]   data_index;
    logic         indirect_done;
    logic         error_flag;

    logic [31:0] response_data;
    logic        response_error;

    logic [15:0] divider_count;
    logic [7:0]  tx_count;
    logic [7:0]  dummy_count;
    logic [7:0]  data_count;
    logic [31:0] tx_shift;
    logic [31:0] rx_shift;

    logic dq0_oe, dq1_oe, dq2_oe, dq3_oe;
    logic dq0_out, dq1_out, dq2_out, dq3_out;

    assign spi_dq0 = dq0_oe ? dq0_out : 1'bz;
    assign spi_dq1 = dq1_oe ? dq1_out : 1'bz;
    assign spi_dq2 = dq2_oe ? dq2_out : 1'bz;
    assign spi_dq3 = dq3_oe ? dq3_out : 1'bz;

    wire apb_access = psel && penable;
    wire direct_access = (paddr <= FLASH_END);
    wire register_access = (paddr >= REG_BASE) && (paddr < REG_BASE + 32'h20);
    wire address_aligned = (paddr[1:0] == 2'b00);

    assign pready  = (state == ST_RESP) || (state == ST_ERROR);
    assign prdata  = response_data;
    assign pslverr = response_error;

    function automatic [1:0] normalized_mode(input [1:0] requested);
        begin
            normalized_mode = (requested <= MODE_QUAD) ? requested : MODE_SINGLE;
        end
    endfunction

    function automatic [7:0] mode_command(input [1:0] requested_mode);
        begin
            case (normalized_mode(requested_mode))
                MODE_DUAL: mode_command = 8'h3b;
                MODE_QUAD: mode_command = 8'h6b;
                default:   mode_command = 8'h0b;
            endcase
        end
    endfunction

    function automatic [7:0] data_lanes(input [1:0] requested_mode);
        begin
            case (normalized_mode(requested_mode))
                MODE_DUAL: data_lanes = 8'd2;
                MODE_QUAD: data_lanes = 8'd4;
                default:   data_lanes = 8'd1;
            endcase
        end
    endfunction

    task automatic drive_single_tx(input logic [7:0] value);
        begin
            dq0_oe  <= 1'b1;
            dq0_out <= value[7];
            dq1_oe  <= 1'b0;
            dq2_oe  <= 1'b0;
            dq3_oe  <= 1'b1;
            dq3_out <= 1'b1;
        end
    endtask

    task automatic release_data_bus;
        begin
            dq0_oe <= 1'b0;
            dq1_oe <= 1'b0;
            dq2_oe <= 1'b0;
            dq3_oe <= (current_mode != MODE_QUAD);
            dq3_out <= 1'b1;
        end
    endtask

    task automatic prepare_next_tx_bit;
        begin
            tx_shift <= {tx_shift[30:0], 1'b0};
            dq0_out <= tx_shift[30];
        end
    endtask

    function automatic [31:0] indirect_data_word(input [7:0] index);
        integer byte_number;
        integer source_msb;
        begin
            indirect_data_word = 32'd0;
            for (byte_number = 0; byte_number < 4; byte_number = byte_number + 1) begin
                if ((index * 4 + byte_number) < current_len) begin
                    source_msb = current_len * 8 - 1 - (index * 4 + byte_number) * 8;
                    indirect_data_word[byte_number * 8 +: 8] = data_buffer[source_msb -: 8];
                end
            end
        end
    endfunction

    function automatic [31:0] little_endian_word(input [31:0] value);
        begin
            little_endian_word = {value[7:0], value[15:8], value[23:16], value[31:24]};
        end
    endfunction

    task automatic begin_transaction(
        input logic [31:0] start_addr,
        input logic [7:0]  command,
        input logic [7:0]  length,
        input logic [1:0]  requested_mode,
        input logic [7:0]  dummy_cycles,
        input logic        is_indirect
    );
        begin
            current_addr   <= start_addr;
            current_len    <= (length == 0) ? 8'd4 : length;
            current_mode   <= normalized_mode(requested_mode);
            indirect_active <= is_indirect;
            tx_shift       <= {command, 24'd0};
            tx_count       <= 8'd8;
            dummy_count    <= dummy_cycles;
            data_count     <= (length == 0) ? 8'd32 / data_lanes(requested_mode)
                                            : (length * 8) / data_lanes(requested_mode);
            rx_shift       <= 32'd0;
            data_buffer    <= 128'd0;
            data_index     <= 8'd0;
            spi_csn        <= 1'b0;
            spi_clk        <= 1'b0;
            divider_count  <= 16'd0;
            state          <= ST_CMD;
            drive_single_tx(command);
        end
    endtask

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state           <= ST_IDLE;
            response_data   <= 32'd0;
            response_error  <= 1'b0;
            addr_reg        <= 32'd0;
            len_reg         <= 8'd4;
            cmd_reg         <= 8'h0b;
            half_period_reg <= 16'd50;
            dummy_reg       <= 8'd8;
            mode_reg        <= MODE_SINGLE;
            current_addr    <= 32'd0;
            current_len     <= 8'd4;
            current_mode    <= MODE_SINGLE;
            indirect_active <= 1'b0;
            data_buffer     <= 128'd0;
            data_index      <= 8'd0;
            indirect_done   <= 1'b0;
            error_flag      <= 1'b0;
            divider_count   <= 16'd0;
            tx_count        <= 8'd0;
            dummy_count     <= 8'd0;
            data_count      <= 8'd0;
            tx_shift        <= 32'd0;
            rx_shift        <= 32'd0;
            spi_csn         <= 1'b1;
            spi_clk         <= 1'b0;
            dq0_oe          <= 1'b0;
            dq1_oe          <= 1'b0;
            dq2_oe          <= 1'b0;
            dq3_oe          <= 1'b1;
            dq0_out         <= 1'b0;
            dq1_out         <= 1'b0;
            dq2_out         <= 1'b0;
            dq3_out         <= 1'b1;
        end else begin
            case (state)
                ST_IDLE: begin
                    response_error <= 1'b0;
                    if (apb_access) begin
                        if (pwrite) begin
                            if (register_access && !indirect_active) begin
                                case (paddr)
                                    REG_ADDR: addr_reg <= pwdata;
                                    REG_LEN:  len_reg  <= (pwdata[7:0] > 8'd16) ? 8'd16 : pwdata[7:0];
                                    REG_CMD:  cmd_reg  <= pwdata[7:0];
                                    REG_CFG: begin
                                        half_period_reg <= (pwdata[15:0] == 0) ? 16'd1 : pwdata[15:0];
                                        dummy_reg       <= pwdata[23:16];
                                        mode_reg        <= normalized_mode(pwdata[25:24]);
                                    end
                                    REG_CTRL: begin
                                        if (pwdata[1]) begin
                                            indirect_done <= 1'b0;
                                            error_flag    <= 1'b0;
                                        end
                                        if (pwdata[0]) begin
                                            if (len_reg == 0 || len_reg > 8'd16) begin
                                                error_flag     <= 1'b1;
                                                response_error <= 1'b1;
                                                state          <= ST_ERROR;
                                            end else begin
                                                begin_transaction(addr_reg, cmd_reg, len_reg, mode_reg,
                                                                  dummy_reg, 1'b1);
                                            end
                                        end else begin
                                            state <= ST_RESP;
                                        end
                                    end
                                    default: begin
                                        response_error <= 1'b1;
                                        state <= ST_ERROR;
                                    end
                                endcase
                                if (paddr != REG_CTRL)
                                    state <= ST_RESP;
                            end else begin
                                response_error <= 1'b1;
                                state <= ST_ERROR;
                            end
                        end else if (direct_access && address_aligned && !indirect_active) begin
                            begin_transaction(paddr, mode_command(mode_reg), 8'd4,
                                              mode_reg, dummy_reg, 1'b0);
                        end else if (register_access && !indirect_active) begin
                            state <= ST_RESP;
                            case (paddr)
                                REG_ADDR: response_data <= addr_reg;
                                REG_LEN:  response_data <= {24'd0, len_reg};
                                REG_CMD:  response_data <= {24'd0, cmd_reg};
                                REG_CTRL: response_data <= 32'd0;
                                REG_STAT: response_data <= {29'd0, error_flag, indirect_done, indirect_active};
                                REG_DATA: begin
                                    if (!indirect_done || data_index >= ((current_len + 8'd3) >> 2)) begin
                                        response_error <= 1'b1;
                                        state <= ST_ERROR;
                                    end else begin
                                        response_data <= indirect_data_word(data_index);
                                        data_index <= data_index + 1'b1;
                                        state <= ST_RESP;
                                    end
                                end
                                REG_CFG: response_data <= {6'd0, mode_reg, dummy_reg, half_period_reg};
                                default: begin
                                    response_error <= 1'b1;
                                    state <= ST_ERROR;
                                end
                            endcase
                        end else begin
                            response_error <= 1'b1;
                            state <= ST_ERROR;
                        end
                    end
                end

                ST_CMD, ST_ADDR, ST_DUMMY, ST_DATA: begin
                    if (divider_count >= ((half_period_reg == 0) ? 16'd0 : half_period_reg - 1'b1)) begin
                        divider_count <= 16'd0;
                        if (spi_clk == 1'b0) begin
                            spi_clk <= 1'b1;
                            if (state == ST_DATA) begin
                                case (data_lanes(current_mode))
                                    1: begin
                                        rx_shift <= {rx_shift[30:0], spi_dq1};
                                        if (indirect_active)
                                            data_buffer <= {data_buffer[126:0], spi_dq1};
                                    end
                                    2: begin
                                        rx_shift <= {rx_shift[29:0], spi_dq1, spi_dq0};
                                        if (indirect_active)
                                            data_buffer <= {data_buffer[125:0], spi_dq1, spi_dq0};
                                    end
                                    default: begin
                                        rx_shift <= {rx_shift[27:0], spi_dq3, spi_dq2, spi_dq1, spi_dq0};
                                        if (indirect_active)
                                            data_buffer <= {data_buffer[123:0], spi_dq3, spi_dq2, spi_dq1, spi_dq0};
                                    end
                                endcase
                            end
                        end else begin
                            spi_clk <= 1'b0;
                            case (state)
                                ST_CMD: begin
                                    if (tx_count > 8'd1) begin
                                        tx_count <= tx_count - 1'b1;
                                        prepare_next_tx_bit();
                                    end else begin
                                        tx_shift <= {current_addr[23:0], 8'd0};
                                        tx_count <= 8'd24;
                                        state <= ST_ADDR;
                                        dq0_out <= current_addr[23];
                                    end
                                end
                                ST_ADDR: begin
                                    if (tx_count > 8'd1) begin
                                        tx_count <= tx_count - 1'b1;
                                        prepare_next_tx_bit();
                                    end else if (dummy_count != 0) begin
                                        tx_count <= 0;
                                        state <= ST_DUMMY;
                                        dq0_out <= 1'b0;
                                    end else begin
                                        state <= ST_DATA;
                                        data_count <= (current_len * 8) / data_lanes(current_mode);
                                        release_data_bus();
                                    end
                                end
                                ST_DUMMY: begin
                                    if (dummy_count > 8'd1) begin
                                        dummy_count <= dummy_count - 1'b1;
                                    end else begin
                                        dummy_count <= 0;
                                        state <= ST_DATA;
                                        data_count <= (current_len * 8) / data_lanes(current_mode);
                                        release_data_bus();
                                    end
                                end
                                ST_DATA: begin
                                    if (data_count > 8'd1) begin
                                        data_count <= data_count - 1'b1;
                                    end else begin
                                        spi_csn <= 1'b1;
                                        spi_clk <= 1'b0;
                                        dq0_oe <= 1'b0;
                                        dq1_oe <= 1'b0;
                                        dq2_oe <= 1'b0;
                                        dq3_oe <= 1'b1;
                                        dq3_out <= 1'b1;
                                        if (indirect_active) begin
                                            indirect_done <= 1'b1;
                                            indirect_active <= 1'b0;
                                        end else begin
                                            response_data <= little_endian_word(rx_shift);
                                        end
                                        state <= ST_RESP;
                                    end
                                end
                                default: begin
                                    state <= ST_ERROR;
                                    response_error <= 1'b1;
                                end
                            endcase
                        end
                    end else begin
                        divider_count <= divider_count + 1'b1;
                    end
                end

                ST_RESP, ST_ERROR: begin
                    if (!psel || !penable) begin
                        state <= ST_IDLE;
                        response_error <= 1'b0;
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end
endmodule
