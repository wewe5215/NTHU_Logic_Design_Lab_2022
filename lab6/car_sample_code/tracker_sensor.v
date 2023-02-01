`timescale 1ns/1ps
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
