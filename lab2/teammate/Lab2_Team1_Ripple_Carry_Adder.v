`timescale 1ns/1ps

//*** main
module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output cout;
output [8-1:0] sum;

wire[7:1] c;
Full_Adder f1(a[0], b[0], cin, c[1], sum[0]);
Full_Adder f2(a[1], b[1], c[1], c[2], sum[1]);
Full_Adder f3(a[2], b[2], c[2], c[3], sum[2]);
Full_Adder f4(a[3], b[3], c[3], c[4], sum[3]);
Full_Adder f5(a[4], b[4], c[4], c[5], sum[4]);
Full_Adder f6(a[5], b[5], c[5], c[6], sum[5]);
Full_Adder f7(a[6], b[6], c[6], c[7], sum[6]);
Full_Adder f8(a[7], b[7], c[7], cout, sum[7]);

endmodule

//Full
module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire tmp;
Xor_gate x0(tmp, a, b);
Xor_gate x1(sum, tmp, cin);

Majority m0(a, b, cin, cout);

endmodule

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

// and_gate
module And_gate (out, in1, in2);
input in1, in2;
output out;

wire tmp;
nand n1(tmp, in1, in2);
nand n2(out, tmp, tmp);

endmodule

// majority
module Majority(a, b, c, out);
input a, b, c;
output out;

wire t1, t2, t3;
And_gate a0(t1, a, b);
And_gate a1(t2, a, c);
And_gate a2(t3, b, c);

wire t4;
Or_gate o0(t4, t1, t2);
Or_gate o1(out, t3, t4); 

endmodule
