module sll_4_bit(shifted_out, data_in, shift_amt);
    output [31:0] shifted_out;
    input [31:0] data_in;
    input shift_amt;

    assign shifted_out = shift_amt ? {data_in[27:0], 4'b0000} : data_in;
endmodule
