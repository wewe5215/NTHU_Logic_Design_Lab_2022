`timescale 1ns/1ps

module Content_Addressable_Memory_t;
reg clk = 1'b0;
reg wen = 1'b0;
reg ren = 1'b0;
reg [7:0] din = 8'd0;
reg [3:0] addr = 4'd0;
wire [3:0] dout;
wire hit;
parameter cyc = 10;
always #(cyc / 2)clk = !clk;

Content_Addressable_Memory c0(clk, wen, ren, din, addr, dout, hit);
initial begin
    $monitor("clk = %b, wen = %b, ren = %b, din = %d, addr = %d | dout = %d, hit = %b",
            clk, wen, ren, din, addr, dout, hit);
end

initial begin
    //check read no match(addr = 0)
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd0;
    addr = 4'd0;
    //write same data with same modulo
    //write to addr == 0 is the same as write to addr == 8
    //0%8 = 8%8
    //write 10 to addr = 8
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd10;
    addr = 4'd8;
    //check 10
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd10;
    addr = 4'd0;
    //wirte 10 to addr = 0
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd10;
    addr = 4'd0;
    //check data 10 is written in and show the smallest addr is 0
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd10;
    addr = 4'd0;
    //check
    //ren = wen = 1
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b1;
    din = 8'd10;
    addr = 4'd0;


    //write 11 to addr = 9
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd11;
    addr = 4'd9;
    //check 11
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd11;
    addr = 4'd0;
    //wirte 11 to addr = 1
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd11;
    addr = 4'd1;
    //check data 11 is written in and show the smallest addr is 1
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd11;
    addr = 4'd0;
    //ren = 1 = wen
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b1;
    din = 8'd11;
    addr = 4'd0;

    //write 12 to addr = 10
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd12;
    addr = 4'd10;
    //check 12
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd12;
    addr = 4'd0;
    //wirte 12 to addr = 2
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd12;
    addr = 4'd2;
    //check data 11 is written in and show the smallest addr is 2
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd12;
    addr = 4'd0;

    //write 13 to addr = 11
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd13;
    addr = 4'd11;
    //check 13
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd13;
    addr = 4'd0;
    //wirte 13 to addr = 3
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd13;
    addr = 4'd3;
    //check data 13 is written in and show the smallest addr is 3
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd13;
    addr = 4'd0;

    //write 14 to addr = 12
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd14;
    addr = 4'd12;
    //check 14
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd14;
    addr = 4'd0;
    //wirte 14 to addr = 4
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd14;
    addr = 4'd4;
    //check data 14 is written in and show the smallest addr is 4
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd14;
    addr = 4'd0;

    //write 15 to addr = 13
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd15;
    addr = 4'd13;
    //check 15
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd15;
    addr = 4'd0;
    //wirte 15 to addr = 5
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd15;
    addr = 4'd5;
    //check data 15 is written in and show the smallest addr is 5
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd15;
    addr = 4'd0;

    //write 16 to addr = 14
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd16;
    addr = 4'd14;
    //check 16
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd16;
    addr = 4'd0;
    //wirte 16 to addr = 6
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd16;
    addr = 4'd6;
    //check data 16 is written in and show the smallest addr is 6
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd16;
    addr = 4'd0;

    //write 17 to addr = 15
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd17;
    addr = 4'd15;
    //check 16
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd17;
    addr = 4'd0;
    //wirte 16 to addr = 7
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd17;
    addr = 4'd7;
    //check data 16 is written in and show the smallest addr is 6
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd17;
    addr = 4'd0;

    //overwrite data to addr 1
    //check 11

    //wirte 21 to addr = 1
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    din = 8'd21;
    addr = 4'd1;
    //check data 21 is written in and show the smallest addr is 1
    //ren = 1 != wen
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd21;
    addr = 4'd0;
    //check data 11 is belong to addr = 9
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    din = 8'd11;
    addr = 4'd0;

    @(negedge clk)
    $finish;
end

endmodule