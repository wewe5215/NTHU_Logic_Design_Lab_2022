`timescale 1ns/1ps

module Scan_Chain_Design_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg scan_in = 1'b0;
reg scan_en = 1'b0;
wire scan_out;
parameter cyc = 10;
Scan_Chain_Design scd(clk, rst_n, scan_in, scan_en, scan_out);
always #(cyc / 2)clk = !clk;

initial begin
    $monitor("clk = %b, rst_n = %b, scan_in = %b, scan_en = %b | scan_out = %b",
            clk, rst_n, scan_in, scan_en, scan_out);
end

initial begin
//reset
@(negedge clk)
rst_n = 1'b0;
//test 0x0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b0;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
#(cyc * 8)

//reset
@(negedge clk)
rst_n = 1'b0;
//test 1x8
//0001 x 1000
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//b0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//b1
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//b2
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b3
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//a0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//a1
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//a2
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//a3
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b0;
scan_in = 1'b0;
//output might be 00001000
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
#(cyc * 8)

//reset
@(negedge clk)
rst_n = 1'b0;
//test 4x15 = 60
//0100 x 1111
//output = 00111100
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b1
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b2
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b3
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//a0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//a1
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//a2
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b0;//a3
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b0;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
#(cyc * 8)

//reset
@(negedge clk)
rst_n = 1'b0;
//test 4x15 = 60
//1111 x 1111
//output = 11111111
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b1
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b2
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//b3
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//a0
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//a1
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//a2
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
scan_in = 1'b1;//a3
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b0;
scan_in = 1'b0;
@(negedge clk)
rst_n = 1'b1;
scan_en = 1'b1;
#(cyc * 8)
@(negedge clk)
rst_n = 1'b0;
@(negedge clk)
$finish;
end
endmodule