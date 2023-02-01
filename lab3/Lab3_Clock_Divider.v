`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;
reg [3-1:0] counter8;
reg [2-1:0] counter3;
reg out;
always @(posedge clk) begin
    if(!rst_n)begin
        counter3 <= 2'b00;
        counter8 <= 4'b0000;
    end

    else begin
        counter8 <= counter8 + 3'b001;
        if(counter3 == 2'b10)counter3 <= 2'b00;
        else counter3 <= counter3 + 2'b01;
    end
end

assign clk1_2 = (counter8 % 2 == 0) ? 1'b1 : 1'b0;
assign clk1_4 = (counter8 % 4 == 0) ? 1'b1 : 1'b0;
assign clk1_8 = (counter8 % 8 == 0) ? 1'b1 : 1'b0;
assign clk1_3 = (counter3 % 3 == 0) ? 1'b1 : 1'b0;



always @(*)begin
    if(sel == 2'b00)out = clk1_3;
    else if(sel == 2'b01)out = clk1_2;
    else if(sel == 2'b10)out = clk1_4;
    else out = clk1_8;
end

assign dclk = out;
endmodule
