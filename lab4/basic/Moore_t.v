`timescale 1ns/1ps

module Moore_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire [1:0] out;
wire [2:0] state;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Moore m (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .out (out),
    .state (state)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Moore.fsdb");
//     $fsdbDumpvars;
// end
initial begin
        $monitor("clk = %b, rst_n = %b, in = %b | out = %b, state = %d", clk, rst_n, in, out, state);

end
initial begin
    @ (negedge clk) rst_n = 1'b0;
    @ (posedge clk) // reset to S0
    @ (negedge clk) rst_n = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S0 -0-> S1
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) // S1 -1-> S5
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S5 -0-> S3
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) // S3 -1-> S0
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S0 -0-> S1
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) // S1 -0-> S4
    @ (posedge clk) // S4 -0-> S4
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) // S4 -1-> S5
    @ (posedge clk) //S5-1-> S0
    @ (posedge clk) //S0-1-> S2
    @ (negedge clk) $finish;
end

endmodule