`timescale 1ns / 1ps

module PmodALS(
    input clk,
    input miso, //pin4
    output spi_sclk, //pin3
    output cs, //pin1
    output cs_mon,
    output sclk_mon,
    output Din_mon,
    //output[3:0] AN,
    //output [7:0] CA,
    output w3,
    output w7
    );
    
    wire [7:0] w_RX_Byte;
    wire [11:0] w_BCD;
    reg i_Start = 0;
    wire o_RX_DV;
    wire o_DV;
    reg [1:0] counter = 4'b0000;
    //wire w_DV;
    
   // assign w3 = 1'b0;
    //assign w7 = 1'b0;
    assign w3 = (w_BCD[3:0] > 4'd4)?1:0;
    assign w7 = (w_BCD[7:4] > 4'd4)?1:0;
    //assign w11 = (w_BCD[11:8] > 4'd4)?1:0;
    
    always @ (posedge o_RX_DV or posedge o_DV) begin
        if(counter == 4'b0000) begin
            i_Start <= 1'b1;
            counter <= counter + 4'd1;
        end
        else begin
            if((counter == 4'd15) | (o_DV == 1'b1)) begin
                counter <= 4'd0;
                i_Start <= 1'b0;
            end
            else
                counter <= counter + 4'd1;
         end
    end
    
    spi_interface spi_interface_inst1(
        .clk(clk), 
        .Din(miso), 
        .sclk(spi_sclk), 
        .cs(cs), 
        .o_RX_Byte(w_RX_Byte), 
        .cs_mon(cs_mon), 
        .sclk_mon(sclk_mon), 
        .Din_mon(Din_mon),
        .o_RX_DV(o_RX_DV)
    );
    
    double_dabble double_dabble_inst1(
        .i_Clock(clk), 
        .i_Binary(w_RX_Byte), 
        .i_Start(i_Start),
        .o_BCD(w_BCD), 
        .o_DV(o_DV)
    );
    
    /*seven_segment_display seven_segment_display_inst1(
        .clk(clk),
        .digit0(w_BCD[3:0]),
        .digit1(w_BCD[7:4]),
        .digit2(w_BCD[11:8]),
        .digit3(4'b0000),
        .AN(AN),
        .CA(CA)
    );*/
    
endmodule
