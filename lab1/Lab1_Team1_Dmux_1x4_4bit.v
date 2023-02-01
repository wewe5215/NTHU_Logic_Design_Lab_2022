`timescale 1ns/1ps

//*** module
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
module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [4-1:0] in;
input [2-1:0] sel;
output [4-1:0] a, b, c, d;

wire [4-1:0] t1, t2;  

Dmux_1x2_1bit d1(in[0], sel[1], t1[0], t2[0]);
Dmux_1x2_1bit d2(in[1], sel[1], t1[1], t2[1]);
Dmux_1x2_1bit d3(in[2], sel[1], t1[2], t2[2]);
Dmux_1x2_1bit d4(in[3], sel[1], t1[3], t2[3]);

Dmux_1x2_1bit d5(t1[0], sel[0], a[0], b[0]);
Dmux_1x2_1bit d6(t1[1], sel[0], a[1], b[1]);
Dmux_1x2_1bit d7(t1[2], sel[0], a[2], b[2]);
Dmux_1x2_1bit d8(t1[3], sel[0], a[3], b[3]);

Dmux_1x2_1bit d9(t2[0], sel[0], c[0], d[0]);
Dmux_1x2_1bit d10(t2[1], sel[0], c[1], d[1]);
Dmux_1x2_1bit d11(t2[2], sel[0], c[2], d[2]);
Dmux_1x2_1bit d12(t2[3], sel[0], c[3], d[3]);

endmodule
