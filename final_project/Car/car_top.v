`timescale 1ns/1ps
module Car_Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    output trig,
    output left_motor,
    output reg [1:0]left,
    output right_motor,
    output reg [1:0]right,

    //ALS
    input miso,
    output spi_sclk, //pin3
    output cs, //pin1
    output cs_mon,
    output sclk_mon,
    output Din_mon,
    //output[3:0] AN,
    //output [7:0] CA,
    output w3,
    output w7,
    output turn_back,
    output turn_forward,
    //alarm
    input change_left,//left_btn
    input change_right,//right_btn
    input change_mode,//mid_btn
    input setting,//down_btn
    input switch0,
    input switch1,
    output [4-1:0] AN,
    output [7-1:0] seven_seg,
    output [2-1:0] clock_state,
    output ring,
    output ring_signal
    
);
    wire ring_tmp;
    assign ring = ring_tmp;
    assign ring_signal = ring_tmp;
   // assign ring_signal = ring_tmp;
    clock_Top cttt(clk, rst, change_left, change_right, change_mode, setting, switch0, switch1, AN, seven_seg, clock_state, ring_tmp);
    PmodALS pma(clk, miso, spi_sclk, cs, cs_mon, sclk_mon, Din_mon, w3, w7);
    //modified 109062320
    reg [3-1:0] mode_before_backward, next_mode_before_backward;
    reg [3-1:0] mode, next_mode;
    reg [2-1:0] counter, next_counter;
    wire [3-1:0] tracker_state;
    parameter STOP = 3'b000;
    parameter LEFT = 3'b001;
    parameter CENTER = 3'b010;
    parameter RIGHT = 3'b011;
    parameter BACKWARD = 3'b100;
  

    //for {left, right}
    //(0, 0) -->motor off
    //(1, 0) -->forward
    //(0, 1) -->backward
    //(1, 1) -->motor off
    parameter OFF = 2'b00;
    parameter FOR = 2'b10;
    parameter BACK = 2'b01;

    
    wire Rst_n, rst_pb, clk_1hz;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);
    clk_for_1hz cf1(clk, clk_1hz);
    always @(posedge clk)begin
        if(Rst_n)begin
            mode <= STOP;
            mode_before_backward <= STOP;
            counter <= 2'b00;
        end

        else begin
            mode <= next_mode;
            mode_before_backward <= next_mode_before_backward;
            counter <= next_counter;
        end

    end

    always @(*)begin
        if(ring)begin
            if(turn_back)begin
                if(turn_forward)begin
                    next_counter = counter;
                    next_mode = STOP;
                end

                else begin 
                    next_counter = counter + 2'b01;
                    next_mode = BACKWARD;
                end
                next_mode_before_backward = mode;
            end

            else begin
                if(turn_forward)begin
                    next_mode_before_backward = mode_before_backward;
                    next_counter = counter;
                    next_mode = CENTER;
                end

                else begin
                    next_mode_before_backward = mode_before_backward;
                    if(mode == BACKWARD)begin
                        if(counter != 2'b01)begin
                            if(clk_1hz)
                                next_counter = counter + 2'b01;
                            else
                                next_counter = counter;
                            next_mode = BACKWARD;
                        end

                        else begin
                            next_counter = 2'b00;
                            next_mode = tracker_state;

                        end
                    end

                    else begin
                        next_counter = 2'b00;
                        next_mode = tracker_state;
                    end
                end
            end
        end

        else begin
            next_mode = STOP;
            next_mode_before_backward = mode_before_backward;
            next_counter = 2'd0;
        end

    end

    
    //assign mode = (turn_back == 1'b1) ? BACKWARD : tracker_state;
    // [TO-DO] Use left and right to set your pwm
    //pwm = {left_pwm, right_pwm}
    motor A(
        .clk(clk),
        .rst(Rst_n),
        .mode(mode),
        .pwm({left_motor, right_motor})
    );

    sonic_top B(
        .clk(clk), 
        .rst(Rst_n),
        .signal0(w3),
        .signal1(w7),
        .Echo(echo), 
        .Trig(trig),
        .turn_back(turn_back),
        .turn_forward(turn_forward)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .mode_before_backward(mode_before_backward),
        .turn_back(turn_back),
        .tracker_state(tracker_state)
       );
//modified
    always @(*) begin
        case(mode)
            STOP:begin
                left = OFF;
                right = OFF;
            end

            LEFT:begin
                left = FOR;
                right = FOR;
            end

            RIGHT:begin
                left = FOR;
                right = FOR;
            end

            CENTER:begin
                left = FOR;
                right = FOR;
            end

            BACKWARD:begin
                left = BACK;
                right = BACK;
            end

            default:begin
                left = FOR;
                right = FOR;
            end

        endcase
    end

endmodule

