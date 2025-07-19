module decoder32 (out, select, en);
    output [31:0] out;
    input [4:0] select;
    input en;
    
    assign out = en << select;
endmodule