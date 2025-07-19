module multdiv(
    input [31:0] data_operandA, data_operandB,
    input ctrl_MULT, ctrl_DIV, clock,
    output [31:0] data_result,
    output mult_exception, div_exception, data_resultRDY
);

    // wire signals
    wire [31:0] op_a_latch, op_b_latch;
    wire [31:0] mult_res, div_res, safe_div_res;
    wire [5:0] counter_val;
    wire reset_sig, reset_count;
    wire mult_op_latch, div_op_latch, resetCounter;
    wire mult_rdy, mult_reset, div_rdy, div_reset;
    wire mult_ovf, zero_to_nonzero, b_zero, a_zero, result_zero;
    wire sign_a, sign_b, sign_res, sign_mismatch, mult_exc, div_exc;

    // latch init operands
    register32 latch_a_reg(op_a_latch, data_operandA, clock, 1'b1, 1'b0);
    register32 latch_b_reg(op_b_latch, data_operandB, clock, 1'b1, 1'b0);

    // exception flags
    assign b_zero = ~|op_b_latch;
    assign a_zero = ~|op_a_latch;
    assign result_zero = ~|data_result;
    assign zero_to_nonzero = (b_zero | a_zero) & ~result_zero;

    assign sign_a = op_a_latch[31];
    assign sign_b = op_b_latch[31];
    assign sign_res = data_result[31];
    assign sign_mismatch = (sign_a ^ sign_b) != sign_res;

    assign mult_exc = mult_ovf | zero_to_nonzero | sign_mismatch;
    assign div_exc = b_zero;

    // operation latching 
    assign reset_sig = ctrl_MULT | ctrl_DIV | resetCounter;
    register mult_op_reg(mult_op_latch, ctrl_MULT, clock, ctrl_DIV | ctrl_MULT, resetCounter);
    register div_op_reg(div_op_latch, ctrl_DIV, clock, ctrl_DIV | ctrl_MULT, resetCounter);

    // exception signal assignments
    assign mult_exception = mult_exc & mult_op_latch;
    assign div_exception = div_exc & div_op_latch;

    // counter and ready/reset signals
    ctr counter_inst(counter_val, clock, 1'b1, reset_sig);
    assign reset_count = (mult_reset & mult_op_latch) | (div_reset & div_op_latch);
    assign data_resultRDY = mult_op_latch ? mult_rdy : div_rdy;

    // multiplier, divider logic
    multiplier mult_logic(mult_res, mult_ovf, mult_rdy, mult_reset, op_a_latch, op_b_latch, clock, counter_val);
    divider div_logic(safe_div_res, div_rdy, div_reset, op_a_latch, op_b_latch, clock, counter_val);
    assign div_res = b_zero ? 32'b0 : safe_div_res;

    // final data result selection
    assign data_result = mult_op_latch ? mult_res : div_res;

endmodule
