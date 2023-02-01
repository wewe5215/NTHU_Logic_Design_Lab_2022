`timescale 1ns/1ps 

module FPGA_Code(clk, rst_n, enable, flip, max, min, AN, segment);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output [3:0] AN;
output [6:0] segment;
wire clk_count, clk_display;

wire rst_n_debounced, flip_debounced;
wire rst_n_final, flip_final;

wire direction;
wire [4-1:0] out;
clk_divider_count c0(clk, clk_count);
clk_divider_display c1(clk, clk_display);

//debounce and one pulse for rst_n
debounce de0(rst_n, clk, rst_n_debounced);
one_pulse o0(rst_n_debounced, clk_count, rst_n_final);
//debounce and one pulse for flip
debounce de1(flip, clk, flip_debounced);
one_pulse o1(flip_debounced, clk_count, flip_final);

Parameterized_Ping_Pong_Counter p0(clk_count, !rst_n_final, enable, flip_final, max, min, direction, out);
display_control d0(clk_display, direction, out, AN, segment);



endmodule

module display_control(clk, direction, counter, AN, seven_segment);
input clk;
input direction;
input [4-1:0] counter;
output [3:0] AN;
output [6:0] seven_segment;
reg [3:0] AN;
reg [6:0] seven_segment;
//AN 
always @(posedge clk)begin
    case(AN)
        4'b0111: AN <= 4'b1011;
        4'b1011: AN <= 4'b1101;
        4'b1101: AN <= 4'b1110;
        4'b1110: AN <= 4'b0111;
        default: AN <= 4'b0111;
    endcase

end

//seven segment
always@(AN or counter or direction) begin
    case(AN)
        4'b0111 : begin
            if(counter >= 4'd10) seven_segment = 7'b1001111;
            else seven_segment = 7'b0000001;
        end
        4'b1011 : begin
            case(counter)
                4'b0000: seven_segment = 7'b0000001;
                4'b0001: seven_segment = 7'b1001111;
                4'b0010: seven_segment = 7'b0010010;
                4'b0011: seven_segment = 7'b0000110;
                4'b0100: seven_segment = 7'b1001100;
                4'b0101: seven_segment = 7'b0100100;
                4'b0110: seven_segment = 7'b0100000;
                4'b0111: seven_segment = 7'b0001111;
                4'b1000: seven_segment = 7'b0000000;
                4'b1001: seven_segment = 7'b0001100;
                4'b1010: seven_segment = 7'b0000001;
                4'b1011: seven_segment = 7'b1001111;
                4'b1100: seven_segment = 7'b0010010;
                4'b1101: seven_segment = 7'b0000110;
                4'b1110: seven_segment = 7'b1001100;
                4'b1111: seven_segment = 7'b0100100;
            endcase
        end
        4'b1101 , 4'b1110 :begin
            if(direction == 1'b1) seven_segment = 7'b0011101;
            else seven_segment = 7'b1100011;
        end
        default: seven_segment = 7'b1111111;
    endcase
end
endmodule

module clk_divider_count(clk, clk_out);
input clk;
output clk_out;
parameter n = 25;
reg [n-1:0] counter;

always@ (posedge clk)begin
    counter <= counter + 1'b1;
end

assign clk_out = counter[n-1];
endmodule

module clk_divider_display(clk, clk_out);
input clk;
output clk_out;
parameter n = 17;
reg [n-1:0] counter;

always@ (posedge clk)begin
    counter <= counter + 1'b1;
end

assign clk_out = counter[n-1];
endmodule

module debounce(pb, clk, pb_debounce);
input pb;
input clk;
output pb_debounce;
reg [4-1:0] dff;

always @(posedge clk)begin
    dff[3:1] <= dff[2:0];
    dff[0] <= pb;
end

assign pb_debounce = (dff == 4'b1111)? 1'b1 : 1'b0;
endmodule

module one_pulse(pb_debounced, clk, pb_one_pulse);
input pb_debounced;
input clk;
output pb_one_pulse;
reg pb_one_pulse;
reg pb_debounced_delay;

always @(posedge clk)begin
    pb_debounced_delay <= pb_debounced;
    pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
end

endmodule

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;
reg next_direction;
reg [4-1:0] next_out;
reg direction;
reg [4-1:0] out;
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

