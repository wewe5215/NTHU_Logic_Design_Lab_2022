`timescale 1ns/1ps

module Multi_Bank_Memory_t;
reg clk = 1'b0;
reg ren = 1'b0;
reg wen = 1'b0;
reg [11-1:0] waddr = 11'b0;
reg [11-1:0] raddr = 11'b0;
reg [8-1:0] din = 8'b0;
wire [8-1:0] dout;
Multi_Bank_Memory m0(clk, ren, wen, waddr, raddr, din, dout);
parameter cyc = 10;
always# (cyc/2) clk = !clk;

initial begin
    $monitor("clk = %b, wen = %b, ren = %b, waddr = %d, raddr = %d, din = %d | dout = %d",
    clk, wen, ren, waddr, raddr, din, dout);
end

initial begin
    //write bank(0,0)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b00000000000;
    din = 8'd0;
    //write bank(0,1)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b00010000001;
    din = 8'd1;
    //write bank(0,2)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b00100000010;
    din = 8'd2;
    //write bank(0,3)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b00110000011;
    din = 8'd3;
    //read (1,0) bank(0,0)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    raddr = 11'b00000000000;
    waddr = 11'b00000000000;
    din = 8'd0;
    //read (1,1) bank(0,1)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b00010000001;
    waddr = 11'b00010000000;
    din = 8'd0;
    //check bank(0,1) by read
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    raddr = 11'b00010000000;
    waddr = 11'b00010000000;
    din = 8'd0;
    //read (1,0) bank(0,2)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    raddr = 11'b00100000010;
    waddr = 11'b00000000000;
    din = 8'd0;
    //read(1,1) bank(0,3)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b00110000011;
    waddr = 11'b00110000000;
    din = 8'd0;
    //check bank(0,3) by read
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    raddr = 11'b00110000000;
    waddr = 11'b00110000000;
    din = 8'd0;
    //write bank(1,0)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b01000000010;
    din = 8'd10;
    //write bank(2,0)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b10000000100;
    din = 8'd20;
    //write bank(3,0)
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b1;
    raddr = 11'b00000000000;
    waddr = 11'b11000001000;
    din = 8'd30;
    //read bank(1,0)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b01000000010;
    waddr = 11'b00000000000;
    din = 8'd0;
    //read bank(2,0)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b0;
    raddr = 11'b10000000100;
    waddr = 11'b00000000000;
    din = 8'd0;
    //read bank(3,0)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b11000001000;
    waddr = 11'b00000000000;
    din = 8'd0;
    //read bank(1,0) empty  write bank(1,1)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b01000000000;
    waddr = 11'b01010000011;
    din = 8'd11;
    //read bank(1,1) write bank(2,1)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b01010000011;
    waddr = 11'b10010000111;
    din = 8'd21;
    //read bank(2,1) empty write bank(3,1)
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    raddr = 11'b10010000011;
    waddr = 11'b11010000000;
    din = 8'd31;
    @(negedge clk)
    $finish;
end
endmodule