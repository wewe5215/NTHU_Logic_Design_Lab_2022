`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output reg done;
output reg [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg [2-1:0] state, next_state;
reg next_done;
reg [15:0] next_gcd, result;
reg [2-1:0] counter, next_counter;
reg [15:0] input_a, input_b;
reg [15:0] next_input_a, next_input_b;
always @(posedge clk) begin
    if(!rst_n)begin
        state <= WAIT;
        done <= 1'b0;
        gcd <= 16'd0;
        counter <= 2'b00;
        input_a <= 16'd0;
        input_b <= 16'd0;
    end

    else begin
        state <= next_state;
        done <= next_done;
        gcd <= next_gcd;
        counter <= next_counter;
        input_a <= next_input_a;
        input_b <= next_input_b;
    end
end

always @(*)begin
    case (state)
        WAIT:begin
            if(start)
                next_state = CAL;
            else 
                next_state = WAIT;
            result = 16'd0;
            next_input_a = a;
            next_input_b = b;
            next_done = 1'b0;
            next_gcd = 16'd0;
            next_counter = 2'b00;
        end
        CAL:begin
            if(input_a == 16'd0)begin
                result = input_b;
                next_input_a = input_a;
                next_input_b = input_b;
                next_state = FINISH;
                next_done = 1'b1;
                next_gcd = result;

            end

            else begin
                if(input_b == 16'd0)begin
                    result = input_a;
                    next_input_a = input_a;
                    next_input_b = input_b;
                    next_state = FINISH;
                    next_done = 1'b1;
                    next_gcd = result;
                end

                else begin
                    if(input_a > input_b)begin
                        result = 16'd0;
                        next_input_a = input_a - input_b;
                        next_input_b = input_b;
                        next_state = CAL;
                        next_done = 1'b0;
                        next_gcd = 16'd0;
                    end

                    else begin
                        result = 16'd0;
                        next_input_a = input_a;
                        next_input_b = input_b - input_a;
                        next_state = CAL;
                        next_done = 1'b0;
                        next_gcd = 16'd0;
                    end
                end
            end
            next_counter = 2'b00;
        end
        FINISH:begin
            if(counter >= 2'b01)begin
                next_counter = 2'b00;
                next_state = WAIT;
                next_done = 1'b0;
                next_gcd = 16'd0;
            end

            else begin
                next_counter = counter + 2'b01;
                next_state = FINISH;
                next_done = 1'b1;
                next_gcd = result;
            end
            next_input_a = input_a;
            next_input_b = input_b;
            

        end 
        default:begin
            if(start)
                next_state = CAL;
            else 
                next_state = WAIT;
            result = 16'd0;
            next_input_a = a;
            next_input_b = b;
            next_done = 1'b0;
            next_gcd = 16'd0;
            next_counter = 2'b00;
        end
    endcase

end
endmodule
