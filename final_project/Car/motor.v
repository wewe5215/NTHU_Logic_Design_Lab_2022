module motor(
    input clk,
    input rst,
    input [3-1:0]mode,
    output  [1:0]pwm
);
    parameter STOP = 3'b000;
    parameter LEFT = 3'b001;
    parameter CENTER = 3'b010;
    parameter RIGHT = 3'b011;
    parameter BACKWARD = 3'b100;

    parameter Speed_Max = 10'd1023;
    parameter Speed_Half = 10'd500;
    
    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm); //enable A
    motor_pwm m1(clk, rst, right_motor, right_pwm); //enable B
    
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
    //speed 
    always@(*)begin
        case(mode)
            STOP:begin
                next_left_motor = 10'b0;
                next_right_motor = 10'b0;
            end

            LEFT:begin
                next_left_motor = Speed_Half;
                next_right_motor = Speed_Max;
            end

            RIGHT:begin
                next_left_motor = Speed_Max;
                next_right_motor = Speed_Half;
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
                next_left_motor = 10'b0;
                next_right_motor = 10'b0;
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

