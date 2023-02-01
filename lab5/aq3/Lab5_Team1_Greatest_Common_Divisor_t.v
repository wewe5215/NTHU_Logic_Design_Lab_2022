`timescale 1ns/1ps

module Greatest_Common_Divisor_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg start = 1'b0;
reg [15:0] a = 16'd0;
reg [15:0] b = 16'd0;
wire done;
wire [15:0] gcd;
parameter cyc = 10;
always #(cyc / 2)clk = !clk;

Greatest_Common_Divisor gcdm(clk, rst_n, start, a, b, done, gcd);
initial begin
    $monitor("clk = %b, rst_n = %b, start = %b, a = %d, b = %d | done = %b, gcd = %d",
            clk, rst_n, start, a, b, done, gcd);
end

initial begin
    $display("check not reseted");
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b0;
    $display("not reseted with start = 1");
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b1;
    $display("reseted with start = 0");
    @(negedge clk)
    rst_n = 1'b0;
    start = 1'b0;
    $display("reseted with start = 1");
    @(negedge clk)
    rst_n = 1'b0;
    start = 1'b1;
    $display("start with a = 0, b = 256");
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b1;
    a = 16'd0;
    b = 16'd256;
    @(negedge clk)
    a = 16'd1;
    b = 16'd255;
    #(cyc * 3)
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b0;
    $display("start with a = 128, b = 0");
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b1;
    a = 16'd128;
    b = 16'd0;
    #(cyc * 3)
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b0;
    $display("stsrt with a = 47, b = 51");
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b1;
    a = 16'd47;
    b = 16'd51;
    #(cyc * 20)
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b0;
    $display("stsrt with a = 1024, b = 2048");
    @(negedge clk)
    rst_n = 1'b1;
    start = 1'b1;
    a = 16'd1024;
    b = 16'd2048;
    #(cyc * 10)
    @(negedge clk)
    $finish;

end

endmodule