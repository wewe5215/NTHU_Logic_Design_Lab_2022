`timescale 1ns/1ps

module Multiplier_4bit_t;
reg [4-1:0] a = 4'b0000;
reg [3:0]   b = 4'b0000;
wire [8-1:0] p;
Multiplier_4bit m0(.a(a),
                    .b(b),
                     .p(p));
initial begin

    $monitor($time, " a=%d b=%d | p=%d",
      a, b, p);
  end
initial begin
   
    repeat(2**4)begin
        repeat(2**4)begin
        #1
            a = a + 4'b0001;
        end
        
        b = b + 4'b0001;
    end
    #5 $finish;
end
endmodule