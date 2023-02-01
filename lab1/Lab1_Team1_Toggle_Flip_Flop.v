`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;

wire n_q, n_t;
wire t_nq, nt_q;
wire xor_result, d;
//xor_result = t xor q = t'q + tq'
not n0(n_q, q);
not n1(n_t, t);
and a0(t_nq, t, n_q);
and a1(nt_q, n_t, q);
or o0(xor_result, t_nq, nt_q);

// xor_result and rst_n

and a2(d, xor_result, rst_n);
D_Flip_Flop d0(clk, d, q);
endmodule

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;
wire n_clk, q0;
not n0(n_clk, clk);
D_Latch d0(n_clk, d, q0);
D_Latch d1(clk, q0, q);

endmodule

module D_Latch(clk, d, q);
input clk;
input d;
output q;
wire n_q, n_d, q_temp;
wire [3:0] nand_gate;
not n0(n_d, d);

nand na0(nand_gate[0], d, clk);
nand na1(nand_gate[1], n_d, clk);
nand na2(nand_gate[2], nand_gate[3], nand_gate[0]);
nand na3(nand_gate[3], nand_gate[2], nand_gate[1]);
and a0(q, nand_gate[2], nand_gate[2]);

endmodule