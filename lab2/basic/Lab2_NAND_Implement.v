`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
wire n_sel0, n_sel1, n_sel2;
wire sel0, sel1, sel2, sel3;
wire sel4, sel5, sel6, sel7;
wire a_nand_b, a_and_b, a_or_b, a_nor_b;
wire a_xor_b, a_xnor_b, n_a;
wire temp0, temp1, temp2, temp3;
wire temp4, temp5, temp6, temp7;
wire t01, t23, t45, t67;
wire t0123, t4567;
Not_gate n0(n_sel0, sel[0]);
Not_gate n1(n_sel1, sel[1]);
Not_gate n2(n_sel2, sel[2]);
And_gate_3bit a0(sel0, n_sel2, n_sel1, n_sel0);//000
And_gate_3bit a1(sel1, n_sel2, n_sel1, sel[0]);//001
And_gate_3bit a2(sel2, n_sel2, sel[1], n_sel0);//010
And_gate_3bit a3(sel3, n_sel2, sel[1], sel[0]);//011
And_gate_3bit a4(sel4, sel[2], n_sel1, n_sel0);//100
And_gate_3bit a5(sel5, sel[2], n_sel1, sel[0]);//101
And_gate_3bit a6(sel6, sel[2], sel[1], n_sel0);//110
And_gate_3bit a7(sel7, sel[2], sel[1], sel[0]);//111

nand na0(a_nand_b, a, b);
And_gate an0(a_and_b, a, b);
Or_gate o0(a_or_b, a, b);
Not_gate n3(a_nor_b, a_or_b);
Xor_gate o1(a_xor_b, a, b);
Not_gate n6(a_xnor_b, a_xor_b);
Not_gate n4(n_a, a);

And_gate an3(temp0, a_nand_b, sel0);
And_gate an4(temp1, a_and_b, sel1);
And_gate an5(temp2, a_or_b, sel2);
And_gate an6(temp3, a_nor_b, sel3);
And_gate an7(temp4, a_xor_b, sel4);
And_gate an8(temp5, a_xnor_b, sel5);
And_gate an9(temp6, n_a, sel6);
And_gate an10(temp7, n_a, sel7);

Or_gate o2(t01, temp0, temp1);
Or_gate o3(t23, temp2, temp3);
Or_gate o4(t45, temp4, temp5);
Or_gate o5(t67, temp6, temp7);
Or_gate o6(t0123, t01, t23);
Or_gate o7(t4567, t45, t67);
Or_gate o8(out, t0123, t4567);

endmodule

module Not_gate(out, in);
input in;
output out;
nand n0(out, in, in);
endmodule

module Or_gate(out, in1, in2);
input in1, in2;
output out;
wire n_in1, n_in2;
Not_gate n0(n_in1, in1);
Not_gate n1(n_in2, in2);
nand n2(out, n_in1, n_in2);
endmodule

module And_gate(out, in1, in2);
input in1, in2;
output out;
wire n_in1, n_in2;
wire n_in1_Or_n_in2;
Not_gate n0(n_in1, in1);
Not_gate n1(n_in2, in2);
Or_gate o0(n_in1_Or_n_in2, n_in1, n_in2);
Not_gate n2(out, n_in1_Or_n_in2);
endmodule

module Xor_gate(out, in1, in2);
input in1, in2;
output out;
wire n_in1, n_in2;
wire nin1_in2, in1_nin2;
Not_gate n4(n_in1, in1);
Not_gate n5(n_in2, in2);

And_gate an1(nin1_in2, n_in1, in2);
And_gate an2(in1_nin2, in1, n_in2);
Or_gate o1(out, nin1_in2, in1_nin2);

endmodule

module And_gate_3bit(out, in1, in2, in3);
input in1, in2, in3;
output out;
wire in1_and_in2;
And_gate a0(in1_and_in2, in1, in2);
And_gate a1(out, in3, in1_and_in2);
endmodule


