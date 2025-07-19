module or_32_bitwise(a, b, res);
    input [31:0] a;
    input [31:0] b;
    output [31:0] res;
    
    or or_gate0(res[0], a[0], b[0]);
    or or_gate1(res[1], a[1], b[1]);
    or or_gate2(res[2], a[2], b[2]);
    or or_gate3(res[3], a[3], b[3]);
    or or_gate4(res[4], a[4], b[4]);
    or or_gate5(res[5], a[5], b[5]);
    or or_gate6(res[6], a[6], b[6]);
    or or_gate7(res[7], a[7], b[7]);
    or or_gate8(res[8], a[8], b[8]);
    or or_gate9(res[9], a[9], b[9]);
    or or_gate10(res[10], a[10], b[10]);
    or or_gate11(res[11], a[11], b[11]);
    or or_gate12(res[12], a[12], b[12]);
    or or_gate13(res[13], a[13], b[13]);
    or or_gate14(res[14], a[14], b[14]);
    or or_gate15(res[15], a[15], b[15]);
    or or_gate16(res[16], a[16], b[16]);
    or or_gate17(res[17], a[17], b[17]);
    or or_gate18(res[18], a[18], b[18]);
    or or_gate19(res[19], a[19], b[19]);
    or or_gate20(res[20], a[20], b[20]);
    or or_gate21(res[21], a[21], b[21]);
    or or_gate22(res[22], a[22], b[22]);
    or or_gate23(res[23], a[23], b[23]);
    or or_gate24(res[24], a[24], b[24]);
    or or_gate25(res[25], a[25], b[25]);
    or or_gate26(res[26], a[26], b[26]);
    or or_gate27(res[27], a[27], b[27]);
    or or_gate28(res[28], a[28], b[28]);
    or or_gate29(res[29], a[29], b[29]);
    or or_gate30(res[30], a[30], b[30]);
    or or_gate31(res[31], a[31], b[31]);
    
endmodule
