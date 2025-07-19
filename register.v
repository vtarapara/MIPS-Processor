module register(q, d, clk, en, clr);
    output q;
    input d;
    input clk;
    input en;
    input clr;

    dffe_ref flip_flop(q, d, clk, en, clr);
endmodule