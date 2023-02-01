`timescale 1ns/1ps

module Ping_Pong_Counter_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b1;
wire direction;
wire [4-1:0] out;

Ping_Pong_Counter p0(clk, rst_n, enable, direction, out);

parameter cyc = 10;
always# (cyc / 2) clk = !clk;
initial begin
    $monitor("clk = %b rst_n = %b enable = %b | direction = %b out = %d", clk, rst_n, enable, direction, out);
end
initial begin
    rst_n = 0;
    enable = 0;
    #20
    enable = 1;
    #20
    rst_n = 1;
    enable = 0;
    #20
    enable = 1;
    #(cyc * 32)
    enable = 0;
    #(cyc * 5)
    enable = 1;
    #(cyc * 5)
    rst_n = 0;
    #(cyc * 5)
    $finish;
    
    
end

endmodule