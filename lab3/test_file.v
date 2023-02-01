`timescale 1ns/1ps
module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg [2:0] read_cur, write_cur;////0~7 total 8
reg [7:0] mem[7:0];
reg [3:0] count; 
reg [7:0] dout;
reg error;

always@(posedge clk)begin
    if(!rst_n)begin
        read_cur <= 3'b000;
        write_cur <= 3'b000;
        count <= 4'b0000;
        error <= 1'b0;
        dout <= 8'b0000000; 
        
    end
    else begin
        if(ren)begin
            if(count==4'b0000)begin
                error <= 1'b1;
                dout <= 1'b0;
            end
            else begin
                error <= 1'b0;
                dout <= mem[read_cur];
                mem[read_cur] <= 1'b0;
                read_cur <= read_cur + 1'b1;
                count <= count - 1'b1; 
            end
        end
        else if(wen)begin
            if(count == 4'b1111)begin
                error <= 1'b1;
                dout <= 1'b0;
            end
            else begin
                error <= 1'b0;
                mem[write_cur] <= din;
                write_cur <= write_cur + 1'b1;
                count <= count + 1'b1;
            end
        end
        else begin
            error <= 1'b0;
        end
    end
end

endmodule