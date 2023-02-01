`timescale 1ns/1ps

module Crossbar_4x4_4bit_t;
reg [4-1:0] in1 = 4'b0000; 
reg [4-1:0] in2 = 4'b0010;
reg [4-1:0] in3 = 4'b0100;
reg [4-1:0] in4 = 4'b1000;
reg [5-1:0] control = 5'b00000;
wire [4-1:0] out1, out2, out3, out4;

Crossbar_4x4_4bit c0(
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .control(control),
    .out1(out1),
    .out2(out2),
    .out3(out3),
    .out4(out4)
);

initial begin
    repeat(2**5)begin
        #1
        in1 = in1 + 4'b1;
        in2 = in2 + 4'b1;
        in3 = in3 + 4'b1;
        in4 = in4 + 4'b1;
        control = control + 5'b1;
    end
    #1 $finish;
end
endmodule