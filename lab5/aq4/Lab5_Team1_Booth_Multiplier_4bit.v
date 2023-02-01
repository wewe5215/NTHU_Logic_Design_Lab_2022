`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output reg signed [7:0] p;
wire [3:0] a_comp;
wire [3:0] addition, substraction;
reg [2-1:0] state, next_state;
reg [7:0] next_p;
reg [8:0] next_result, result;
reg [2-1:0] counter, next_counter;
reg signed [3:0] input_a, input_b;
parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
assign a_comp[0] = ~ input_a[0];
assign a_comp[1] = ~ input_a[1];
assign a_comp[2] = ~ input_a[2];
assign a_comp[3] = ~ input_a[3];

adder a0(result[8:5], input_a, 1'b0, addition);
adder a1(result[8:5], a_comp, 1'b1, substraction);
always @(posedge clk) begin
    if(!rst_n)begin
        state <= WAIT;
        p <= 8'd0;
        counter <= 2'b00;
        result <= 9'd0;
    end

    else begin
        state <= next_state;
        p <= next_p;
        counter <= next_counter;
        result <= next_result;
    end
end

always @(*)begin
    case (state)
        WAIT:begin
            if(start)
                next_state = CAL;
            else 
                next_state = WAIT;
            next_result = {4'b0000, b, 1'b0};
            input_a = a;
            input_b = b;
            next_p = 8'd0;
            next_counter = 2'b00;
        end
        CAL:begin
            if(counter == 2'b11)begin
                next_counter = 2'b00;
                next_state = FINISH;
                case(result[1:0])
                2'b00:begin
                    next_p = {result[8], result[8:2]};
                end
                2'b01:begin
                    next_p = {addition[3], addition, result[4:2]};
                end
                2'b10:begin
                    
                    next_p = {substraction[3], substraction, result[4:2]};
                end
                default:begin
                    next_p = {result[8], result[8:2]};
                end
                endcase
            end

            else begin
                next_counter = counter + 2'b01;
                next_state = CAL;
                next_p = 8'd0;
            end

            case(result[1:0])
                2'b00:begin
                    next_result = {result[8], result[8:1]};
                end
                2'b01:begin
                    next_result = {addition[3], addition, result[4:1]};
                end
                2'b10:begin
                    
                    next_result = {substraction[3], substraction, result[4:1]};
                end
                default:begin
                    next_result = {result[8], result[8:1]};
                end

            endcase


        end
        FINISH:begin
            if(counter >= 2'b01)begin
                next_counter = 2'b00;
                next_state = WAIT;
                next_p = 8'd0;
            end

            else begin
                next_counter = counter + 2'b01;
                next_state = FINISH;
                next_p = result[8:1];
            end
            next_result = result;

        end 
        default:begin
            if(start)
                next_state = CAL;
            else 
                next_state = WAIT;
            next_result = {4'b0000, b, 1'b0};
            input_a = a;
            input_b = b;
            next_p = 8'd0;
            next_counter = 2'b00;
        end
    endcase

end
endmodule


module adder(a, b, cin, sum);
input [3:0] a, b;
input cin;
output [3:0] sum;

assign sum = a + b + cin;


endmodule


