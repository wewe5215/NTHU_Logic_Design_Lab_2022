`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output cout;
output [8-1:0] sum;
wire [7-1:0] c;
Full_Adder fa0(a[0], b[0], cin, c[0], sum[0]);
Full_Adder fa1(a[1], b[1], c[0], c[1], sum[1]);
Full_Adder fa2(a[2], b[2], c[1], c[2], sum[2]);
Full_Adder fa3(a[3], b[3], c[2], c[3], sum[3]);
Full_Adder fa4(a[4], b[4], c[3], c[4], sum[4]);
Full_Adder fa5(a[5], b[5], c[4], c[5], sum[5]);
Full_Adder fa6(a[6], b[6], c[5], c[6], sum[6]);
Full_Adder fa7(a[7], b[7], c[6], cout, sum[7]);
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
