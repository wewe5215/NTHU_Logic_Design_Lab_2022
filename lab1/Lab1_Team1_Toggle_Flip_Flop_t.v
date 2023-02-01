`timescale 1ns/1ps
module Toggle_Flip_Flop_t;
reg clk = 1'b0;
reg t = 1'b0;
reg rst_n = 1'b0;
wire q;

always#(1)clk = ~clk;

Toggle_Flip_Flop t0(
    .clk(clk),
    .t(t),
    .rst_n(rst_n),
    .q(q)
);

initial begin

    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    @(negedge clk) t = 1'b1;
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    @(negedge clk) $finish;
end

endmodule