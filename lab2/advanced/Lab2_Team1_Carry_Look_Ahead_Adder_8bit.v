`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [8-1:0] a, b;
input c0;
output [8-1:0] s;
output c8;
wire [8-1:0] p, g;
wire c1, c2, c3, c4, c5, c6, c7;
wire g03, g47, p03, p47;
Generator_for_p_g_s g0(a[0], b[0], c0, p[0], g[0], s[0]);
Generator_for_p_g_s g1(a[1], b[1], c1, p[1], g[1], s[1]);
Generator_for_p_g_s g2(a[2], b[2], c2, p[2], g[2], s[2]);
Generator_for_p_g_s g3(a[3], b[3], c3, p[3], g[3], s[3]);
Generator_for_p_g_s g4(a[4], b[4], c4, p[4], g[4], s[4]);
Generator_for_p_g_s g5(a[5], b[5], c5, p[5], g[5], s[5]);
Generator_for_p_g_s g6(a[6], b[6], c6, p[6], g[6], s[6]);
Generator_for_p_g_s g7(a[7], b[7], c7, p[7], g[7], s[7]);

Carry_Look_Ahead_Gen_4bit cla0(p[3:0], g[3:0], c0, c1, c2, c3, p03, g03);
Carry_Look_Ahead_Gen_4bit cla1(p[7:4], g[7:4], c4, c5, c6, c7, p47, g47);

Carry_Look_Ahead_Gen_2bit cla2(p03, p47, g03, g47, c0, c4, c8);

endmodule
//PG : group propagate
//GG : group generate
module Carry_Look_Ahead_Gen_4bit(pin, gin, cin, cout1, cout2, cout3, PG, GG);
input [4-1:0] pin, gin;
input cin;
output cout1, cout2, cout3;
output PG, GG;
wire [3-1:0] t_c;
wire p0c0, p1c1, p2c2;
wire g2p3, g1p3p2, g0p3p2p1;
//c1 = g0 + p0c0
And_gate a0(p0c0, pin[0], cin);
Or_gate o0(t_c[0], gin[0], p0c0);
//c2 = g1 + p1c1 = g1 + p1(g0 + p0c0)
And_gate a1(p1c1, pin[1], t_c[0]);
Or_gate o1(t_c[1], gin[1], p1c1);
//c3 = g2 + p2c2 = g2 + p2(g1 + p1(g0 + p0c0))
And_gate a2(p2c2, pin[2], t_c[1]);
Or_gate o2(t_c[2], gin[2], p2c2);

And_gate a3(cout1, t_c[0], t_c[0]);
And_gate a4(cout2, t_c[1], t_c[1]);
And_gate a5(cout3, t_c[2], t_c[2]);
//pg = p0p1p2p3
And_gate_4bit a6(PG, pin[0], pin[1], pin[2], pin[3]);
//gg = g3 + g2p3 + g1p3p2 + g0p3p2p1
And_gate a7(g2p3, gin[2], pin[3]);
And_gate_3bit a8(g1p3p2, gin[1], pin[3], pin[2]);
And_gate_4bit a9(g0p3p2p1, gin[0], pin[3], pin[2], pin[1]);
Or_gate_4bit o3(GG, gin[3], g2p3, g1p3p2, g0p3p2p1);
endmodule

module Carry_Look_Ahead_Gen_2bit(PG1, PG2, GG1, GG2, cin, cout1, cout2);
input PG1, PG2, GG1, GG2, cin;
output cout1, cout2;
wire [2-1:0] t_c;
wire p0c0, p1c1;
//CG (cout group) = gg + pg*cin (the same as c1 in cla_4bit)
//c1 = g0 + p0c0
And_gate a0(p0c0, PG1, cin);
Or_gate o0(t_c[0], GG1, p0c0);
//c2 = g1 + p1c1 = g1 + p1(g0 + p0c0)
And_gate a1(p1c1, PG2, t_c[0]);
Or_gate o1(t_c[1], GG2, p1c1);

And_gate a2(cout1, t_c[0], t_c[0]);
And_gate a3(cout2, t_c[1], t_c[1]);
endmodule

module Generator_for_p_g_s(a, b, c, p, g, s);
input a, b, c;
output p, g, s;
//p = a xor b
Xor_gate o0(p, a, b);
//g = a x b
And_gate a0(g, a, b);
//s = a xor b xor c
Xor_gate x0(s, p, c);
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

module Or_gate_4bit(out, in1, in2, in3, in4);
input in1, in2, in3, in4;
output out;
wire in1_or_in2, in123;
Or_gate a0(in1_or_in2, in1, in2);
Or_gate a1(in123, in3, in1_or_in2);
Or_gate a2(out, in123, in4);
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

module And_gate_3bit(out, in1, in2, in3);
input in1, in2, in3;
output out;
wire in1_and_in2;
And_gate a0(in1_and_in2, in1, in2);
And_gate a1(out, in3, in1_and_in2);
endmodule

module And_gate_4bit(out, in1, in2, in3, in4);
input in1, in2, in3, in4;
output out;
wire in1_and_in2, in123;
And_gate a0(in1_and_in2, in1, in2);
And_gate a1(in123, in3, in1_and_in2);
And_gate a2(out, in123, in4);
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