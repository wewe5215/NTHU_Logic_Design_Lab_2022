`timescale 1ns / 1ps

// Module: SPI Interface

module spi_interface(
    input clk,
    input Din,
    output reg sclk,
    output reg cs,
    output [7:0] o_RX_Byte,
    output wire cs_mon,
    output wire sclk_mon,
    output wire Din_mon,
    output wire o_RX_DV
    );
   
    reg [7:0] data_counter;             // Free running counter till 20, to time CS 
    reg [7:0] clk_div;                  // Clock divider to prescale 100 MHz FPGA clock to 1.92 MHz SPI Clock
    reg [7:0] r_RX_Byte = 8'b0000_0000; // MISO: Received 1 byte of data from PMOD_ALS
    reg r_RX_DV = 1'b0;                 // MISO: After receiving valid 1 byte data, this bit is set for 1 clock cycle
    reg [2:0] r_RX_Bit_Count = 3'b111;  // MISO: 3 positions to count from 0 to 7 in the received 1 byte serial data
    reg [3:0] internal_counter;         // Internal counter to time the data transfer
    
////////////////////////////////////////////////////////////////////////////////////////////////////
    // Monitoring on Oscilloscope
///////////////////////////////////////////////////////////////////////////////////////////////////
    assign cs_mon = cs;
    assign sclk_mon = sclk;
    assign Din_mon = Din;
    
    // Initialization
    initial begin
        data_counter = 8'd0; // 4-bit counter to time the data transfer b/w ADC - SPI
        sclk = 1'b1;
        cs = 1'b1;      // Start with CS - High
        clk_div = 8'd0; // 8-bit counter for clock divider
    end
    
/////////////////////////////////////////////////////////////////////////////////////////////////   
    // Clock divider: Generate SCLK for SPI
    // 100MHz clock input is presclaed to 2Mhz (as per the requirement from the PMOD_ALS
////////////////////////////////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        if(clk_div == 8'd25) begin
            clk_div <= 8'd0;
            sclk <= ~sclk;
        end
        else
            clk_div <= clk_div + 8'd1;
    end    
    
/////////////////////////////////////////////////////////////////////////////////////////////////
    // 8- bit counter to time the ADC conversion and data transfer over SPI
////////////////////////////////////////////////////////////////////////////////////////////////
    always @(negedge sclk) begin
        if(data_counter == 8'd15) begin
            cs <= 1'd1;
            data_counter <= data_counter + 1;
        end
        else if(data_counter == 8'd19) begin
            data_counter <= 8'd0;
            //data_counter <= data_counter + 1;
            end
            
        else if(data_counter == 8'd0) begin
            cs <= 1'd0;
            data_counter <= data_counter + 1;
            end
        else
            data_counter <= data_counter + 1;
        end

/////////////////////////////////////////////////////////////////////////////////////////////
      // Purpose: Read in SDO data.
////////////////////////////////////////////////////////////////////////////////////////////
    always @(negedge sclk) begin
    if((cs == 1'b0)) begin
        if ((data_counter == internal_counter) & (r_RX_DV == 1'b0)) begin
              r_RX_Byte[r_RX_Bit_Count] <= Din;  // Sample data
              r_RX_Bit_Count            <= r_RX_Bit_Count - 1;
              internal_counter = internal_counter + 16'd1;
              if (r_RX_Bit_Count == 3'b000)
                    r_RX_DV   <= 1'b1;   // Byte done, pulse Data Valid
        end
        else begin
                    // Default Assignments
            r_RX_DV   <= 1'b0;
            r_RX_Bit_Count <= 3'b111;
            internal_counter <= 16'd4;
            r_RX_Byte <= 8'd0;
         end
        end
    end
 
      assign o_RX_DV = r_RX_DV;
      assign o_RX_Byte = r_RX_Byte;

endmodule