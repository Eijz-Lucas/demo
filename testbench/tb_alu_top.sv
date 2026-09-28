`timescale 1ns/1ps

module tb_alu_top;
    localparam DATA_WIDTH = 8;

    logic                  clk;
    logic                  rst_n;
    logic                  start;
    logic [DATA_WIDTH-1:0] a, b;
    logic [2:0]            op;
    logic [DATA_WIDTH-1:0] result;
    logic                  done;
    logic [1:0]            state_out;

    alu_top #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .a(a), .b(b), .op(op),
        .result(result), .done(done), .state_out(state_out)
    );

    // 时钟
    initial clk = 0;
    always #5 clk = ~clk;

    // 波形
    initial begin
        $dumpfile("wave.fst");   // 必须在前面
        $dumpvars(0, tb_alu_top); // 必须在后面
    end

    // 期望值函数
    function automatic logic [DATA_WIDTH-1:0] exp_alu(
        input logic [DATA_WIDTH-1:0] aa,
        input logic [DATA_WIDTH-1:0] bb,
        input logic [2:0]            oo
    );
        case (oo)
            3'b000: exp_alu = aa + bb;
            3'b001: exp_alu = aa - bb;
            3'b010: exp_alu = aa & bb;
            3'b011: exp_alu = aa | bb;
            3'b100: exp_alu = aa ^ bb;
            3'b101: exp_alu = aa << 1;
            3'b110: exp_alu = aa >> 1;
            3'b111: exp_alu = {aa[6:0], aa[7]};
            default: exp_alu = '0;
        endcase
    endfunction

    integer i;
    integer errors = 0;
    logic [DATA_WIDTH-1:0] acc_exp = '0;

    initial begin
        rst_n = 0; start = 0;
        a = '0; b = '0; op = '0;

        $display("==========================================");
        $display(" ALU Top Simulation");
        $display("==========================================");

        repeat(4) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            a     = 8'h35 + i;
            b     = 8'h12;
            op    = i[2:0];
            start = 1;

            @(posedge clk);
            start = 0;

            // 等待 done，带超时保护
            begin : wait_done
                integer guard;
                for (guard = 0; guard < 20; guard = guard + 1) begin
                    if (done) disable wait_done;
                    @(posedge clk);
                end
                $display("[TB] TIMEOUT waiting for done");
            end

            @(posedge clk);

            acc_exp = acc_exp + exp_alu(a, b, op);

            if (result === acc_exp)
                $display("[TB] op=%0d a=0x%02h b=0x%02h -> acc=0x%02h (exp=0x%02h) PASS",
                         op, a, b, result, acc_exp);
            else begin
                $display("[TB] op=%0d a=0x%02h b=0x%02h -> acc=0x%02h (exp=0x%02h) FAIL",
                         op, a, b, result, acc_exp);
                errors = errors + 1;
            end

            @(posedge clk);
        end

        repeat(4) @(posedge clk);

        $display("==========================================");
        if (errors == 0) $display(" ALL TESTS PASSED");
        else             $display(" %0d TEST(S) FAILED", errors);
        $display("==========================================");

        $finish;
    end

    // 全局超时
    initial begin
        #100000;
        $display("[TB] GLOBAL TIMEOUT");
        $finish;
    end

endmodule