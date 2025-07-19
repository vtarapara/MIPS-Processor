
module cla_8(s, cout, a, b, c0);

    output [7:0] s;
    output cout;
    input [7:0] a, b;
    input c0;

    wire temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9;
    wire temp10, temp11, temp12, temp13, temp14, temp15, temp16, temp17, temp18;
    wire temp19, temp20, temp21, temp22, temp23, temp24, temp25, temp26, temp27;
    wire temp28, temp29, temp30, temp31, temp32, temp33, temp34, temp35, temp36;

    wire carry1, carry2, carry3, carry4, carry5, carry6, carry7;
    wire prop0, prop1, prop2, prop3, prop4, prop5, prop6, prop7;
    wire gen0, gen1, gen2, gen3, gen4, gen5, gen6, gen7;

    xor x1(s[0], a[0], b[0], c0);
    xor x2(s[1], a[1], b[1], carry1);
    xor x3(s[2], a[2], b[2], carry2);
    xor x4(s[3], a[3], b[3], carry3);
    xor x5(s[4], a[4], b[4], carry4);
    xor x6(s[5], a[5], b[5], carry5);
    xor x7(s[6], a[6], b[6], carry6);
    xor x8(s[7], a[7], b[7], carry7);

    // stage breaking
    or o1(prop0, a[0], b[0]);
    or o2(carry1, gen0, temp0);
    and a1(gen0, a[0], b[0]);
    and a2(temp0, prop0, c0);

    or o3(prop1, a[1], b[1]);
    or o4(carry2, gen1, temp1, temp2);
    and a3(gen1, a[1], b[1]);
    and a4(temp1, prop1, gen0);
    and a5(temp2, prop1, prop0, c0);

    or o5(prop2, a[2], b[2]);
    or o6(carry3, gen2, temp3, temp4, temp5);
    and a6(gen2, a[2], b[2]);
    and a7(temp3, prop2, gen1);
    and a8(temp4, prop2, prop1, gen0);
    and a9(temp5, prop2, prop1, prop0, c0);

    or o7(prop3, a[3], b[3]);
    or o8(carry4, gen3, temp6, temp7, temp8, temp9);
    and a10(gen3, a[3], b[3]);
    and a11(temp6, prop3, gen2);
    and a12(temp7, prop3, prop2, gen1);
    and a13(temp8, prop3, prop2, prop1, gen0);
    and a14(temp9, prop3, prop2, prop1, prop0, c0);

    or o9(prop4, a[4], b[4]);
    or o10(carry5, gen4, temp10, temp11, temp12, temp13, temp14);
    and a15(gen4, a[4], b[4]);
    and a16(temp10, prop4, gen3);
    and a17(temp11, prop4, prop3, gen2);
    and a18(temp12, prop4, prop3, prop2, gen1);
    and a19(temp13, prop4, prop3, prop2, prop1, gen0);
    and a20(temp14, prop4, prop3, prop2, prop1, prop0, c0);

    or o11(prop5, a[5], b[5]);
    or o12(carry6, gen5, temp15, temp16, temp17, temp18, temp19, temp20);
    and a21(gen5, a[5], b[5]);
    and a22(temp15, prop5, gen4);
    and a23(temp16, prop5, prop4, gen3);
    and a24(temp17, prop5, prop4, prop3, gen2);
    and a25(temp18, prop5, prop4, prop3, prop2, gen1);
    and a26(temp19, prop5, prop4, prop3, prop2, prop1, gen0);
    and a27(temp20, prop5, prop4, prop3, prop2, prop1, prop0, c0);

    or o13(prop6, a[6], b[6]);
    or o14(carry7, gen6, temp21, temp22, temp23, temp24, temp25, temp26, temp27);
    and a28(gen6, a[6], b[6]);
    and a29(temp21, prop6, gen5);
    and a30(temp22, prop6, prop5, gen4);
    and a31(temp23, prop6, prop5, prop4, gen3);
    and a32(temp24, prop6, prop5, prop4, prop3, gen2);
    and a33(temp25, prop6, prop5, prop4, prop3, prop2, gen1);
    and a34(temp26, prop6, prop5, prop4, prop3, prop2, prop1, gen0);
    and a35(temp27, prop6, prop5, prop4, prop3, prop2, prop1, prop0, c0);

    or o15(prop7, a[7], b[7]);
    or o16(cout, gen7, temp28, temp29, temp30, temp31, temp32, temp33, temp34, temp35);
    and a36(gen7, a[7], b[7]);
    and a37(temp28, prop7, gen6);
    and a38(temp29, prop7, prop6, gen5);
    and a39(temp30, prop7, prop6, prop5, gen4);
    and a40(temp31, prop7, prop6, prop5, prop4, gen3);
    and a41(temp32, prop7, prop6, prop5, prop4, prop3, gen2);
    and a42(temp33, prop7, prop6, prop5, prop4, prop3, prop2, gen1);
    and a43(temp34, prop7, prop6, prop5, prop4, prop3, prop2, prop1, gen0);
    and a44(temp35, prop7, prop6, prop5, prop4, prop3, prop2, prop1, prop0, c0);

endmodule