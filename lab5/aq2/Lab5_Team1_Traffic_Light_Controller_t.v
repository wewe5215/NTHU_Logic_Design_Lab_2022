`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/21 20:16:55
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Traffic_Light_Controller_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg lr_has_car = 1'b0;
wire [2:0] hw_light;
wire [2:0] lr_light;

Traffic_Light_Controller m (
  .clk (clk),
  .rst_n (rst_n),
  .lr_has_car (lr_has_car),
  .hw_light (hw_light),
  .lr_light (lr_light)
);

`define CYC 10
always #(`CYC / 2) clk = ~clk;
initial begin
 $monitor("clk = %b, rst_n = %b, lr_has_car = %b | hw_light = %b, lr_light = %b", clk, rst_n, lr_has_car, hw_light, lr_light);

end

initial begin
@(negedge clk) rst_n = 1'b0;
@(negedge clk) rst_n = 1'b1; 
#(`CYC*70)
$display("70 cycles!!"); 
#(`CYC*10)
$display("80 cycles!!and lr has car! change to next state!"); 
lr_has_car = 1'b1;
#(`CYC*25)
$display("25 cycles!!change to next state");
#(`CYC*1)
$display("1 cycle!!change to next state");
#(`CYC*70)
$display("70 cycles!!change to next state");
#(`CYC*25)
$display("25 cycles!!change to next state");
#(`CYC*1)
$display("1 cycles!!change to next state");
#(`CYC*70)
$display("initial state");
lr_has_car = 1'b0;
$display("70 cycles!!with no car");
#(`CYC*10)
$display("80 cycles!!with no car");
#(`CYC*25)
$display("25 cycles!!still no car");
 @(negedge clk) rst_n = 1'b0;
 @(negedge clk) rst_n = 1'b1; 
  #(`CYC*100)
 $finish;
end 

endmodule
