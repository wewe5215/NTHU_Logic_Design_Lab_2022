`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Instantiate
//- clock divider 
//- refresh counter
//- bcd control
//////////////////////////////////////////////////////////////////////////////////


module seven_segment_display(
    input clk,
    input [3:0] digit0,
    input [3:0] digit1,
    input [3:0] digit2,
    input [3:0] digit3,
    output[3:0] AN,
    output [7:0] CA
);
    
    wire clk_div_out;
    wire [1:0] refresh_counter_out;
    wire [3:0] digit_select_out;
        
    // Instantiate clock divider 100MHz to 10 KHz
    clock_divider clock_divider_inst1(
    .clk(clk), 
    .clk_div(clk_div_out)
    );   
    //Instantiate 4-bit refresh counter
    refresh_counter refresh_counter_inst1(
    .clk(clk_div_out), 
    .refresh_counter(refresh_counter_out)
    );
    //Instatiate bcd control
    bcd_control bcd_control_inst1(
    .selector(refresh_counter_out), 
    .digit3(digit3), 
    .digit2(digit2), 
    .digit1(digit1), 
    .digit0(digit0), 
    .digit_select(digit_select_out)
    );
    // Anode control
    anode_control anode_control_inst1(
    .anode_selector(refresh_counter_out), 
    .AN(AN)
    );
    // BCD to Cathode control
    bcd_to_cathode_control bcd_to_cathode_control_inst1(
    .digit(digit_select_out), 
    .CA(CA)
    );   
    
endmodule