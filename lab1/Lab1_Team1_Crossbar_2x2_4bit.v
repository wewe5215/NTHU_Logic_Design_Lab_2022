`timescale 1ns/1ps

//*** module 1
module Mux_2x1_1bit(in1, in2, control, out);
input in1, in2;
input control;
output out;

wire n_control;
not n(n_control, control);

wire t1, t2;
and a0(t1, in1, n_control);
and a1(t2, in2, control);

or o0(out, t1, t2);

endmodule


//*** module2
module Dmux_1x2_1bit(in, control, out1, out2);
input in;
input control;
output out1, out2;

wire n_control;
not n(n_control, control);

and a1(out1, in, n_control);
and a2(out2, in, control);

endmodule

//*** top module
module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;

wire n_control;
not n(n_control, control);

wire [3:0] t1_1, t1_2, t2_1, t2_2;
// in1 
Dmux_1x2_1bit d1(in1[0], control, t1_1[0], t1_2[0]);
Dmux_1x2_1bit d2(in1[1], control, t1_1[1], t1_2[1]);
Dmux_1x2_1bit d3(in1[2], control, t1_1[2], t1_2[2]);
Dmux_1x2_1bit d4(in1[3], control, t1_1[3], t1_2[3]);
// in2
Dmux_1x2_1bit d5(in2[0], n_control, t2_1[0], t2_2[0]);
Dmux_1x2_1bit d6(in2[1], n_control, t2_1[1], t2_2[1]);
Dmux_1x2_1bit d7(in2[2], n_control, t2_1[2], t2_2[2]);
Dmux_1x2_1bit d8(in2[3], n_control, t2_1[3], t2_2[3]);

//out1
Mux_2x1_1bit m1(t1_1[0], t2_1[0], control, out1[0]);
Mux_2x1_1bit m2(t1_1[1], t2_1[1], control, out1[1]);
Mux_2x1_1bit m3(t1_1[2], t2_1[2], control, out1[2]);
Mux_2x1_1bit m4(t1_1[3], t2_1[3], control, out1[3]);
//out2
Mux_2x1_1bit m5(t1_2[0], t2_2[0], n_control, out2[0]);
Mux_2x1_1bit m6(t1_2[1], t2_2[1], n_control, out2[1]);
Mux_2x1_1bit m7(t1_2[2], t2_2[2], n_control, out2[2]);
Mux_2x1_1bit m8(t1_2[3], t2_2[3], n_control, out2[3]);

endmodule
