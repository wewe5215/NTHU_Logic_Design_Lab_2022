`timescale 1ns / 1ps

module refresh_counter(
    input clk,
    output reg [1:0] refresh_counter
);
    
    initial refresh_counter = 0;
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
endmodule