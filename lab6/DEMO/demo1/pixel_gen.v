module pixel_gen(
   input [9:0] h_cnt,
   input valid,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue
   );
   
       always @(*) begin
       if(!valid)
             {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        else if(h_cnt < 128)
             {vgaRed, vgaGreen, vgaBlue} = 12'h000;
        else if(h_cnt < 256)
             {vgaRed, vgaGreen, vgaBlue} = 12'h00f;
        else if(h_cnt < 384)
             {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
        else if(h_cnt < 512)
             {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;              
        else if(h_cnt < 640)
             {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
        else
             {vgaRed, vgaGreen, vgaBlue} = 12'h0;
   end
endmodule
