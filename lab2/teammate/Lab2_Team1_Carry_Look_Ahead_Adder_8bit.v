`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [8-1:0] a, b;
input c0;
output [8-1:0] s;
output c8;

wire [7:0] g, p;
wire c4; 
wire c1, c2, c3, c5, c6, c7;

pgsgen p0(a[0], b[0], c0, p[0], g[0], s[0]); //in, in, in, out, out
pgsgen p1(a[1], b[1], c1, p[1], g[1], s[1]);
pgsgen p2(a[2], b[2], c2, p[2], g[2], s[2]);
pgsgen p3(a[3], b[3], c3, p[3], g[3], s[3]);

pgsgen p4(a[4], b[4], c4, p[4], g[4], s[4]);
pgsgen p5(a[5], b[5], c5, p[5], g[5], s[5]);
pgsgen p6(a[6], b[6], c6, p[6], g[6], s[6]);
pgsgen p7(a[7], b[7], c7, p[7], g[7], s[7]);

wire g_up, g_down, p_up, p_down; 
CLA_Gen_4bit C0(g[3:0], p[3:0], c0, c1, c2, c3,  g_up, p_up);
CLA_Gen_4bit C1(g[7:4], p[7:4], c4, c5, c6, c7,  g_down, p_down);

CLA_Gen_2bit C3(g_up, g_down, p_up, p_down, c0, c4, c8);
endmodule

// generating p&g&s
module pgsgen(a, b, cin, p, g, s);
input a, b, cin;
output p, g, s;

wire tmp;
Xor_gate x0(tmp, a, b); //tmp=p
And_gate a0(g, a, b); //g-> generator 

Xor_gate x1(s, tmp, cin); //s
And_gate a1(p, tmp, tmp);

endmodule

//* module1
//PG : group propagate; GG : group generate
module CLA_Gen_4bit(g, p, c0, c_out1, c_out2, c_out3, GG, PG);
input [3:0] g, p;
input c0;
output c_out1, c_out2, c_out3;
output GG, PG;

wire p0c0, p1c1, p2c2;
wire c_tmp1, c_tmp2;
//c1 = p0*c0 + g0
And_gate a0(p0c0, p[0], c0);
Or_gate o0(c_tmp1, g[0], p0c0); 

//c2 = p1*c1 + g1 = (p1p0c0 + p1g0) + g1
And_gate a1(p1c1, p[1], c_tmp1);
Or_gate o1(c_tmp2, g[1], p1c1); 

//c3 =  p2*c2 + g2
And_gate a2(p2c2, p[2], c_tmp2);
Or_gate o2(c_tmp3, g[2], p2c2); 

And_gate A1(c_out1, c_tmp1, c_tmp1);
And_gate A2(c_out2, c_tmp2, c_tmp2);
And_gate A3(c_out3, c_tmp3, c_tmp3);

//g_out, p_out
//p_out = p0p1p2p3
And_gate_4bits a3(PG, p[0], p[1], p[2], p[3]);
//g_out = g3+p3 g2+p3p2 g1+p3p2p1 g0
wire t0, t1, t2;
And_gate_4bits a4(t0, g[0], p[1], p[2], p[3]); //g0 p3p2p1
And_gate_3bits a5(t1, g[1], p[2], p[3]); //g1 p3p2
And_gate a6(t2, g[2], p[3]); //g2 p3
Or_gate_4bits o3(GG, g[3], t2, t1, t0);

endmodule

//* module2
module  CLA_Gen_2bit(g_up, g_down, p_up, p_down, c0, c4, c8);
input g_up, g_down, p_up, p_down, c0;
output c4, c8;

wire t0, t1;
wire c4_tmp;
//c4 = p_up*c0 + g_up
And_gate a0(t0, p_up, c0);
Or_gate o0(c4_tmp, g_up, t0); //c4

//c8 = p_down*c4 + g_down
And_gate a1(t1, p_down, c4_tmp);
Or_gate o1(c8, g_down, t1); //c8

And_gate a2(c4, c4_tmp, c4_tmp);

endmodule

//basic--------------------
//xor_gate
module Xor_gate(out, in1, in2);
input in1, in2;
output out;

wire n_in1, n_in2;
nand n1(n_in1, in1, in1);
nand n2(n_in2, in2, in2);

wire tmp1, tmp2;
And_gate a1(tmp1, in1, n_in2);
And_gate a2(tmp2, n_in1, in2);
Or_gate o1(out, tmp1, tmp2);

endmodule

//or_gate
module Or_gate (out, in1, in2);
input in1, in2;
output out;

wire n_in1, n_in2;
nand n1(n_in1, in1, in1);
nand n2(n_in2, in2, in2);

nand n3(out, n_in1, n_in2);

endmodule

//or_gate_4bits 
module Or_gate_4bits(out, in1, in2, in3, in4);
input in1, in2, in3, in4;
output out;

wire in12, in123;
Or_gate o0(in12, in1, in2);
Or_gate o1(in123, in12, in3);
Or_gate o2(out, in123, in4);

endmodule

// and_gate
module And_gate (out, in1, in2);
input in1, in2;
output out;

wire tmp;
nand n1(tmp, in1, in2);
nand n2(out, tmp, tmp);

endmodule

//and_gate_3bits
module And_gate_3bits(out, in1, in2, in3);
input in1, in2, in3;
output out;

wire in1_and_in2;
And_gate a0(in1_and_in2, in1, in2);
And_gate a1(out, in1_and_in2, in3);

endmodule 

//and_gate_4bits
module And_gate_4bits(out, in1, in2, in3, in4);
input in1, in2, in3, in4;
output out;

wire in1_and_in2_and_in3;
And_gate_3bits a0(in1_and_in2_and_in3, in1, in2, in3);
And_gate a1(out, in1_and_in2_and_in3, in4);

endmodule

