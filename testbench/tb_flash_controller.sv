`timescale 1ns/1ps

module tb_flash_controller;
    logic        clk = 1'b0;
    logic        rst_n = 1'b0;
    always #5 clk = ~clk;

    logic        psel = 1'b0;
    logic        penable = 1'b0;
    logic        pwrite = 1'b0;
    logic [31:0] paddr = '0;
    logic [31:0] pwdata = '0;
    wire  [31:0] prdata;
    wire         pready;
    wire         pslverr;

    wire         spi_csn;
    wire         spi_clk;
    tri          spi_dq0;
    tri          spi_dq1;
    tri          spi_dq2;
    tri          spi_dq3;

    wire [31:0]  vcc = 32'd1800;
    wire         reset2 = 1'b0;

    flash_controller dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .psel     (psel),
        .penable  (penable),
        .pwrite   (pwrite),
        .paddr    (paddr),
        .pwdata   (pwdata),
        .prdata   (prdata),
        .pready   (pready),
        .pslverr  (pslverr),
        .spi_csn  (spi_csn),
        .spi_clk  (spi_clk),
        .spi_dq0  (spi_dq0),
        .spi_dq1  (spi_dq1),
        .spi_dq2  (spi_dq2),
        .spi_dq3  (spi_dq3)
    );

    flash_model_compat #(.IMAGE("testbench/flash_test.mem")) flash (
        .cs_n (spi_csn),
        .sck  (spi_clk),
        .dq0  (spi_dq0),
        .dq1  (spi_dq1),
        .dq2  (spi_dq2),
        .dq3  (spi_dq3)
    );

    task automatic apb_read(
        input  logic [31:0] addr,
        output logic [31:0] data,
        output logic        err
    );
        int cycles;
        begin
            @(negedge clk);
            paddr   = addr;
            pwrite  = 1'b0;
            psel    = 1'b1;
            penable = 1'b0;
            @(negedge clk);
            penable = 1'b1;
            cycles = 0;
            while (!pready && cycles < 20000) begin
                @(negedge clk);
                cycles++;
            end
            if (!pready) $fatal(1, "APB read timeout at %h", addr);
            data = prdata;
            err  = pslverr;
            @(negedge clk);
            psel    = 1'b0;
            penable = 1'b0;
            paddr   = '0;
        end
    endtask

    task automatic apb_write(
        input logic [31:0] addr,
        input logic [31:0] value,
        output logic        err
    );
        int cycles;
        begin
            @(negedge clk);
            paddr   = addr;
            pwdata  = value;
            pwrite  = 1'b1;
            psel    = 1'b1;
            penable = 1'b0;
            @(negedge clk);
            penable = 1'b1;
            cycles = 0;
            while (!pready && cycles < 20000) begin
                @(negedge clk);
                cycles++;
            end
            if (!pready) $fatal(1, "APB write timeout at %h", addr);
            err = pslverr;
            @(negedge clk);
            psel    = 1'b0;
            penable = 1'b0;
            pwrite  = 1'b0;
            paddr   = '0;
            pwdata  = '0;
        end
    endtask

    initial begin
        logic [31:0] data;
        logic        err;
        logic [31:0] status;
        integer      poll;

`ifdef VERILATOR
        $dumpfile("wave.fst");
`else
        $dumpfile("flash_controller.vcd");
`endif
        $dumpvars(0, tb_flash_controller);

        repeat (20) @(negedge clk);
        rst_n = 1'b1;
        repeat (200) @(negedge clk);

        apb_read(32'h0000_0100, data, err);
        if (err) $fatal(1, "direct read unexpectedly errored");
        if (data !== 32'hA3A2A1A0)
            $fatal(1, "direct read mismatch: got %h expected A3A2A1A0", data);

        apb_read(32'h0000_0101, data, err);
        if (!err) $fatal(1, "unaligned read did not report an error");

        apb_write(32'h0000_0100, 32'h1234_5678, err);
        if (!err) $fatal(1, "write to flash window did not report an error");

        apb_write(32'h0100_0018, 32'h0108_0032, err);
        if (err) $fatal(1, "dual mode configuration write failed");
        apb_read(32'h0000_0100, data, err);
        if (err || data !== 32'hA3A2A1A0)
            $fatal(1, "dual output read mismatch: got %h", data);

        apb_write(32'h0100_0018, 32'h0208_0032, err);
        if (err) $fatal(1, "quad mode configuration write failed");
        apb_read(32'h0000_0100, data, err);
        if (err || data !== 32'hA3A2A1A0)
            $fatal(1, "quad output read mismatch: got %h", data);

        apb_write(32'h0100_0018, 32'h0004_0019, err);
        if (err) $fatal(1, "dummy configuration write failed");
        apb_read(32'h0000_0100, data, err);
        if (err || data !== 32'hA3A2A1A0)
            $fatal(1, "configurable dummy/clock direct read mismatch: got %h", data);
        apb_write(32'h0100_0000, 32'h0000_0100, err);
        apb_write(32'h0100_0004, 32'd4, err);
        apb_write(32'h0100_0008, 32'h0b, err);
        apb_write(32'h0100_000c, 32'h1, err);
        if (err) $fatal(1, "indirect start failed");

        status = 32'd0;
        for (poll = 0; poll < 4 && !status[1]; poll = poll + 1) begin
            apb_read(32'h0100_0010, status, err);
            if (err) $fatal(1, "status read failed");
        end
        if (!status[1] || status[0])
            $fatal(1, "indirect transaction did not complete: status=%h", status);
        apb_read(32'h0100_0014, data, err);
        if (err || data !== 32'hA3A2A1A0)
            $fatal(1, "indirect read mismatch: got %h", data);

        apb_write(32'h0100_000c, 32'h2, err);
        apb_write(32'h0100_0000, 32'h0000_0100, err);
        apb_write(32'h0100_0004, 32'd8, err);
        apb_write(32'h0100_000c, 32'h1, err);
        status = 32'd0;
        for (poll = 0; poll < 4 && !status[1]; poll = poll + 1)
            apb_read(32'h0100_0010, status, err);
        if (!status[1] || status[0])
            $fatal(1, "8-byte indirect transaction did not complete: status=%h", status);
        apb_read(32'h0100_0014, data, err);
        if (err || data !== 32'hA3A2A1A0)
            $fatal(1, "8-byte indirect word 0 mismatch: got %h", data);
        apb_read(32'h0100_0014, data, err);
        if (err || data !== 32'hA7A6A5A4)
            $fatal(1, "8-byte indirect word 1 mismatch: got %h", data);

        apb_write(32'h0100_000c, 32'h2, err);
        apb_write(32'h0100_0004, 32'd1, err);
        apb_write(32'h0100_000c, 32'h1, err);
        status = 32'd0;
        for (poll = 0; poll < 4 && !status[1]; poll = poll + 1)
            apb_read(32'h0100_0010, status, err);
        if (!status[1] || status[0])
            $fatal(1, "1-byte indirect transaction did not complete: status=%h", status);
        apb_read(32'h0100_0014, data, err);
        if (err || data !== 32'h000000A0)
            $fatal(1, "1-byte indirect word mismatch: got %h", data);

        apb_read(32'h0100_001c, data, err);
        if (!err) $fatal(1, "invalid register read did not report an error");
        apb_read(32'h0200_0000, data, err);
        if (!err) $fatal(1, "unmapped read did not report an error");

        $display("PASS: direct, error, dual, quad and indirect Flash reads");
        $finish;
    end
endmodule
