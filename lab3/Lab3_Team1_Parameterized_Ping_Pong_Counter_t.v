`timescale 1ns / 1ps
`define CYC 2
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/16 20:08:49
// Design Name: 
// Module Name: Parameterized_Ping_Pong_Counter_t
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


module Parameterized_Ping_Pong_Counter_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b0;
reg [3:0]max = 0;
reg [3:0]min = 0;
reg flip = 1'b0;
wire direction;
wire [3:0] out; 

Parameterized_Ping_Pong_Counter pppc(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .max(max),
    .min(min),
    .flip(flip),
    .direction(direction),
    .out(out)
    );
always #(`CYC/2) clk = ~clk;
initial begin
    $monitor("clk = %b, rst_n = %b, enable = %b, max = %d, min = %d, flip = %b | out = %d, direction = %b",
    clk, rst_n, enable, max, min, flip, out, direction);
end

initial begin

    //waveform(fip = 0 & enable = 1)
    @(negedge clk)
    rst_n = 0;
    enable = 1;
    @(negedge clk) //reset
    rst_n = 1;
    min = 0;
    max = 4;
    @(negedge clk) //2
    @(negedge clk) //3
    @(negedge clk) //4
    @(negedge clk) //5
    @(negedge clk) //6 
    @(negedge clk) //7
    @(negedge clk) //8
    @(negedge clk) //9
    @(negedge clk) //10
    @(negedge clk) //11
    
    //enable = 0
    @(negedge clk)
    enable = 0;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //filp = 1
    @(negedge clk)
    enable = 1;
    flip = 1;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //filp = 0
    @(negedge clk)
    flip = 0;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //max&min - 1
    @(negedge clk)
    max = 15;
    min = 0;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //max&min - 2
    @(negedge clk)
    max = 4;
    min = 9;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //max&min - 3
    @(negedge clk)
    max = 8;
    min = 8;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //max&min - 4
    @(negedge clk)
    max = 6;
    min = 4;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //max&min
    @(negedge clk)
    max = 8;
    min = 4;
    @(negedge clk)
    @(negedge clk)
    
    //max&min - 5
    @(negedge clk)
    max = 12;
    min = 9;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    
    //reset 
    @(negedge clk)
   rst_n = 0;
    min = 10;
    max = 15;

    //going
    @(negedge clk) 
    rst_n = 1;
    @(negedge clk) 
    @(negedge clk) 
    @(negedge clk)
    @(negedge clk) 
    @(negedge clk) 
    @(negedge clk)
    @(negedge clk) 
    @(negedge clk) 
    @(negedge clk) 
    @(negedge clk) 
    
    #1 $finish;
end 
endmodule
