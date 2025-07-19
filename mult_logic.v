module mult_logic(
    output [64:0] next_prod,
    output sub,
    output shift,
    output ctrlWE,
    input [64:0] shifted_prod,
    input [31:0] multiplicand,
    input [2:0] opcode,
    input clock,
    input reset
);
    // control signals derived from opcode
    mux_8_onebit subCtrl(sub, opcode, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
    mux_8_onebit shiftCtrl(shift, opcode, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
    mux_8_onebit weCtrl(ctrlWE, opcode, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);

    wire [31:0] shifted, negated, mul_input, adder_partial_sum;
    wire add_ovf;
    wire [64:0] post_add_product;

    assign shifted = shift ? multiplicand << 1 : multiplicand;
    not_32_bitwise negate(shifted, negated);
    assign mul_input = sub ? negated : shifted;
    cla_32 add(adder_partial_sum, add_ovf, shifted_prod[64:33], mul_input, sub);

    assign post_add_product[64:33] = adder_partial_sum;
    assign post_add_product[32:0] = shifted_prod[32:0];

    assign next_prod = ctrlWE ? $signed(shifted_prod) >>> 2 : $signed(post_add_product) >>> 2;
endmodule
