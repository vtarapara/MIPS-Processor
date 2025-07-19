module cla_32(s, cout, a, b, cin);
    output [31:0] s;
    output cout;
    input [31:0] a, b;
    input cin;
    
    wire c0, carry1, carry2, carry3, temp0, temp1, temp2;

    xnor xnorv(temp0, a[31], b[31]);
    xor xorv(temp1, carry3, s[31]);
    and andv(cout, temp0, temp1);

    cla_8 stg0(s[7:0], c0, a[7:0], b[7:0], cin);
    cla_8 stg1(s[15:8], carry1, a[15:8], b[15:8], c0);
    cla_8 stg2(s[23:16], carry2, a[23:16], b[23:16], carry1);
    cla_8 stg3(s[31:24], carry3, a[31:24], b[31:24], carry2);
endmodule

module sub(s, cout, a, b, c0);
    output [31:0] s;
    output cout;
    input [31:0] a;
    input [31:0] b;
    input c0;

    wire [31:0] nb;

    cla_32 a1(s, cout, a, nb, c0);
    not_32_bitwise notb(b, nb);
    
endmodule