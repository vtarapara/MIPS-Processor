module mux_2_onebit(out, select, in0, in1);
    input select;
    input in0, in1;
    output out;
    assign out = select ? in1 : in0;
endmodule 

module mux_4_onebit(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input in0, in1, in2, in3;
    output out;
    wire w1, w2;
    mux_2_onebit first_top(w1, select[0], in0, in1);
    mux_2_onebit first_bottom(w2, select[0], in2, in3);
    mux_2_onebit second(out, select[1], w1, w2);
endmodule

module mux_8_onebit(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input [2:0] select;
    input in0, in1, in2, in3, in4, in5, in6, in7;
    output out;
    wire w1, w2;

    mux_4_onebit upper(w1, select[1:0], in0, in1, in2, in3);
    mux_4_onebit lower(w2, select[1:0], in4, in5, in6, in7);
    mux_2_onebit final(out, select[2], w1, w2);
endmodule
