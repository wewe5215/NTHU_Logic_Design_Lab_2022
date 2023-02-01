`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output reg [3:0] dout;
output reg hit;
reg [8-1:0] mem [16-1:0];
reg [3:0] next_dout;
reg next_hit;
always @(posedge clk) begin
    if(ren)begin
        dout <= next_dout;
        hit <= next_hit;
    end

    else begin
        if(wen)begin
            dout <= 4'd0;
            hit <= 1'b0;
            mem[addr] <= din;
        end

        else begin
            dout <= 4'd0;
            hit <= 1'b0;
        end
    end
end

always @(*)begin
    if(mem[0] == din)begin
        next_dout = 4'd0;
        next_hit = 1'b1;
    end

    else if(mem[1] == din)begin
        next_dout = 4'd1;
        next_hit = 1'b1;
    end

    else if(mem[2] == din)begin
        next_dout = 4'd2;
        next_hit = 1'b1;
    end

    else if(mem[3] == din)begin
        next_dout = 4'd3;
        next_hit = 1'b1;
    end

    else if(mem[4] == din)begin
        next_dout = 4'd4;
        next_hit = 1'b1;
    end

    else if(mem[5] == din)begin
        next_dout = 4'd5;
        next_hit = 1'b1;
    end

    else if(mem[6] == din)begin
        next_dout = 4'd6;
        next_hit = 1'b1;
    end

    else if(mem[7] == din)begin
        next_dout = 4'd7;
        next_hit = 1'b1;
    end

    else if(mem[8] == din)begin
        next_dout = 4'd8;
        next_hit = 1'b1;
    end

    else if(mem[9] == din)begin
        next_dout = 4'd9;
        next_hit = 1'b1;
    end

    else if(mem[10] == din)begin
        next_dout = 4'd10;
        next_hit = 1'b1;
    end

    else if(mem[11] == din)begin
        next_dout = 4'd11;
        next_hit = 1'b1;
    end

    else if(mem[12] == din)begin
        next_dout = 4'd12;
        next_hit = 1'b1;
    end

    else if(mem[13] == din)begin
        next_dout = 4'd13;
        next_hit = 1'b1;
    end

    else if(mem[14] == din)begin
        next_dout = 4'd14;
        next_hit = 1'b1;
    end

    else if(mem[15] == din)begin
        next_dout = 4'd15;
        next_hit = 1'b1;
    end

    else begin
        next_dout = 4'd0;
        next_hit = 1'b0;
    end
end
endmodule
