//=============================================================================
// alu_top.sv - 8位ALU + 累加寄存器 + 简单状态机
//=============================================================================
`timescale 1ns/1ps

module alu_top #(
    parameter DATA_WIDTH = 8
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    start,
    input  logic [DATA_WIDTH-1:0]   a,
    input  logic [DATA_WIDTH-1:0]   b,
    input  logic [2:0]              op,
    output logic [DATA_WIDTH-1:0]   result,
    output logic                    done,
    output logic [1:0]              state_out
);

    // 状态编码
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        CALC  = 2'b01,
        STORE = 2'b10,
        DONE  = 2'b11
    } state_e;

    state_e state, next_state;
    logic [DATA_WIDTH-1:0] alu_result;
    logic [DATA_WIDTH-1:0] acc;          // 累加寄存器

    //---------------- 状态机 ----------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE : if (start) next_state = CALC;
            CALC :            next_state = STORE;
            STORE:            next_state = DONE;
            DONE :            next_state = IDLE;
            default:          next_state = IDLE;
        endcase
    end

    //---------------- ALU 组合逻辑 ----------------
    always_comb begin
        case (op)
            3'b000: alu_result = a + b;          // ADD
            3'b001: alu_result = a - b;          // SUB
            3'b010: alu_result = a & b;          // AND
            3'b011: alu_result = a | b;          // OR
            3'b100: alu_result = a ^ b;          // XOR
            3'b101: alu_result = a << 1;         // SHL
            3'b110: alu_result = a >> 1;         // SHR
            3'b111: alu_result = {a[6:0], a[7]}; // ROL
            default: alu_result = '0;
        endcase
    end

    //---------------- 累加寄存器 ----------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc <= '0;
        else if (state == STORE)
            acc <= acc + alu_result;
    end

    //---------------- 输出 ----------------
    assign result    = acc;
    assign done      = (state == DONE);
    assign state_out = state;

endmodule