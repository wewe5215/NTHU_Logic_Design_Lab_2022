`timescale 1ns/1ps

module FIFO_8_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg wen = 1'b0;
reg ren = 1'b0;
reg [8-1:0] din = 8'b0;
wire [8-1:0] dout;
wire error;
parameter cyc = 10;
FIFO_8 f0(clk, rst_n, wen, ren, din, dout, error);

always# (cyc / 2)clk = !clk;
initial begin
    $monitor("clk = %b, rst_n = %b, wen = %b, ren = %b, din = %d | dout = %d, error = %b",
    clk, rst_n, wen, ren, din, dout, error);
end
initial begin
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    //read empty
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd1;
    //read empty and test ren = wen = 1
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    din = 8'd2;
    //check nothing is written in
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd2;
    //write someting
    //write_ptr = 0
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd11;
    //write_ptr = 1
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd12;
    //write_ptr = 2
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd13;
    //write_ptr = 3
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd14;
    //write_ptr = 4
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd15;
    //write_ptr = 5
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd16;
    //write_ptr = 6
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd17;
    //read 8'd11
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //write_ptr = 7
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd18;
    //write 8'd19
    //write_ptr = 0
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd19;
    //write full
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd20;
    //read 8'd12
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd13
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd14
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd15
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd16
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd17
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd18
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read 8'd20
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //read empty
    //read 8'd12
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    din = 8'd3;
    //write 8'd21
    //write_ptr = 1
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd21;
    //write 8'd22
    //write_ptr = 2
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd22;
    //read 8'd21
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    din = 8'd11;
    //write 8'd23
    //write_ptr = 3
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    din = 8'd23;
    //reset  
    @(negedge clk)
    rst_n = 0;
    //check reset
    @(negedge clk)
    rst_n = 1;
    din = 8'd31;
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    din = 8'd32;
    @(negedge clk)
    $finish;
end
endmodule