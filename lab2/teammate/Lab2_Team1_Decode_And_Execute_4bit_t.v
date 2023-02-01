`timescale 1ns/1ps

module Decode_and_Execute_t;
    reg [3:0] rs = 4'b0000;
    reg [3:0] rt = 4'b0000;
    reg [2:0] sel = 3'b000;
    wire [3:0] rd;

Decode_And_Execute DAE(
    .rs (rs),
    .rt (rt),
    .sel (sel),
    .rd (rd)
);

initial begin

    $monitor($time, " rs=%b rt=%b sel=%b | rd=%b  ",
      rs, rt, sel, rd);
  end
integer i,j,k;
initial begin
   for(k=0;k<8;k=k+1)
  begin
   sel=3'b0+k;
   
   for(i=0;i<16;i=i+1)
   begin
   rs=4'b0+i;
   
     for(j=0;j<16;j=j+1)
     begin
     rt=4'b0+j;
     #1;
      end
     end
     end
    
    #1 $finish;
end


endmodule