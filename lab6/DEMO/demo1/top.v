module top(
   input clk,
   input rst,
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output hsync,
   output vsync
    );


    wire clk_25MHz;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480


     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz)
    );

   pixel_gen pixel_gen_inst(
       .h_cnt(h_cnt),
       .valid(valid),
       .vgaRed(vgaRed),
       .vgaGreen(vgaGreen),
       .vgaBlue(vgaBlue)
    );

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
      
endmodule
