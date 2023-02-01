`timescale 1ns/1ps

module Mealy_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire out;
wire [2:0] state;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Mealy m (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .out (out),
    .state (state)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (negedge clk) rst_n = 1'b0;
    @ (posedge clk) // reset to S0
    @ (negedge clk) rst_n = 1'b1;
    @ (posedge clk) // S0 -0-> S0
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) // S0 -1-> S2
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S2 -0-> S5
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) // S5 -1-> S4
    @ (posedge clk) // S4 -1-> S4
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S4 -1-> S2
    @ (posedge clk) // S2 -0-> S5
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S5-0->S3
    @ (posedge clk) // S3-0->S3
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) // S3-1->S2
    @ (posedge clk) // S2-1->S1
    @ (negedge clk) $finish;
end

endmodule
