`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: Bob Cheng
//
// Create Date: 2019/08/25
// Module Name: encoder
// Project Name:Chip2Chip
// Additional Comments: Encoder used to encode one hot switch input to binary encoding.
// I/O:
// in        :input from swithes, in one hot.
// out       :encoded ouput, in binary.
//////////////////////////////////////////////////////////////////////////////////


module encoder(in, out);
    input [8-1:0] in;
    output reg [3-1:0] out;
    always@(*) begin
        case(in)
            8'b0000_0001: out = 3'd0;
            8'b0000_0010: out = 3'd1;
            8'b0000_0100: out = 3'd2;
            8'b0000_1000: out = 3'd3;
            8'b0001_0000: out = 3'd4;
            8'b0010_0000: out = 3'd5;
            8'b0100_0000: out = 3'd6;
            8'b1000_0000: out = 3'd7;
            default: out = 0;
         endcase
    end
endmodule
