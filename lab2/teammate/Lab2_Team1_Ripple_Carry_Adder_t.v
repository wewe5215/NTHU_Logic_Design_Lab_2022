`timescale 1ns/1ps

module Ripple_Carry_Adder_t;
reg [7:0] a = 8'b00000000;
reg [7:0] b = 8'b00000001;
reg cin = 1'b0;
wire cout;
wire [7:0] sum;

Ripple_Carry_Adder RCA( a, b, cin, cout, sum);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Adders.fsdb");
//      $fsdbDumpvars;
// end

initial begin

    $monitor($time, " a=%d b=%d cin=%b | cout=%b  sum=%d",
      a, b, cin, cout, sum);
  end

initial begin
    repeat (2 ** 8) begin
        #2
        a = a + 8'b00000001; //a+1
        b = b + 8'b00000001; //b+1
        cin = cin + 1'b1; //c+1
    end
    $finish;
end
endmodule
