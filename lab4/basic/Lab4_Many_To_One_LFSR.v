`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
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
        out[0] <= (dff[7] ^ dff[3]) ^ (dff[1] ^ dff[2]);
        out[7:1] <= dff[6:0];
    end

end

endmodule