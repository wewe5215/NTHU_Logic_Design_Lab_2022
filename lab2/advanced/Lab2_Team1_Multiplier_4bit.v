`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [4-1:0] a, b;
output [8-1:0] p;
wire a0b0;//for p0
wire a0b1, a1b0;//for p1
wire a0b2, a1b1, a2b0;//for p2
wire a0b3, a1b2, a2b1, a3b0;//for p3
wire a1b3, a2b2, a3b1;//for p4
wire a2b3, a3b2;//for p5
wire a3b3;//for p6
wire c_0, c_1;
wire [1:0] c_2, c_5;
wire s_2, s_5;
wire [2:0] c_3, c_4;
wire [1:0] s_3, s_4;
And_gate a0(a0b0, a[0], b[0]);
And_gate a1(a0b1, a[0], b[1]);
And_gate a2(a0b2, a[0], b[2]);
And_gate a3(a0b3, a[0], b[3]);

And_gate a4(a1b0, a[1], b[0]);
And_gate a5(a1b1, a[1], b[1]);
And_gate a6(a1b2, a[1], b[2]);
And_gate a7(a1b3, a[1], b[3]);

And_gate a8 (a2b0, a[2], b[0]);
And_gate a9 (a2b1, a[2], b[1]);
And_gate a10(a2b2, a[2], b[2]);
And_gate a11(a2b3, a[2], b[3]);

And_gate a12(a3b0, a[3], b[0]);
And_gate a13(a3b1, a[3], b[1]);
And_gate a14(a3b2, a[3], b[2]);
And_gate a15(a3b3, a[3], b[3]);

//p0
Full_Adder addr0(a0b0, 1'b0, 1'b0, c_0, p[0]);
//p1
Full_Adder addr1(a0b1, a1b0, c_0, c_1, p[1]);
//p2
Full_Adder addr2(a0b2, a1b1, c_1, c_2[0], s_2);
Full_Adder addr3(s_2, a2b0, 1'b0, c_2[1], p[2]);
//p3
Full_Adder addr4(a0b3, a1b2, c_2[0], c_3[0], s_3[0]);
Full_Adder addr5(s_3[0], a2b1, c_2[1], c_3[1], s_3[1]);
Full_Adder addr6(s_3[1], a3b0, 1'b0, c_3[2], p[3]);
//p4 
Full_Adder addr7(a1b3, a2b2, c_3[0], c_4[0], s_4[0]);
Full_Adder addr8(s_4[0], a3b1, c_3[1], c_4[1], s_4[1]);
Full_Adder addr9(s_4[1], c_3[2], 1'b0, c_4[2], p[4]);
//p5
Full_Adder addr10(a2b3, a3b2, c_4[0], c_5[0], s_5);
Full_Adder addr11(s_5, c_4[1], c_4[2], c_5[1], p[5]);
//p6, p7
Full_Adder addr12(a3b3, c_5[0], c_5[1], p[7], p[6]);
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