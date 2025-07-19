module div_logic(
    output [63:0] next_quotient,
    input [63:0] shifted_quotient,
    input [31:0] divisor
);
    wire is_sub, is_0;
    wire [31:0] negated, selected, nonzero_div, sum_res;
    
    // Negate divisor if subtraction is required
    not_32_bitwise negateDivisor(divisor, negated);
    assign is_sub = ~shifted_quotient[63]; // Determine if subtraction is needed based on shifted_quotient MSB
    assign selected = is_sub ? negated : divisor; // Choose negated or original divisor
    
    // Ensure divisor is not zero for division (safety check)
    assign is_0 = ~| divisor;
    assign nonzero_div = is_0 ? 32'b1 : selected; // Use a non-zero divisor
    
    // Perform addition/subtraction with the chosen divisor
    cla_32 computeSum(sum_res, , shifted_quotient[63:32], nonzero_div, is_sub);
    
    // Prepare next AQ value
    assign next_quotient[63:32] = sum_res;
    assign next_quotient[31:1] = shifted_quotient[31:1];
    assign next_quotient[0] = ~next_quotient[63]; // Invert LSB for the next cycle, assuming a correction step

endmodule
