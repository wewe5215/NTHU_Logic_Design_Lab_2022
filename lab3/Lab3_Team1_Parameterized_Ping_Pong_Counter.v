`timescale 1ns/1ps
`define UP 1'b1
`define DOWN 1'b0

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;
reg next_direction;
reg [3:0] next_out;
reg direction;
reg [4-1:0] out;
always@(posedge clk)begin
    if(rst_n == 0)begin
        direction <= 1'b1;
        out <= min;
    end
    else begin
        direction <= next_direction;
        out <= next_out; 
    end 
end


// record counter, state, direction
always@(*)begin
    case(direction)
        `UP:begin
            if( (enable == 1)  && (max >= min) && (out <= max) && (out >= min) && (!(max==min && max==out)))begin
                //two kinds of flip
                if(out == max || ((out<max) && (out>min) && (flip == 1)))begin //<max
                    next_out = out - 1;
                    next_direction = `DOWN;
                end
                // keep
                else begin
                    next_direction = `UP; //same
                    next_out = out + 1;
                end
            end
            
            else begin
                next_direction = `UP;
                next_out = out;
            end
        end
        
        `DOWN:begin
            if( (enable == 1) && (max >= min) && (out <= max) && (out >= min) && (!(max==min && max==out)) )begin
                if(out == min || ((out<max) && (out>min) && (flip == 1)))begin //>min
                    next_direction = `UP;
                    next_out = out + 1;
                end
                else begin 
                    next_direction = `DOWN;
                    next_out = out - 1;
                end
            end
            
            else begin 
                next_direction = `DOWN;
                next_out = out; 
            end
        end    
    endcase
end

endmodule
