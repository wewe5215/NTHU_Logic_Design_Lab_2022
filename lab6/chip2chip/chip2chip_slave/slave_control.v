`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: Bob Cheng
//
// Create Date: 2019/08/25
// Module Name:  slave_control
// Project Name: Chip2Chip
// Additional Comments: Control block for slave.
// I/O:
// clk           :clock signal.
// rst_n         :reset signal, reset module when rst_n == 0.
// request       :request signal sent by the master.
// ack           :ack output to master.
// data_in       :data input from master.
// notice        :signal indicating the receive of data or request from master, will be asserted for 1 sec.
// data          :data output to the seven segment module, in order to display the data from master.
// valid         :signal from master indicating the current data_in is valid and is ready to be sampled.
//////////////////////////////////////////////////////////////////////////////////


module slave_control(clk, rst_n, request, ack, data_in, notice, valid, data);
    input clk;
    input rst_n;
    input request;
    input [3-1:0] data_in;
    input valid;
    output reg ack;
    output reg notice;
    output reg [3-1:0] data;

    parameter state_wait_rqst = 2'b00;
    parameter state_wait_to_send_ack = 2'b01;
    parameter state_send_ack = 2'b10;
    parameter state_wait_data = 2'b11;

    reg [2-1:0] state, next_state;
    reg start, next_start;
    reg next_ack;
    reg next_notice;
    reg [3-1:0] next_data;
    wire done;
    counter cnt_0(.clk(clk), .rst_n(rst_n), .start(start), .done(done));

    always@(posedge clk) begin
        if (rst_n == 0) begin
            state <= state_wait_rqst;
            notice <= 0;
            ack <= 0;
            data <= 0;
            start <= 0;
        end
        else begin
            state <= next_state;
            notice <= next_notice;
            ack <= next_ack;
            data <= next_data;
            start <= next_start;
        end
    end

    always@(*) begin
        next_state = state;
        next_notice = notice;
        next_ack = ack;
        next_data = data;
        next_start = start;
        case(state)
            state_wait_rqst: begin
                next_state = (request == 1)? state_wait_to_send_ack: state_wait_rqst;
                next_notice =  (request == 1)? 1'b1 : 1'b0;
                next_ack = 1'b0;
                next_data = data;
                next_start = (request == 1)? 1'b1: 1'b0;// if request recieved, start counting for 1 second with counter.
            end
            state_wait_to_send_ack: begin
                next_state = (done == 1)? state_wait_data : state_wait_to_send_ack;
                next_notice = (done == 1)? 1'b0 : 1'b1;//illuminating LED.
                next_ack = (done == 1)? 1'b1 : 1'b0;
                next_data = data;
                next_start = (done == 1)? 1'b0 : 1'b1;
            end
            state_wait_data: begin
                next_state = (valid == 1)? state_wait_rqst : state_wait_data;
                next_notice = 1'b0;
                next_ack = (valid == 1) ? 1'b0 : 1'b1;
                next_data = (valid == 1) ? data_in : data;
                next_start = 1'b0;
            end
            default: begin
            end
        endcase
    end
endmodule
