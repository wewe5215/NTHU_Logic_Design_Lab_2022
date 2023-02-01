`timescale 1ns/1ps

module Universal_Gate(a, b, out);
input a, b;
output out;
wire n_b;
not n0(n_b, b);
and a0(out, a, n_b);
endmodule