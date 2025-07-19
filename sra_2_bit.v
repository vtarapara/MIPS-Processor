module sra_2_bit(shifted_out, data_in, shift_amt);
    output [31:0] shifted_out;
    input [31:0] data_in;
    input shift_amt;

    assign shifted_out = shift_amt ? {{2{data_in[31]}}, data_in[31:2]} : data_in;
endmodule
