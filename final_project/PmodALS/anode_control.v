`timescale 1ns / 1ps

module anode_control(
    input [1:0] anode_selector,
    output reg [3:0] AN
    );
    
    initial begin
        AN = 4'b1111;
    end
    
    always @(anode_selector) begin
        case(anode_selector)
            2'b00: AN <= 4'b1110;
            2'b01: AN <= 4'b1101;
            2'b10: AN <= 4'b1011;
            2'b11: AN <= 4'b0111;
        endcase
    end
endmodule