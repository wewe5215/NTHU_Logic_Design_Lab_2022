`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;
wire tmp_scan_in;
Many_To_One_LFSR m0(clk, rst_n, tmp_scan_in);
Scan_Chain_Design s0(clk, rst_n, tmp_scan_in, scan_en, scan_out);
assign scan_in = tmp_scan_in;
endmodule

module Many_To_One_LFSR(clk, rst_n, scan_in);
input clk;
input rst_n;
output scan_in;
reg [7:0] out;
wire [7:0] dff;
assign dff = out;
assign scan_in = out[7];
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

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;
wire [4-1:0] a, b;
wire [8-1:0] p;
Multiplier m0(a, b, p);
Scan_DFF sdff0(clk, rst_n, scan_en, p[7], scan_in, a[3]);
Scan_DFF sdff1(clk, rst_n, scan_en, p[6], a[3], a[2]);
Scan_DFF sdff2(clk, rst_n, scan_en, p[5], a[2], a[1]);
Scan_DFF sdff3(clk, rst_n, scan_en, p[4], a[1], a[0]);
Scan_DFF sdff4(clk, rst_n, scan_en, p[3], a[0], b[3]);
Scan_DFF sdff5(clk, rst_n, scan_en, p[2], b[3], b[2]);
Scan_DFF sdff6(clk, rst_n, scan_en, p[1], b[2], b[1]);
Scan_DFF sdff7(clk, rst_n, scan_en, p[0], b[1], b[0]);

assign scan_out = b[0];
endmodule

module Scan_DFF(clk, rst_n, scan_en, data, scan_in, scan_out);
input clk, rst_n, scan_en;
input data, scan_in;
output reg scan_out;
always @(posedge clk) begin
    if(!rst_n)begin
        scan_out <= 1'b0;
    end

    else begin
        if(scan_en)begin
            scan_out <= scan_in;
        end

        else begin
            scan_out <= data;
        end
    end
end

endmodule

module Multiplier(a, b, p);
input [4-1:0] a, b;
output [8-1:0] p;
wire a0b0;//p0
wire a1b0, a0b1;//p1
wire a2b0, a1b1, a0b2;//p2
wire a3b0, a2b1, a1b2, a0b3;//p3
wire a3b1, a2b2, a1b3;//p4
wire a3b2, a2b3;//p5
wire a3b3;//p6
wire c0, c1, s2, s5;
wire [2-1:0] c2, s3, s4, c5;
wire [3-1:0] c3, c4;
//p0
Full_adder fa0(a0b0, 1'b0, 1'b0, c0, p[0]);
//p1
Full_adder fa1(a1b0, a0b1, c0, c1, p[1]);
//p2
Full_adder fa2(a2b0, a1b1, a0b2, c2[0], s2);
Full_adder fa3(s2, c1, 1'b0, c2[1], p[2]);
//p3
Full_adder fa4(a3b0, a2b1, a1b2, c3[0], s3[0]);
Full_adder fa5(s3[0], a0b3, c2[0], c3[1], s3[1]);
Full_adder fa6(s3[1], c2[1], 1'b0, c3[2], p[3]);
//p4
Full_adder fa7(a3b1, a2b2, a1b3, c4[0], s4[0]);
Full_adder fa8(s4[0], c3[0], c3[1], c4[1], s4[1]);
Full_adder fa9(s4[1], c3[2], 1'b0, c4[2], p[4]);
//p5
Full_adder fa10(a3b2, a2b3, c4[0], c5[0], s5);
Full_adder fa11(s5, c4[1], c4[2], c5[1], p[5]);
//p6
Full_adder fa12(a3b3, c5[0], c5[1], p[7], p[6]);

assign a0b0 = a[0] & b[0];
assign a1b0 = a[1] & b[0];
assign a2b0 = a[2] & b[0];
assign a3b0 = a[3] & b[0];

assign a0b1 = a[0] & b[1];
assign a1b1 = a[1] & b[1];
assign a2b1 = a[2] & b[1];
assign a3b1 = a[3] & b[1];

assign a0b2 = a[0] & b[2];
assign a1b2 = a[1] & b[2];
assign a2b2 = a[2] & b[2];
assign a3b2 = a[3] & b[2];

assign a0b3 = a[0] & b[3];
assign a1b3 = a[1] & b[3];
assign a2b3 = a[2] & b[3];
assign a3b3 = a[3] & b[3];
endmodule

module Full_adder(a, b, cin, cout, sum);
input a, b;
input cin;
output cout, sum;

assign cout = (a & b) | (b & cin) | (a & cin);
assign sum = a ^ b ^ cin;
endmodule