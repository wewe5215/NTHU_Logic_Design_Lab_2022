`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [8-1:0] out1, out2;
wire [3:0] dmux1_1, dmux1_2, dmux2_1, dmux2_2;
wire n_control;
wire [3:0] out_temp1, out_temp2;
not n0(n_control, control);

Dmux_1x2_4bit d0(in1, dmux1_1, dmux1_2, control);
Dmux_1x2_4bit d1(in2, dmux2_1, dmux2_2, n_control);

Mux_2x1_4bit m0(dmux1_1, dmux2_1, control, out_temp1);
Mux_2x1_4bit m1(dmux1_2, dmux2_2, n_control, out_temp2);

fanout f0(out_temp1, out1);
fanout f1(out_temp2, out2);

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

module fanout(in, out);
input [3:0] in;
output [7:0] out;

wire [3:0] n_in;
not n0(n_in[0], in[0]);
not n1(n_in[1], in[1]);
not n2(n_in[2], in[2]);
not n3(n_in[3], in[3]);

not n4(out[0], n_in[0]);
not n5(out[2], n_in[1]);
not n6(out[4], n_in[2]);
not n7(out[6], n_in[3]);

not n8(out[1], n_in[0]);
not n9(out[3], n_in[1]);
not n10(out[5], n_in[2]);
not n11(out[7], n_in[3]);
endmodule