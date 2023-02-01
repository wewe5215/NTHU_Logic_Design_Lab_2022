`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;
wire [4-1:0] func0, func1, func2, func3;
wire [4-1:0] func4, func5, func6, func7;
//for function
Sub f0(rs, rt, func0);
Add f1(rs, rt, func1);
Bitwise_Or f2(rs, rt, func2);
Bitwise_And f3(rs, rt, func3);
Rt_Ari_right_shift f4(rt, func4);
Rs_Cir_right_shift f5(rs, func5);
Compare_Lt f6(rs, rt, func6);
Compare_Eq f7(rs, rt, func7);

Mux_8x1_4bit m0(func0, func1, func2, func3, func4, func5, func6, func7, sel, rd);
endmodule

module Sub(rs, rt, rd);
input [4-1:0] rs, rt;
output [4-1:0] rd;
wire [4-1:0] rt_comp;
wire [4-1:0] cout;
Twos_complement c0(rt, rt_comp);
Full_Adder fa0(rs[0], rt_comp[0], 1'b1, cout[0], rd[0]);
Full_Adder fa1(rs[1], rt_comp[1], cout[0], cout[1], rd[1]);
Full_Adder fa2(rs[2], rt_comp[2], cout[1], cout[2], rd[2]);
Full_Adder fa3(rs[3], rt_comp[3], cout[2], cout[3], rd[3]);
endmodule

module Add(rs, rt, rd);
input [4-1:0] rs, rt;
output [4-1:0] rd;
wire [3:0] cout;
Full_Adder fa0(rs[0], rt[0], 1'b0   , cout[0], rd[0]);
Full_Adder fa1(rs[1], rt[1], cout[0], cout[1], rd[1]);
Full_Adder fa2(rs[2], rt[2], cout[1], cout[2], rd[2]);
Full_Adder fa3(rs[3], rt[3], cout[2], cout[3], rd[3]);
endmodule

module Bitwise_Or(rs, rt, rd);
input [4-1:0] rs, rt;
output [4-1:0] rd;
Or_gate o0(rd[0], rs[0], rt[0]);
Or_gate o1(rd[1], rs[1], rt[1]);
Or_gate o2(rd[2], rs[2], rt[2]);
Or_gate o3(rd[3], rs[3], rt[3]);
endmodule

module Bitwise_And(rs, rt, rd);
input [4-1:0] rs, rt;
output [4-1:0] rd;
And_gate a0(rd[0], rs[0], rt[0]);
And_gate a1(rd[1], rs[1], rt[1]);
And_gate a2(rd[2], rs[2], rt[2]);
And_gate a3(rd[3], rs[3], rt[3]);
endmodule

module Rt_Ari_right_shift(rt, rd);
input [4-1:0] rt;
output [4-1:0] rd;
//rd = {rt[3], rt[3:1]}
And_gate a0(rd[0], rt[1], rt[1]);
And_gate a1(rd[1], rt[2], rt[2]);
And_gate a2(rd[2], rt[3], rt[3]);
And_gate a3(rd[3], rt[3], rt[3]);
endmodule

module Rs_Cir_right_shift(rs, rd);
input [4-1:0] rs;
output [4-1:0] rd;
//rs = {rs[2:0], rs[3]}
And_gate a0(rd[0], rs[3], rs[3]);
And_gate a1(rd[1], rs[0], rs[0]);
And_gate a2(rd[2], rs[1], rs[1]);
And_gate a3(rd[3], rs[2], rs[2]);
endmodule

module Compare_Lt(rs, rt, rd);
input [4-1:0] rs, rt;
output [4-1:0] rd;
wire [4-1:0] x;
wire [4-1:0] n_rs, temp; 
//rd = {3'b101, rs < rt}
And_gate a1(rd[1], 1'b1, 1'b1);
And_gate a2(rd[2], 1'b0, 1'b0);
And_gate a3(rd[3], 1'b1, 1'b1);
//x[3:0]
Xnor_gate x0(x[0], rs[0], rt[0]);
Xnor_gate x1(x[1], rs[1], rt[1]);
Xnor_gate x2(x[2], rs[2], rt[2]);
Xnor_gate x3(x[3], rs[3], rt[3]);
//n_rs[3:0]
Not_gate n0(n_rs[0], rs[0]);
Not_gate n1(n_rs[1], rs[1]);
Not_gate n2(n_rs[2], rs[2]);
Not_gate n3(n_rs[3], rs[3]);
//temp0 = x3x2x1a0'b0
And_gate_5bit a4(temp0, x[3], x[2], x[1], n_rs[0], rt[0]);
//temp1 = x3x2a1'b1
And_gate_4bit a5(temp1, x[3], x[2], n_rs[1], rt[1]);
//temp2 = x3a2'b2
And_gate_3bit a6(temp2, x[3], n_rs[2], rt[2]);
//temp3 = a3'b3
And_gate a7(temp3, n_rs[3], rt[3]);
//x3x2x1a0'b0 + x3x2a1'b1 + x3a2'b2 + a3'b3
Or_gate_4bit o0(rd[0], temp0, temp1, temp2, temp3);
endmodule

module Compare_Eq(rs, rt, rd);
input [4-1:0] rs, rt;
output [4-1:0] rd;
wire [4-1:0] x;
//rd = {3'b111, rs = rt}
And_gate a1(rd[1], 1'b1, 1'b1);
And_gate a2(rd[2], 1'b1, 1'b1);
And_gate a3(rd[3], 1'b1, 1'b1);

//rs = rt
//xi = aibi + ai'bi'
//a = b iff x3x2x1x0 = 1

//x0
Xnor_gate x0(x[0], rs[0], rt[0]);
//x1
Xnor_gate x1(x[1], rs[1], rt[1]);
//x2
Xnor_gate x2(x[2], rs[2], rt[2]);
//x3
Xnor_gate x3(x[3], rs[3], rt[3]);
//x3x2x1x0
And_gate_4bit a0(rd[0], x[0], x[1], x[2], x[3]);

endmodule

module Mux_8x1_4bit(in0, in1, in2, in3, in4, in5, in6, in7, sel, out);
input [4-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
input [3-1:0] sel;
output [4-1:0] out;
wire n_sel0, n_sel1, n_sel2;
wire [8-1:0] op;
wire [4-1:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
//for op_code
Not_gate n0(n_sel0, sel[0]);
Not_gate n1(n_sel1, sel[1]);
Not_gate n2(n_sel2, sel[2]);
And_gate_3bit a0(op[0], n_sel2, n_sel1, n_sel0);//000
And_gate_3bit a1(op[1], n_sel2, n_sel1, sel[0]);//001
And_gate_3bit a2(op[2], n_sel2, sel[1], n_sel0);//010
And_gate_3bit a3(op[3], n_sel2, sel[1], sel[0]);//011
And_gate_3bit a4(op[4], sel[2], n_sel1, n_sel0);//100
And_gate_3bit a5(op[5], sel[2], n_sel1, sel[0]);//101
And_gate_3bit a6(op[6], sel[2], sel[1], n_sel0);//110
And_gate_3bit a7(op[7], sel[2], sel[1], sel[0]);//111

filter f0(in0, op[0], temp0);
filter f1(in1, op[1], temp1);
filter f2(in2, op[2], temp2);
filter f3(in3, op[3], temp3);
filter f4(in4, op[4], temp4);
filter f5(in5, op[5], temp5);
filter f6(in6, op[6], temp6);
filter f7(in7, op[7], temp7);

Or_gate_8bit o0(out[0], temp0[0], temp1[0], temp2[0], temp3[0], temp4[0], temp5[0], temp6[0], temp7[0]);
Or_gate_8bit o1(out[1], temp0[1], temp1[1], temp2[1], temp3[1], temp4[1], temp5[1], temp6[1], temp7[1]);
Or_gate_8bit o2(out[2], temp0[2], temp1[2], temp2[2], temp3[2], temp4[2], temp5[2], temp6[2], temp7[2]);
Or_gate_8bit o3(out[3], temp0[3], temp1[3], temp2[3], temp3[3], temp4[3], temp5[3], temp6[3], temp7[3]);
endmodule

module filter(in, sel, out);
input [4-1:0]in;
input sel;
output [4-1:0] out;

And_gate a0(out[0], sel, in[0]);
And_gate a1(out[1], sel, in[1]);
And_gate a2(out[2], sel, in[2]);
And_gate a3(out[3], sel, in[3]);
endmodule

module Twos_complement(in, out);
input [4-1:0] in;
output [4-1:0] out;
Not_gate n0(out[0], in[0]);
Not_gate n1(out[1], in[1]);
Not_gate n2(out[2], in[2]);
Not_gate n3(out[3], in[3]);
endmodule



module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire temp;
//sum = a xor b xor cin
Xor_gate o0(temp, a, b);
Xor_gate o1(sum, temp, cin);
//cout = ab + bc + ac
Majority m0(a, b, cin, cout);
endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;
wire a_and_b, b_and_c, a_and_c;
wire ab_or_ac;
And_gate a0(a_and_b, a, b);
And_gate a1(b_and_c, b, c);
And_gate a2(a_and_c, a, c);
Or_gate o0(ab_or_ac, a_and_b, a_and_c);
Or_gate o1(out, ab_or_ac, b_and_c);
endmodule

module And_gate(out, a, b);
input a, b;
output out;
wire a_and_nb;
Universal_Gate u0(a, b, a_and_nb);
Universal_Gate u1(a, a_and_nb, out);
endmodule

module Or_gate(out, a, b);
input a, b;
output out;
wire n_a, n_b;
wire na_and_nb;
Not_gate n0(n_a, a);
Not_gate n1(n_b, b);
And_gate a0(na_and_nb, n_a, n_b);
Not_gate n2(out, na_and_nb);
endmodule

module Not_gate(out, a);
input a;
output out;
Universal_Gate u0(1'b1, a, out);
endmodule

module Xnor_gate(out, a, b);
input a, b;
output out;
wire n_a, n_b;
wire na_b, a_nb;
wire a_xor_b;
//a xor b = a'b + ab'
Not_gate n0(n_a, a);
Not_gate n1(n_b, b);
And_gate a0(na_b, n_a, b);
And_gate a1(a_nb, a, n_b);
Or_gate o0(a_xor_b, na_b, a_nb);
Not_gate n2(out, a_xor_b);
endmodule

module Xor_gate(out, a, b);
input a, b;
output out;
wire n_a, n_b;
wire na_b, a_nb;
//a xor b = a'b + ab'
Not_gate n0(n_a, a);
Not_gate n1(n_b, b);
And_gate a0(na_b, n_a, b);
And_gate a1(a_nb, a, n_b);
Or_gate o0(out, na_b, a_nb);
endmodule

module And_gate_3bit(out, a, b, c);
input a, b, c;
output out;
wire a_and_b;
And_gate a0(a_and_b, a, b);
And_gate a1(out, c, a_and_b);
endmodule

module And_gate_4bit(out, a, b, c, d);
input a, b, c, d;
output out;
wire ab, abc;
And_gate a0(ab, a, b);
And_gate a1(abc, c, ab);
And_gate a2(out, d, abc);
endmodule

module Or_gate_4bit(out, a, b, c, d);
input a, b, c, d;
output out;
wire ab, abc;
Or_gate o0(ab, a, b);
Or_gate o1(abc, c, ab);
Or_gate o2(out, d, abc);
endmodule

module And_gate_5bit(out, a, b, c, d, e);
input a, b, c, d, e;
output out;
wire ab, abc, abcd;
And_gate a0(ab, a, b);
And_gate a1(abc, c, ab);
And_gate a2(abcd, d, abc);
And_gate a3(out, e, abcd);
endmodule

module Or_gate_8bit(out, a, b, c, d, e, f, g, h);
input a, b, c, d, e, f, g, h;
output out;
wire ab, abc, abcd, abcde, abcdef, abcdefg;
Or_gate o0(ab, a, b);
Or_gate o1(abc, c, ab);
Or_gate o2(abcd, d, abc);
Or_gate o3(abcde, e, abcd);
Or_gate o4(abcdef, f, abcde);
Or_gate o5(abcdefg, g, abcdef);
Or_gate o6(out, h, abcdefg);
endmodule