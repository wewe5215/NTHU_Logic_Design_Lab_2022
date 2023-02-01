`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: Bob Cheng
//
// Create Date: 2019/08/25 12:47:53
// Module Name: top
// Project Name: Chip2Chip
// Additional Comments: top module for master, pass signals and perform debounce onepulse
//////////////////////////////////////////////////////////////////////////////////
module debounce (pb_debounced, pb, clk);
	output pb_debounced; // signal of a pushbutton after being debounced
	input pb; // signal from a pushbutton
	input clk;

	reg [3:0] DFF;
	always @(posedge clk)begin
		DFF[3:1] <= DFF[2:0];
		DFF[0] <= pb;
	end
	assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse (pb_debounced, clock, pb_one_pulse);
	input pb_debounced;
	input clock;
	output reg pb_one_pulse;
	reg pb_debounced_delay;
	always @(posedge clock) begin
		pb_one_pulse <= pb_debounced & (! pb_debounced_delay);
		pb_debounced_delay <= pb_debounced;
	end
endmodule

module top(clk, rst_n, request, valid, seven_seg, notice_slave, AN, data_in, ack);
    input clk;
    input rst_n;
    input [3-1:0]data_in;
    input request;
    input valid;
    output [7-1:0] seven_seg;
    output notice_slave;
    output [4-1:0] AN;
    output ack;

    wire rst_n_inv;
    wire [3-1:0]slave_data_o;
    wire [8-1:0]slave_data_dec;
    wire db_rst_n, op_rst_n;
    assign rst_n_inv = ~op_rst_n;
    assign AN = 4'b1110;
    
    debounce db_0(.pb_debounced(db_rst_n), .pb(rst_n), .clk(clk));
    onepulse op_0(.pb_debounced(db_rst_n), .clock(clk), .pb_one_pulse(op_rst_n));
    slave_control sl_ctrl_0(.clk(clk), .rst_n(rst_n_inv), .request(request), .ack(ack), .data_in(data_in), .notice(notice_slave), .valid(valid), .data(slave_data_o));
    decoder dec0(.in(slave_data_o), .out(slave_data_dec));
    seven_segment dis_0(.in(slave_data_dec), .out(seven_seg));


endmodule
