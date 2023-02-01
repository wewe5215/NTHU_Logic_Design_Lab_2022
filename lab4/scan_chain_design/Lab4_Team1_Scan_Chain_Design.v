`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk, rst_n, scan_in, scan_en;
output scan_out;

wire [3:0] a, b;
wire [7:0] p;

mult_4x4 m0( a, b, p);
SDFF s7(scan_in, p[7], scan_en, rst_n, clk, a[3]);
SDFF s6(a[3], p[6], scan_en, rst_n, clk, a[2]);
SDFF s5(a[2], p[5], scan_en, rst_n, clk, a[1]);
SDFF s4(a[1], p[4], scan_en, rst_n, clk, a[0]);
SDFF s3(a[0], p[3], scan_en, rst_n, clk, b[3]);
SDFF s2(b[3], p[2], scan_en, rst_n, clk, b[2]);
SDFF s1(b[2], p[1], scan_en, rst_n, clk, b[1]);
SDFF s0(b[1], p[0], scan_en, rst_n, clk, b[0]);
assign scan_out = b[0];

endmodule

module SDFF (scan_in, data, scan_en, rst_n, clk, dout);
input scan_in, data, scan_en;
input rst_n, clk;
output reg dout;

always @(posedge clk)begin
if(rst_n != 0)begin
    if(scan_en == 1) begin
        dout <= scan_in;
    end
    else if(scan_en == 0) begin
        dout <= data; 
    end 
    else begin
        dout <= 0; 
    end 
end
else begin
    dout <= 0;
end
end

endmodule 

module Full_adder (a, b, cin, cout, sum);
input a, b, cin;
output  reg cout, sum;

always @ (a or b or cin) begin
    {cout, sum} = a + b + cin;
end

endmodule 

module mult_4x4( a, b, p);
input [3:0] a, b;
output [7:0] p; 
wire a0b0; //p0
wire a1b0, a0b1; //p1
wire a2b0, a1b1, a0b2, p2_1; //p2
wire a3b0, a2b1, a1b2, a0b3, p3_1, p3_2; //p3
wire a3b1, a2b2, a1b3; //p4
wire a3b2, a2b3; //p5
wire a3b3; //p6

wire c0, c1, s2, s5;
wire [2-1:0] c2, s3, s4, c5;
wire [3-1:0] c3, c4;
assign a0b0 = a[0] & b[0];
assign a1b0 = a[1] & b[0];
assign a2b0 = a[2] & b[0];
assign a3b0 = a[3] & b[0];

assign a0b1 = a[0] & b[1];
assign a1b1 = a[1] & b[1];
assign a2b1 = a[2] & b[1];
assign a3b1 = a[3] & b[1];

assign a0b2 = a[0] & b[2];
assign a1b2 = a[1] & b[2];
assign a2b2 = a[2] & b[2];
assign a3b2 = a[3] & b[2];

assign a0b3 = a[0] & b[3];
assign a1b3 = a[1] & b[3];
assign a2b3 = a[2] & b[3];
assign a3b3 = a[3] & b[3];

Full_adder fa0(a0b0, 1'b0, 1'b0, c0, p[0]); //p0 = a0b0

Full_adder fa1(a1b0, a0b1, c0, c1, p[1]); //p1= a0b1+a1b0

Full_adder fa2(a2b0, a1b1, a0b2, c2[0], s2); //p2 = a0b2+a1b1+a2b0
Full_adder fa3(s2, c1, 1'b0, c2[1], p[2]);

Full_adder fa4(a3b0, a2b1, a1b2, c3[0], s3[0]); //p3 = a0b3+a1b2+a2b1+a3b0
Full_adder fa5(s3[0], a0b3, c2[0], c3[1], s3[1]);
Full_adder fa6(s3[1], c2[1], 1'b0, c3[2], p[3]);

Full_adder fa7(a3b1, a2b2, a1b3, c4[0], s4[0]); //p4 = a1b3+a2b2+a3b1
Full_adder fa8(s4[0], c3[0], c3[1], c4[1], s4[1]);
Full_adder fa9(s4[1], c3[2], 1'b0, c4[2], p[4]);
//p5
Full_adder fa10(a3b2, a2b3, c4[0], c5[0], s5); //p5 = a2b3+a3b2
Full_adder fa11(s5, c4[1], c4[2], c5[1], p[5]);
//p6
Full_adder fa12(a3b3, c5[0], c5[1], p[7], p[6]); //p6 = a3b3
endmodule