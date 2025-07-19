module tristate_buffer(
    output [31:0] out,
    input [31:0] in,
    input en
);
    assign out = en ? in : 32'bz;

endmodule
