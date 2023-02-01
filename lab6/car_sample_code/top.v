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

