`timescale 1ns/1ps 

module Booth_Multiplier_4bit_t;
reg clk = 1'b0;
reg rst_n = 1'b0; 
reg start = 1'b0;
reg signed [3:0] a = 4'b0000;
reg signed [3:0] b = 4'b0000;
wire signed [7:0] p;
parameter cyc = 10;
always #(cyc / 2)clk = !clk;

Booth_Multiplier_4bit bm(clk, rst_n, start, a, b, p);
initial begin
	$monitor("clk = %b, rst_n = %b, start = %b, a = %d, b = %d | p = %d", clk, rst_n, start, a, b, p);

end

initial begin
    @(negedge clk)
    rst_n = 1'b1;
    @(negedge clk)
    rst_n = 1'b0;
   
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b1;
    a = 4'b1111;
    b = 4'b0010;
    #(cyc * 7)
      
    @(negedge clk)
    start = 1'b0;
    @(negedge clk)
    start = 1'b1;
    a = 4'b0011;
    b = 4'b0010;
    #(cyc * 7)
    @(negedge clk)
    start = 1'b0;
    @(negedge clk)
    start = 1'b1;
    a = 4'b0011;
    b = 4'b1010;
    #(cyc * 7)
    @(negedge clk)
    start = 1'b0;
    @(negedge clk)
    start = 1'b1;
    a = 4'b1011;
    b = 4'b1010;
    #(cyc * 7)
    @(negedge clk)
    $finish;
end



endmodule
