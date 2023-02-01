`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [4-1:0] out;
reg next_dir;
reg [4-1:0] next_out;
reg direction;
reg [4-1:0] out;
always @(posedge clk) begin
    if(!rst_n)begin
        out <= 4'b0000;
        direction <= 1'b1;
    end

    else begin
        out <= next_out;
        direction <= next_dir;
    end
end

//update direction
always @(*)begin

    if(enable)begin
        if(out == 4'b1111 && direction == 1'b1)
            next_dir = 1'b0;
        else if(out == 4'b0000 && direction == 1'b0)
            next_dir = 1'b1;
        else
            next_dir = direction;
    end

    else begin
        next_dir = direction;
    end

    
end

//update counter
always @(*)begin
    if(enable)begin
        if(direction == 1'b1)begin
            if(out == 4'b1111)
                next_out = out - 4'b1;
            else
                next_out = out + 4'b1;
        end

        else begin
            if(out == 4'b0000)
                next_out = out + 4'b1;
            else
                next_out = out - 4'b1;
        end

    end

    else
        next_out = out;
end

endmodule
