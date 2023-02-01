`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output [8-1:0] dout;
wire bank0_w, bank0_r;
wire bank1_w, bank1_r;
wire bank2_w, bank2_r;
wire bank3_w, bank3_r;
reg [8-1:0] dout;
wire [8-1:0] temp_dout [4-1:0];

//ren == 1
always @(temp_dout[0], temp_dout[1], temp_dout[2], temp_dout[3])begin
    if(raddr[10:9] == 2'b00)dout = temp_dout[0];
    else if(raddr[10:9] == 2'b01)dout = temp_dout[1];
    else if(raddr[10:9] == 2'b10)dout = temp_dout[2];
    else dout = temp_dout[3];
end
assign bank0_r = ((raddr[10:9] == 2'b00) && ren == 1'b1) ? 1 : 0;
assign bank0_w = ((waddr[10:9] == 2'b00) && wen == 1'b1) ? 1 : 0;
assign bank1_r = ((raddr[10:9] == 2'b01) && ren == 1'b1) ? 1 : 0;
assign bank1_w = ((waddr[10:9] == 2'b01) && wen == 1'b1) ? 1 : 0;
assign bank2_r = ((raddr[10:9] == 2'b10) && ren == 1'b1) ? 1 : 0;
assign bank2_w = ((waddr[10:9] == 2'b10) && wen == 1'b1) ? 1 : 0;
assign bank3_r = ((raddr[10:9] == 2'b11) && ren == 1'b1) ? 1 : 0;
assign bank3_w = ((waddr[10:9] == 2'b11) && wen == 1'b1) ? 1 : 0;

Single_Bank_Memory s0(clk, bank0_r, bank0_w, waddr[8:0], raddr[8:0], din, temp_dout[0]);
Single_Bank_Memory s1(clk, bank1_r, bank1_w, waddr[8:0], raddr[8:0], din, temp_dout[1]);
Single_Bank_Memory s2(clk, bank2_r, bank2_w, waddr[8:0], raddr[8:0], din, temp_dout[2]);
Single_Bank_Memory s3(clk, bank3_r, bank3_w, waddr[8:0], raddr[8:0], din, temp_dout[3]);
endmodule

module Single_Bank_Memory(clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [9-1:0] waddr;
input [9-1:0] raddr;
input [8-1:0] din;
output [8-1:0] dout;
wire bank0_w, bank0_r;
wire bank1_w, bank1_r;
wire bank2_w, bank2_r;
wire bank3_w, bank3_r;
wire [7-1:0] bank0_addr;
wire [7-1:0] bank1_addr;
wire [7-1:0] bank2_addr;
wire [7-1:0] bank3_addr;
wire [8-1:0] temp_dout [4-1:0];
reg [8-1:0] dout;

//ren == 1
always @(temp_dout[0], temp_dout[1], temp_dout[2], temp_dout[3])begin
    if(raddr[8:7] == 2'b00)dout = temp_dout[0];
    else if(raddr[8:7] == 2'b01)dout = temp_dout[1];
    else if(raddr[8:7] == 2'b10)dout = temp_dout[2];
    else dout = temp_dout[3];
end
assign bank0_r = ((raddr[8:7] == 2'b00) && ren == 1'b1) ? 1 : 0;
assign bank0_w = ((waddr[8:7] == 2'b00) && wen == 1'b1) ? 1 : 0;
assign bank1_r = ((raddr[8:7] == 2'b01) && ren == 1'b1) ? 1 : 0;
assign bank1_w = ((waddr[8:7] == 2'b01) && wen == 1'b1) ? 1 : 0;
assign bank2_r = ((raddr[8:7] == 2'b10) && ren == 1'b1) ? 1 : 0;
assign bank2_w = ((waddr[8:7] == 2'b10) && wen == 1'b1) ? 1 : 0;
assign bank3_r = ((raddr[8:7] == 2'b11) && ren == 1'b1) ? 1 : 0;
assign bank3_w = ((waddr[8:7] == 2'b11) && wen == 1'b1) ? 1 : 0;

assign bank0_addr = (bank0_r == 1'b1) ? raddr[6:0] : waddr[6:0];
assign bank1_addr = (bank1_r == 1'b1) ? raddr[6:0] : waddr[6:0];
assign bank2_addr = (bank2_r == 1'b1) ? raddr[6:0] : waddr[6:0];
assign bank3_addr = (bank3_r == 1'b1) ? raddr[6:0] : waddr[6:0];

Memory m0(clk, bank0_r, bank0_w, bank0_addr, din, temp_dout[0]);
Memory m1(clk, bank1_r, bank1_w, bank1_addr, din, temp_dout[1]);
Memory m2(clk, bank2_r, bank2_w, bank2_addr, din, temp_dout[2]);
Memory m3(clk, bank3_r, bank3_w, bank3_addr, din, temp_dout[3]);
endmodule

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output [8-1:0] dout;
reg [8-1:0] Mem [128-1:0];
reg [8-1:0] dout;
always @(posedge clk)begin
    if(ren == 1'b1)
        dout <= Mem[addr];
    else begin
        if(wen == 1'b1)begin
            Mem[addr] <= din;
            dout <= 8'b0;
        end

        else
            dout <= 8'b0;
     end
end


endmodule