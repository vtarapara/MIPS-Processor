module sll_32_bit(shifted_out, data_in, shift_amt);
    output [31:0] shifted_out;
    input [31:0] data_in;
    input [4:0] shift_amt;

    wire [31:0] w1, w2, w3, w4;

    sll_1_bit s1(w1, data_in, shift_amt[0]);
    sll_2_bit s2(w2, w1, shift_amt[1]);
    sll_4_bit s3(w3, w2, shift_amt[2]);
    sll_8_bit s4(w4, w3, shift_amt[3]);
    sll_16_bit s5(shifted_out, w4, shift_amt[4]);
endmodule
