`timescale 1ns / 1ps

module clock_divider(
    input clk,
    output reg clk_div
);
    
    reg [15:0] counter;
    
    // Initialization
    initial begin
        counter = 16'd0;
        clk_div = 0;
    end
    
    always @(posedge clk) begin
        if(counter == 16'd20000) begin
            counter <= 0;
            clk_div = ~clk_div;
        end
        else
            counter = counter + 16'd1;
    end
endmodule