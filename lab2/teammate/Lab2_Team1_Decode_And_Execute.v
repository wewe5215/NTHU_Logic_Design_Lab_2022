`timescale 1ns/1ps

//***main
module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;

wire [3:0] tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
SUB f1(rs, rt, tmp0); //000
ADD f0(rs, rt, tmp1); //001
bitwise_or f2(rs, rt, tmp2); //010
bitwise_and f3(rs, rt, tmp3); //011
rt_ari_right_shift f4(rt, tmp4); //100
rs_cir_left_shift f5(rs, tmp5); //101
compare_lt f6(rs, rt, tmp6); //110
compare_eq f7(rs, rt, tmp7); //111

Mux_8x1_4bit m0(tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, sel, rd);

endmodule

module Mux_8x1_4bit(in0, in1, in2, in3, in4, in5, in6, in7, sel, out);
input [4-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
input [3-1:0] sel;
output [4-1:0] out;
wire n_sel0, n_sel1, n_sel2;
wire [8-1:0] op;
wire [4-1:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
//for op_code
Not_gate n0(n_sel0, sel[0]);
Not_gate n1(n_sel1, sel[1]);
Not_gate n2(n_sel2, sel[2]);

And_gate_3bit a0(op[0], n_sel2, n_sel1, n_sel0);//000
And_gate_3bit a1(op[1], n_sel2, n_sel1, sel[0]);//001
And_gate_3bit a2(op[2], n_sel2, sel[1], n_sel0);//010
And_gate_3bit a3(op[3], n_sel2, sel[1], sel[0]);//011
And_gate_3bit a4(op[4], sel[2], n_sel1, n_sel0);//100
And_gate_3bit a5(op[5], sel[2], n_sel1, sel[0]);//101
And_gate_3bit a6(op[6], sel[2], sel[1], n_sel0);//110
And_gate_3bit a7(op[7], sel[2], sel[1], sel[0]);//111

filter f0(temp0, op[0], in0);
filter f1(temp1, op[1], in1);
filter f2(temp2, op[2], in2);
filter f3(temp3, op[3], in3);
filter f4(temp4, op[4], in4);
filter f5(temp5, op[5], in5);
filter f6(temp6, op[6], in6);
filter f7(temp7, op[7], in7);


Or_gate_8bit o0(out[0], temp0[0], temp1[0], temp2[0], temp3[0], temp4[0], temp5[0], temp6[0], temp7[0]);
Or_gate_8bit o1(out[1], temp0[1], temp1[1], temp2[1], temp3[1], temp4[1], temp5[1], temp6[1], temp7[1]);
Or_gate_8bit o2(out[2], temp0[2], temp1[2], temp2[2], temp3[2], temp4[2], temp5[2], temp6[2], temp7[2]);
Or_gate_8bit o3(out[3], temp0[3], temp1[3], temp2[3], temp3[3], temp4[3], temp5[3], temp6[3], temp7[3]);
endmodule

// final 
module final (out, c0 ,c1, c2, c3, c4, c5, c6, c7);
input [3:0]  c0 ,c1, c2, c3, c4, c5, c6, c7;
output [3:0] out;

Or_gate_8bit o0(out[0], c0[0], c1[0], c2[0], c3[0], c4[0], c5[0], c6[0], c7[0]);
Or_gate_8bit o1(out[1], c0[1], c1[1], c2[1], c3[1], c4[1], c5[1], c6[1], c7[1]);
Or_gate_8bit o2(out[2], c0[2], c1[2], c2[2], c3[2], c4[2], c5[2], c6[2], c7[2]);
Or_gate_8bit o3(out[3], c0[3], c1[3], c2[3], c3[3], c4[3], c5[3], c6[3], c7[3]);

endmodule

//*****module-> f2
module ADD(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;
wire [3:0] c;

Full_Adder f0(rs[0], rt[0], 1'b0, c[0], rd[0]);
Full_Adder f1(rs[1], rt[1], c[0], c[1], rd[1]);
Full_Adder f2(rs[2], rt[2], c[1], c[2], rd[2]);
Full_Adder f3(rs[3], rt[3], c[2], c[3], rd[3]);

endmodule

//*****module-> f1
module SUB(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

////2's complement of b (¤Ï¹L¨Ó+1)
wire [3:0] rt_c;
Complement_plus1 c0(rt_c, rt);

ADD a0(rs, rt_c, rd);

endmodule

//2's complement
module Complement_plus1 (out, in);
input [3:0] in;
output [3:0] out;

wire [3:0] tmp;
Not_gate n0(tmp[0], in[0]);
Not_gate n1(tmp[1], in[1]);
Not_gate n2(tmp[2], in[2]);
Not_gate n3(tmp[3], in[3]);

ADD a(tmp, 4'b0001, out);

endmodule 

//*****module-> f3
module bitwise_or(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

Or_gate o0(rd[0], rs[0], rt[0]);
Or_gate o1(rd[1], rs[1], rt[1]);
Or_gate o2(rd[2], rs[2], rt[2]);
Or_gate o3(rd[3], rs[3], rt[3]);

endmodule

//*****module-> f4
module bitwise_and(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

And_gate a0(rd[0], rs[0], rt[0]);
And_gate a1(rd[1], rs[1], rt[1]);
And_gate a2(rd[2], rs[2], rt[2]);
And_gate a3(rd[3], rs[3], rt[3]);

endmodule

//*****module-> f5
module rt_ari_right_shift (rt, rd); 
input [3:0] rt;
output [3:0] rd;

And_gate a0(rd[0], rt[1], rt[1]);
And_gate a1(rd[1], rt[2], rt[2]);
And_gate a2(rd[2], rt[3], rt[3]);
And_gate a3(rd[3], rt[3], rt[3]);

endmodule

//*****module-> f6
module rs_cir_left_shift(rs, rd); 
input [3:0] rs;
output [3:0] rd;

And_gate a0(rd[0], rs[3], rs[3]);
And_gate a1(rd[1], rs[0], rs[0]);
And_gate a2(rd[2], rs[1], rs[1]);
And_gate a3(rd[3], rs[2], rs[2]);

endmodule

//*****module-> f7
module compare_lt(rs, rt, rd); 
input [3:0] rs, rt;
output [3:0] rd;

//first bit
wire [3:0] x;
Xnor_gate x0(x[0], rs[0], rt[0]);
Xnor_gate x1(x[1], rs[1], rt[1]);
Xnor_gate x2(x[2], rs[2], rt[2]);
Xnor_gate x3(x[3], rs[3], rt[3]);

//(A<B) = a3'b3 + x3 a2'b2 + x3x2 a1'b1 + x3x2x1 a0' b0
//(rs<rt), rs=a, rt=b
wire [3:0] rs_n; //rs'
Not_gate n0(rs_n[0], rs[0]);
Not_gate n1(rs_n[1], rs[1]);
Not_gate n2(rs_n[2], rs[2]);
Not_gate n3(rs_n[3], rs[3]);

wire [3:0] t;
And_gate a0(t[3], rs_n[3], rt[3]); //a3' b3 

wire tmp1;
And_gate a1(tmp1, rs_n[2], rt[2]); //x3   a2' b2
And_gate a2(t[2], tmp1, x[3]);

wire tmp2, tmp3;
And_gate a3(tmp2, rs_n[1], rt[1]); //x3x2 a1'b1
And_gate a4(tmp3, tmp2, x[3]);
And_gate a5(t[1], tmp3, x[2]);

wire tmp4, tmp5, tmp6;
And_gate a6(tmp4, rs_n[0], rt[0]); //x3x2x1 a0' b0
And_gate a7(tmp5, tmp4, x[1]);
And_gate a8(tmp6, tmp5, x[2]);
And_gate a9(t[0], tmp6, x[3]);

wire tmp7, tmp8;
Or_gate o0(tmp7, t[0], t[1]);
Or_gate o1(tmp8, tmp7, t[2]);
Or_gate o2(rd[0], tmp8, t[3]);

// last 3 bits
And_gate a10(rd[1], 1'b1, 1'b1);
And_gate a11(rd[2], 1'b0, 1'b0);
And_gate a12(rd[3], 1'b1, 1'b1);

endmodule

//*****module-> f8
module compare_eq(rs, rt, rd); 
input [3:0] rs, rt;
output [3:0] rd;

//first bit
wire [3:0] x;
Xnor_gate x0(x[0], rs[0], rt[0]);
Xnor_gate x1(x[1], rs[1], rt[1]);
Xnor_gate x2(x[2], rs[2], rt[2]);
Xnor_gate x3(x[3], rs[3], rt[3]);

wire tmp;
And_gate_3bit a3_0(tmp, x[0], x[1], x[2]);
And_gate a0(rd[0], tmp, x[3]);

// last 3 bits
And_gate a1(rd[1], 1'b1, 1'b1);
And_gate a2(rd[2], 1'b1, 1'b1);
And_gate a3(rd[3], 1'b1, 1'b1);

endmodule

//filter
module filter(out, op, in);
input [3:0] in;
input op;
output [3:0] out;

And_gate a0(out[0], op, in[0]);
And_gate a1(out[1], op, in[1]);
And_gate a2(out[2], op, in[2]);
And_gate a3(out[3], op, in[3]);

endmodule

//or_gate_8bit
module Or_gate_8bit(out, in0, in1, in2, in3, in4, in5, in6, in7);
input in0, in1, in2, in3, in4, in5, in6, in7;
output out;

wire t1, t2, t3, t4, t5, t6;
Or_gate o0(t1, in0, in1);
Or_gate o1(t2, t1, in2);
Or_gate o2(t3, t2, in3);
Or_gate o3(t4, t3, in4);
Or_gate o4(t5, t4, in5);
Or_gate o5(t6, t5, in6);
Or_gate o6(out, t6, in7);

endmodule

//basic--------------------
//Full
module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire tmp;
Xor_gate x0(tmp, a, b);
Xor_gate x1(sum, tmp, cin);

Majority m0(a, b, cin, cout);

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

// and_gate_3bit
module And_gate_3bit (out, in1, in2, in3);
input in1, in2, in3;
output out;

wire tmp;
And_gate n1(tmp, in1, in2);
And_gate n2(out, tmp, in3);

endmodule

//xnor_gate
module Xnor_gate(out, in1, in2);
input in1, in2;
output out;

wire tmp;
Xor_gate x0(tmp, in1, in2);
Not_gate n0(out, tmp);

endmodule

//xor_gate
module Xor_gate(out, in1, in2);
input in1, in2;
output out;

wire n_in1, n_in2;
Not_gate n1(n_in1, in1);
Not_gate n2(n_in2, in2);

wire tmp1, tmp2;
And_gate a1(tmp1, in1, n_in2);
And_gate a2(tmp2, n_in1, in2);
Or_gate o1(out, tmp1, tmp2);

endmodule

//or_gate
module Or_gate (out, in1, in2);
input in1, in2;
output out;

wire n_in1;
Not_gate n0(n_in1, in1);
wire tmp1;
Universal_Gate n1(n_in1, in2, tmp1);

Universal_Gate n2(1'b1, tmp1, out);

endmodule

// and_gate
module And_gate (out, in1, in2);
input in1, in2;
output out;

wire tmp;
Universal_Gate n1(in1, in2, tmp); //a&n_b
Universal_Gate n2(in1, tmp, out); //a & n_(a&n_b)

endmodule

// not_gate 
module Not_gate (out, in);
input in;
output out;

Universal_Gate n0(1'b1, in, out);

endmodule
