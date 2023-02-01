`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/21 23:20:37
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sliding_Window_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;

`define CYC 10
always #(`CYC / 2) clk = ~clk;

Sliding_Window_Sequence_Detector swsd(clk, rst_n, in, dec); 

initial begin
@ (negedge clk) 
rst_n = 1'b0;
@ (negedge clk) 
rst_n = 1'b1;
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
rst_n = 1'b0;
@ (negedge clk) 
@ (negedge clk) 

@ (negedge clk) 
rst_n = 1'b1;
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b1;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 
in = 1'b0;
@ (negedge clk) 

$finish;
end  

endmodule
