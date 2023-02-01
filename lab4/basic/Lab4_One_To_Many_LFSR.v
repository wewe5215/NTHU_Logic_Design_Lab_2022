`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;
wire [7:0] dff;
assign dff = out;
always @(posedge clk)begin
    if(!rst_n)begin
        out <= 8'b10111101;
    end

    else begin
        out[0] <= dff[7];
        out[1] <= dff[0];
        out[2] <= dff[1] ^ dff[7];
        out[3] <= dff[2] ^ dff[7];
        out[4] <= dff[3] ^ dff[7];
        out[7:5] <= dff[6:4]; 
    end

end
endmodule