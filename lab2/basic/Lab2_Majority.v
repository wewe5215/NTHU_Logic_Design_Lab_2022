`timescale 1ns/1ps

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