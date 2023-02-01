`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2021 16:54:44
// Design Name: 
// Module Name: bcd_to_cathode_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module bcd_to_cathode_control(
    input [3:0] digit,
    output reg [7:0] CA
    );
    
    always @(digit) begin
        case(digit)
            4'd0: CA <= 8'b11000000;
            4'd1: CA <= 8'b11111001;
            4'd2: CA <= 8'b10100100;
            4'd3: CA <= 8'b10110000;
            4'd4: CA <= 8'b10011001;
            4'd5: CA <= 8'b10010010;
            4'd6: CA <= 8'b10000010;
            4'd7: CA <= 8'b11111000;
            4'd8: CA <= 8'b10000000;
            4'd9: CA <= 8'b10010000;
            default: CA <= 8'b11000000; //0 
        endcase
    end
endmodule