module divider(
    output[31:0] result,
    output resultReady,
    output resetCounter,
    input [31:0] dividend,
    input [31:0] divisor,
    input clock,
    input [5:0] count
);

    wire start = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & ~count[5];
    wire resultReady = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & count[5];
    assign resetCounter = count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & count[5];

    // latch signs
    wire dividend_sign, divisor_sign;
    register latched_dividend(dividend_sign, dividend[31], ~clock, start, resetCounter);
    register latched_divisor(divisor_sign, divisor[31], ~clock, start, resetCounter);

    // twos comp calc
    wire [31:0] select_dividend, select_divisor, twosDividend, twosDivisor;
    wire ovf1, ovf2, main_ovf;

    wire[31:0] negativeDividend; // neg dividend
    not_32_bitwise flip_dividend(dividend, negativeDividend);
    cla_32 add_dividend(twosDividend, ovf1, 32'b1, negativeDividend, 1'b0);

    wire[31:0] negativeDivisor; // neg divisor
    not_32_bitwise flip_divisor(divisor, negativeDivisor);
    cla_32 add_divisor(twosDivisor, ovf2, 32'b1, negativeDivisor, 1'b0);

    // selection basedon signs
    assign select_dividend = dividend_sign ? twosDividend : dividend;
    assign select_divisor = divisor_sign ? twosDivisor : divisor;

    // manage quotient shifting
    wire [63:0] init_quotient, shifted_quotient, next_quotient, select_quotient;
    assign init_quotient [63:32] = 32'b0;
    assign init_quotient [31:0] = select_dividend[31:0];
    assign select_quotient = start ? init_quotient << 1 : next_quotient << 1;
    register64 post_shift(shifted_quotient, select_quotient, clock, 1'b1, resetCounter);
    div_logic control(next_quotient, shifted_quotient, select_divisor);

    // sign adjustment based on original signs
    wire [63:0] match_signs;
    wire [31:0] adjusted_quotient;
    assign match_signs[31:0] = next_quotient[31:0];
    cla_32 adder(adjusted_quotient, main_ovf, shifted_quotient[63:32], select_divisor, 1'b0);
    assign match_signs[63:32] = next_quotient[63] ? adjusted_quotient : next_quotient[63:32];

    // final sign adjustment to correct mismatch
    wire [31:0] res;
    wire positive, twos_ovf;
    assign positive = (~dividend_sign & ~divisor_sign) | (dividend_sign & divisor_sign);

    // for negative outcomes
    wire[31:0] negativeRes;
    not_32_bitwise flip_result(match_signs[31:0], negativeRes);
    cla_32 final_adjustment(res, twos_ovf, 32'b1, negativeRes, 1'b0);

    // fin
    assign result = positive ? match_signs[31:0] : res;

endmodule
