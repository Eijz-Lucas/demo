`timescale 1ns/1ps

// Small open-source-simulator-compatible model for the read protocols used by
// the exercise. It loads the same VMF image as the supplied Micron model and
// implements 0x0B, 0x3B and 0x6B read transactions.
module flash_model_compat #(
    parameter integer DUMMY_CYCLES = 8,
    parameter string  IMAGE = "testbench/MT25QU128ABB8E0_VG17/sim/mem_Q128.vmf"
) (
    input  wire       cs_n,
    input  wire       sck,
    inout  wire       dq0,
    inout  wire       dq1,
    inout  wire       dq2,
    inout  wire       dq3
);
    localparam [2:0] PH_CMD   = 3'd0;
    localparam [2:0] PH_ADDR  = 3'd1;
    localparam [2:0] PH_DUMMY = 3'd2;
    localparam [2:0] PH_DATA  = 3'd3;

    reg [7:0] memory [0:24'hffffff];
    reg [2:0] phase;
    reg [7:0] command;
    reg [23:0] address;
    integer bit_count;
    integer dummy_count;
    integer output_bit;
    integer lanes;

    reg dq0_oe, dq1_oe, dq2_oe, dq3_oe;
    reg dq0_drv, dq1_drv, dq2_drv, dq3_drv;

    assign dq0 = dq0_oe ? dq0_drv : 1'bz;
    assign dq1 = dq1_oe ? dq1_drv : 1'bz;
    assign dq2 = dq2_oe ? dq2_drv : 1'bz;
    assign dq3 = dq3_oe ? dq3_drv : 1'bz;

    function automatic integer selected_lanes(input [7:0] cmd);
        begin
            case (cmd)
                8'h3b: selected_lanes = 2;
                8'h6b: selected_lanes = 4;
                default: selected_lanes = 1;
            endcase
        end
    endfunction

    task automatic release_outputs;
        begin
            dq0_oe = 1'b0;
            dq1_oe = 1'b0;
            dq2_oe = 1'b0;
            dq3_oe = 1'b0;
        end
    endtask

    task automatic drive_data;
        integer byte_addr;
        integer bit_in_byte;
        begin
            byte_addr = {8'd0, address} + output_bit / 8;
            bit_in_byte = output_bit % 8;
            release_outputs();
            case (lanes)
                1: begin
                    dq1_oe  = 1'b1;
                    dq1_drv = memory[byte_addr][7-bit_in_byte];
                end
                2: begin
                    dq0_oe  = 1'b1;
                    dq1_oe  = 1'b1;
                    dq1_drv = memory[byte_addr][7-bit_in_byte];
                    dq0_drv = memory[byte_addr][6-bit_in_byte];
                end
                default: begin
                    dq0_oe  = 1'b1;
                    dq1_oe  = 1'b1;
                    dq2_oe  = 1'b1;
                    dq3_oe  = 1'b1;
                    dq3_drv = memory[byte_addr][7-bit_in_byte];
                    dq2_drv = memory[byte_addr][6-bit_in_byte];
                    dq1_drv = memory[byte_addr][5-bit_in_byte];
                    dq0_drv = memory[byte_addr][4-bit_in_byte];
                end
            endcase
        end
    endtask

    initial begin
        $readmemh(IMAGE, memory);
        phase = PH_CMD;
        command = 0;
        address = 0;
        bit_count = 0;
        dummy_count = 0;
        output_bit = 0;
        lanes = 1;
        release_outputs();
    end

    always @(negedge cs_n) begin
        phase = PH_CMD;
        command = 0;
        address = 0;
        bit_count = 0;
        dummy_count = 0;
        output_bit = 0;
        lanes = 1;
        release_outputs();
    end

    always @(posedge sck) begin
        if (!cs_n) begin
            case (phase)
                PH_CMD: begin
                    command = {command[6:0], dq0};
                    bit_count = bit_count + 1;
                    if (bit_count == 8) begin
                        bit_count = 0;
                        phase = PH_ADDR;
                        lanes = selected_lanes(({command[6:0], dq0} >> 1));
                    end
                end
                PH_ADDR: begin
                    address = {address[22:0], dq0};
                    bit_count = bit_count + 1;
                    if (bit_count == 24) begin
                        bit_count = 0;
                        dummy_count = 0;
                        phase = PH_DUMMY;
                    end
                end
                PH_DUMMY: begin
                    dummy_count = dummy_count + 1;
                end
                PH_DATA: begin
                    // The controller samples the pins on this edge.
                end
                default: phase = PH_CMD;
            endcase
        end
    end

    always @(negedge sck) begin
        if (!cs_n && phase == PH_DATA) begin
            drive_data();
            output_bit = output_bit + lanes;
        end
    end

    // In the real device the configured dummy count is part of the device
    // configuration. The controller signals the end of that phase by
    // releasing DQ0, which lets this compatibility model support any value
    // programmed through the controller's configuration register.
    always @(dq0) begin
        if (!cs_n && phase == PH_DUMMY && dq0 === 1'bz) begin
            phase = PH_DATA;
            output_bit = 0;
            drive_data();
            output_bit = output_bit + lanes;
        end
    end

    always @(posedge cs_n) begin
        release_outputs();
    end
endmodule
