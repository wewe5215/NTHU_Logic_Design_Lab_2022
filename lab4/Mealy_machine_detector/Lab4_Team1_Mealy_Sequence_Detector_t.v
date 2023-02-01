`timescale 1ns/1ps

module Mealy_Sequence_Detector_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg in = 1'b0;
wire dec;
parameter cyc = 10;
Mealy_Sequence_Detector m0(clk, rst_n, in, dec);
initial begin
    $monitor("clk = %b, rst_n = %b, in = %b | dec = %b",
            clk, rst_n, in, dec);
end
always #(cyc / 2)clk = !clk;
initial begin
@(negedge clk)
rst_n = 1'b0;
//4'b0000
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//4'b0001
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//4'b0010
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//4'b0011
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//4'b0100
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//4'b0101
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//check dec = 1
//011x
//4'b0110
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//4'b0111
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//4'b1000
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//4'b1001
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//dec = 1
//101x
//4'b1010
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//4'b1011
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//dec = 1
//110x
//1100
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//1101
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
//1110
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
//1111
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
rst_n = 1'b1;
in = 1'b1;
@(negedge clk)
$finish;
end

endmodule