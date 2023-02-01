`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg out;
output reg [2:0] state;
reg [2:0] next_state;
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

always @(posedge clk) begin
    if(!rst_n)begin
        state <= S0;
    end

    else begin
        state <= next_state;
    end
end

always @(*)begin
    case (state)
        S0:
            if(in)begin
                next_state = S2;
                out = 1'b1;
            end

            else begin
                next_state = S0;
                out = 1'b0;
            end
        S1:
            if(in)begin
                next_state = S4;
                out = 1'b1;
            end

            else begin
                next_state = S0;
                out = 1'b1;
            end
        S2:
            if(in)begin
                next_state = S1;
                out = 1'b0;
            end

            else begin
                next_state = S5;
                out = 1'b1;
            end
        S3:
            if(in)begin
                next_state = S2;
                out = 1'b0;
            end

            else begin
                next_state = S3;
                out = 1'b1;
            end
        S4:
            if(in)begin
                next_state = S4;
                out = 1'b1;
            end

            else begin
                next_state = S2;
                out = 1'b1;
            end
        S5:
            if(in)begin
                next_state = S4;
                out = 1'b0;
            end

            else begin
                next_state = S3;
                out = 1'b0;
            end
        default:
            if(in)begin
                next_state = S2;
                out = 1'b1;
            end

            else begin
                next_state = S0;
                out = 1'b0;
            end
    endcase
end

endmodule