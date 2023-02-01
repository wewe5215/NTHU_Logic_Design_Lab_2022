`timescale 1ns / 1ps

module Lab2_Team1_Carry_Look_Ahead_Adder_8bit_t;
    reg [7:0] a=8'b0;
    reg [7:0] b=8'b0;
    reg c0=1'b0;
    wire [7:0] s;
    wire c8;
    
    Carry_Look_Ahead_Adder_8bit cla8_1( a, b, c0, s, c8);
initial begin

    $monitor($time, " a=%d b=%d c0=%b | s=%d  c8=%b",
      a, b, c0, s, c8);
  end
integer i,j,k;
initial begin
  
  for(k=0;k<2;k=k+1)
  begin
   c0=1'b0+k;
   
   for(i=0;i<256;i=i+1)
   begin
   a=8'b0+i;
   
     for(j=0;j<256;j=j+1)
     begin
        #1 b=8'b0+j;
    end
     end
     end
    
    #1 $finish;
end
    
endmodule

