`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [4-1:0] in1, in2, in3, in4;
input [5-1:0] control;
output [4-1:0] out1, out2, out3, out4;
wire [3:0] crossbar1_1, crossbar1_2;
wire [3:0] crossbar2_1, crossbar2_2;
wire [3:0] crossbar3_1, crossbar3_2;

Crossbar_2x2_4bit c1(in1, in2, control[0], crossbar1_1, crossbar1_2);
Crossbar_2x2_4bit c2(in3, in4, control[3], crossbar2_1, crossbar2_2);
Crossbar_2x2_4bit c3(crossbar1_2, crossbar2_1, control[2], crossbar3_1, crossbar3_2);
Crossbar_2x2_4bit c4(crossbar1_1, crossbar3_1, control[1], out1, out2);
Crossbar_2x2_4bit c5(crossbar3_2, crossbar2_2, control[4], out3, out4);

endmodule

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
wire [3:0] dmux1_1, dmux1_2, dmux2_1, dmux2_2;
wire n_control;
not n0(n_control, control);

Dmux_1x2_4bit d0(in1, dmux1_1, dmux1_2, control);
Dmux_1x2_4bit d1(in2, dmux2_1, dmux2_2, n_control);

Mux_2x1_4bit m0(dmux1_1, dmux2_1, control, out1);
Mux_2x1_4bit m1(dmux1_2, dmux2_2, n_control, out2);

endmodule

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;
wire n_sel;
not n0(n_sel, sel);

//0
choose c0(in, n_sel, a);
//1
choose c1(in, sel, b);

endmodule

module choose(in, sel, out);

input [3:0] in;
input sel;
output [3:0] out;

and a0(out[0], sel, in[0]);
and a1(out[1], sel, in[1]);
and a2(out[2], sel, in[2]);
and a3(out[3], sel, in[3]);
endmodule

module Mux_2x1_4bit(a, b, sel, f);
input [3:0] a, b;
input sel;
output [3:0] f;

wire n_sel;
wire [3:0] temp0, temp1;
not n0(n_sel, sel);

filter f0(a, n_sel, temp0);
filter f1(b, sel, temp1);

or o0(f[0], temp0[0], temp1[0]);
or o1(f[1], temp0[1], temp1[1]);
or o2(f[2], temp0[2], temp1[2]);
or o3(f[3], temp0[3], temp1[3]);
endmodule

module filter(in, sel, out);
input [3:0] in;
input sel;
output [3:0] out;
and a1(out[0], sel, in[0]);
and a2(out[1], sel, in[1]);
and a3(out[2], sel, in[2]);
and a4(out[3], sel, in[3]);
endmodule