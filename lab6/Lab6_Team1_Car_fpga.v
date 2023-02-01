`timescale 1ns/1ps
module Top(
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
    output reg [1:0]right
);
    //modified 109062320
    
    wire [3-1:0] mode;
    wire [3-1:0] tracker_state;
    parameter STOP = 3'b000;
    parameter LEFT = 3'b001;
    parameter CENTER = 3'b010;
    parameter RIGHT = 3'b011;
    parameter BACKWARD = 3'b100;
    parameter RRIGHT = 3'b101;
    parameter LLEFT = 3'b110;

    //for {left, right}
    //(0, 0) -->motor off
    //(1, 0) -->forward
    //(0, 1) -->backward
    //(1, 1) -->motor off
    parameter OFF = 2'b00;
    parameter FOR = 2'b10;
    parameter BACK = 2'b01;

    
    wire Rst_n, rst_pb, stop;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);
    assign mode = (stop == 1'b1) ? STOP : tracker_state;
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
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .left_signal(left_signal), 
        .right_signal(right_signal),
        .mid_signal(mid_signal), 
        .state(tracker_state)
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

            LLEFT:begin
                left = FOR;
                right = FOR;
            end

            RIGHT:begin
                left = FOR;
                right = FOR;
            end

            RRIGHT:begin
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

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

module sonic_top(clk, rst, Echo, Trig, stop);
	input clk, rst, Echo;
	output Trig, stop;

	wire[19:0] dis;
	wire[19:0] d;
    wire clk1M;
	wire clk_2_17;

    div clk1(clk ,clk1M);
	TrigSignal u1(.clk(clk), .rst(rst), .trig(Trig));
	PosCounter u2(.clk(clk1M), .rst(rst), .echo(Echo), .distance_count(dis));

    // [TO-DO] calculate the right distance to trig stop(triggered when the distance is lower than 40 cm)
    // Hint: using "dis"
    //modified by 109062320
    assign stop = (dis < 20'd40) ? 1'b1 : 1'b0;
 
endmodule

module PosCounter(clk, rst, echo, distance_count); 
    input clk, rst, echo;
    output[19:0] distance_count;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01; 
    parameter S2 = 2'b10;
    
    wire start, finish;
    reg[1:0] curr_state, next_state;
    reg echo_reg1, echo_reg2;
    reg[19:0] count, next_count, distance_register, next_distance;
    wire[19:0] distance_count; 

    always@(posedge clk) begin
        if(rst) begin
            echo_reg1 <= 1'b0;
            echo_reg2 <= 1'b0;
            count <= 20'b0;
            distance_register <= 20'b0;
            curr_state <= S0;
        end
        else begin
            echo_reg1 <= echo;   
            echo_reg2 <= echo_reg1; //echo last cycle
            count <= next_count;
            distance_register <= next_distance;
            curr_state <= next_state;
        end
    end

    always @(*) begin
        case(curr_state)
            S0: begin
                next_distance = distance_register;
                if (start) begin
                    next_state = S1;
                    next_count = count;
                end else begin
                    next_state = curr_state;
                    next_count = 20'b0;
                end 
            end
            S1: begin
                next_distance = distance_register;
                if (finish) begin
                    next_state = S2;
                    next_count = count;
                end else begin
                    next_state = curr_state;
                    next_count = (count > 20'd600_000) ? count : count + 1'b1;
                end 
            end
            S2: begin
                next_distance = count;
                next_count = 20'b0;
                next_state = S0;
            end
            default: begin
                next_distance = 20'b0;
                next_count = 20'b0;
                next_state = S0;
            end
        endcase
    end
    //modified by 109062320
    assign distance_count = distance_register * 20'd340 / 10000 / 2;
    //1M_HZ --> update every 10^(-6) sec --> miuS
    //(10^(-6)) * (m/s) / (10^(4)) / 2 = (10^(-2))(m/s) / 2 = (cm / s) / 2
    assign start = echo_reg1 & ~echo_reg2;  
    assign finish = ~echo_reg1 & echo_reg2; 
endmodule

module TrigSignal(clk, rst, trig);
    input clk, rst;
    output trig;

    reg trig, next_trig;
    reg[23:0] count, next_count;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 24'b0;
            trig <= 1'b0;
        end
        else begin
            count <= next_count;
            trig <= next_trig;
        end
    end

    always @(*) begin
        next_trig = trig;
        next_count = count + 1'b1;
        if(count == 24'd999)
            next_trig = 1'b0;
        else if(count == 24'd9999999) begin
            next_trig = 1'b1;
            next_count = 24'd0;
        end
    end
endmodule

module div(clk ,out_clk);
    input clk;
    output out_clk;
    reg out_clk;
    reg [6:0]cnt;
    
    always @(posedge clk) begin   
        if(cnt < 7'd50) begin
            cnt <= cnt + 1'b1;
            out_clk <= 1'b1;
        end 
        else if(cnt < 7'd100) begin
	        cnt <= cnt + 1'b1;
	        out_clk <= 1'b0;
        end
        else if(cnt == 7'd100) begin
            cnt <= 7'b0;
            out_clk <= 1'b1;
        end
        else begin 
            cnt <= 7'b0;
            out_clk <= 1'b1;
        end
    end
endmodule


module motor(
    input clk,
    input rst,
    input [3-1 :0]mode,
    output  [1:0]pwm
);
    parameter STOP = 3'b000;
    parameter LEFT = 3'b001;
    parameter CENTER = 3'b010;
    parameter RIGHT = 3'b011;
    parameter BACKWARD = 3'b100;
    parameter RRIGHT = 3'b101;
    parameter LLEFT = 3'b110;

    parameter Speed_Max = 10'd1023;
    parameter Speed_Half = 10'd500;
    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    //modified
    // [TO-DO] take the right speed for different situation
    always@(*)begin
        case(mode)
            STOP:begin
                next_left_motor = 10'd0;
                next_right_motor = 10'd0;
            end

            LLEFT:begin
                next_left_motor = Speed_Half;
                next_right_motor = Speed_Max;
            end

            LEFT:begin
                next_left_motor = 10'd0;
                next_right_motor = Speed_Max;

            end

            RRIGHT:begin
                next_left_motor = Speed_Max;
                next_right_motor = Speed_Half;
            end

            RIGHT:begin
                next_left_motor = Speed_Max;
                next_right_motor = 10'd0;
            end

            CENTER:begin
                next_left_motor = Speed_Max;
                next_right_motor = Speed_Max;
            end

            BACKWARD:begin
                next_left_motor = Speed_Max;
                next_right_motor = Speed_Max;
            end

            default:begin
                next_left_motor = 10'd0;
                next_right_motor = 10'd0;
            end

        endcase

    end

    assign pwm = {left_pwm, right_pwm};
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 32'd100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule

module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [3-1:0] state;
    
    parameter STOP = 3'b000;
    parameter LEFT = 3'b001;
    parameter CENTER = 3'b010;
    parameter RIGHT = 3'b011;
    parameter BACKWARD = 3'b100;
    parameter RRIGHT = 3'b101;
    parameter LLEFT = 3'b110;
    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    //modified by 109062320
    always@(*)begin
        case({left_signal, mid_signal, right_signal})
            //
            3'b000:state = BACKWARD;
            3'b001:state = RIGHT;
            3'b010:state = CENTER;
            //
            3'b011:state = RRIGHT;
            3'b100:state = LEFT;
            //right or left
            3'b101:state = RIGHT;
            //
            3'b110:state = LLEFT;
            3'b111:state = CENTER;
            default:state = BACKWARD;
        endcase

    end
endmodule