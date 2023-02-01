`timescale 1ns / 1ps

module bcd_control(
    input [1:0] selector,
    input [3:0] digit3,
    input [3:0] digit2,
    input [3:0] digit1,
    input [3:0] digit0,
    output reg [3:0] digit_select
);
    
    always @(*) begin
        case(selector)
            2'd0: digit_select <= digit0;
            2'd1: digit_select <= digit1;
            2'd2: digit_select <= digit2;
            2'd3: digit_select <= digit3;
            default: digit_select <= digit0;    
        endcase
    end
endmodule