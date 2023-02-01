`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: Bob Cheng
//
// Create Date: 2019/08/25
// Module Name: encoder
// Project Name:Chip2Chip
// Additional Comments: Control block for master.
// I/O:
// clk           :clock signal.
// rst_n         :reset signal, reset module when rst_n == 0.
// request       :request signal from button press by user.
// ack           :ack sent by slave.
// data_in       :data input from user.
// notice        :signal indicating the recieve of ack from slave, will be asserted for 1 sec.
// data          :data output to slave.
// valid         :signal sent to slave indicating the current data is valid and is ready to be sampled.
// request2s     :request signal output to slave, notifying slave there's data to send.
//////////////////////////////////////////////////////////////////////////////////



module master_control(clk, rst_n, request, ack, data_in, notice, data, valid, request2s);
    input clk;
    input rst_n;
    input request;
    input ack;
    input [3-1: 0] data_in;
    output reg request2s;
    output reg notice;
    output reg [3-1:0] data;
    output reg valid;

    parameter state_wait_rqst = 3'b000;  // wait for user to push btn to send request to slave.
    parameter state_wait_ack  = 3'b001;  // request sent, wait for slave to resond with an ack, if no act is received, keep sending request2s
    parameter state_wait_to_send_data = 3'b100; //illuminate leftmost LED on the board for one sec indicating ack has been recieved
    parameter state_send_data = 3'b101; // send the actual data.

    reg [3-1:0] state, next_state;
    reg next_notice;
    reg [3-1:0] next_data;
    reg next_request2s;
    reg start, next_start; // control signals of counter.
    reg next_valid;

    wire done; //ouput from counter, asserted when counter has counted for 1 sec.

    counter cnt_0(.clk(clk), .rst_n(rst_n), .start(start), .done(done));

    always@(posedge clk) begin
        if (rst_n == 0) begin
            notice = 1'b0;
            state = state_wait_rqst;
            data = 0;
            request2s = 0;
            start = 0;
            valid = 0;
        end
        else begin
            notice <= next_notice;
            state <= next_state;
            data <= next_data;
            request2s <= next_request2s;
            start <= next_start;
            valid <= next_valid;
        end
    end

    always@(*) begin
        next_state = state;
        next_notice = notice;
        next_data = data;
        next_request2s = request2s;
        next_start = start;
        next_valid = valid;
        case(state)
            state_wait_rqst: begin
                next_state = (request == 1'b1)? state_wait_ack: state_wait_rqst;
                next_notice = 1'b0;
                next_data = 3'b000;
                next_request2s = (request == 1'b1)? 1'b1: 1'b0;
                next_start = 1'b0;
                next_valid = 1'b0;
            end

            state_wait_ack: begin
                next_state = (ack == 1'b1)? state_wait_to_send_data: state_wait_ack;
                next_notice = 1'b0;
                next_data = 3'b000;
                next_request2s = (ack == 1'b1)? 1'b0: 1'b1; // if no ack is present keep sending request to slave
                next_start = (ack == 1'b1)? 1'b1: 1'b0; // if ack recieved, start counting for 1 second with counter.
                next_valid = 1'b0;
            end
            state_wait_to_send_data: begin
                next_state = (done == 1'b1)? state_send_data: state_wait_to_send_data;
                next_notice = (done == 1'b1)? 1'b0: 1'b1; //illuminating LED.
                next_data = (done == 1'b1)? data_in: 3'b000; // time to send data!
                next_request2s = 1'b0;
                next_start = (done == 1'b1)? 1'b0: 1'b1;
                next_valid = (done == 1)? 1'b1: 1'b0; //counting done!, time to set our output data as valid
            end
            state_send_data: begin
                next_state = (ack == 1'b0)? state_wait_rqst: state_send_data;
                next_notice = 1'b0;
                next_data = (ack == 1'b0)? 3'b000: data_in;
                next_request2s = 1'b0;
                next_start = 1'b0;
                next_valid = (ack == 1'b0)? 1'b0: 1'b1;
            end
            default: begin
            end
        endcase
    end
endmodule
