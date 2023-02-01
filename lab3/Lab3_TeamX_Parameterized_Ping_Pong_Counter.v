`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg[4-1:0] out;
reg next_direction;
reg [4-1:0] next_out;

always @(posedge clk) begin
    if(!rst_n)begin
        out <= min;
        direction <= 1'b1;
    end

    else begin
        out <= next_out;
        direction <= next_direction;
    end
end

//direction
always @(*)begin
    if(enable)begin

        if(out > max || out < min || (max == min && max == out) || max < min)begin
            next_direction = direction;
        end

        else begin

            if(out == max)begin
                
                if(direction)begin
                    next_direction = !direction;
                end

                else begin
                    next_direction = direction;
                end
            end

            else if(out == min)begin
                if(direction)begin
                    next_direction = direction;
                end

                else begin
                    next_direction = !direction;
                end
            end

            else begin
                if(flip)begin
                    next_direction = !direction;
                end

                else begin
                    next_direction = direction;
                end
            end
        end
    end

    else begin
        next_direction = direction;
    end
end
//out
always @(*)begin
    if(enable)begin

        if(out > max || out < min || (max == min && max == out) || max < min)begin
            next_out = out;
        end

        else begin

            if(out == max)begin
                next_out = out - 4'b0001;
            end

            else if(out == min)begin
                next_out = out + 4'b0001;
            end

            else begin
                if(flip)begin
                    if(direction == 1'b1)
                        next_out = out - 4'b0001;
                    else
                        next_out = out + 4'b0001;
                end

                else begin
                    if(direction == 1'b1)
                        next_out = out + 4'b0001;
                    else
                        next_out = out - 4'b0001;
                end
            end
        end
    end

    else begin
        next_out = out;
    end
end
endmodule
