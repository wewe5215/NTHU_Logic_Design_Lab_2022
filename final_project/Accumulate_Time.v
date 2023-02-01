`timescale 1ns/1ps

module Accumulate_Time(
input clk,
input rst,
input [2-1:0] system_state,
input change_left,
input change_right,
input setting,
input stop_resume,
output [7-1:0] a, b, c, d
);
//system state
parameter clock_mode = 2'b00;
parameter alarm_mode = 2'b01;
parameter accumulate_mode = 2'b10;
parameter countdown_mode = 2'b11;
//local state
parameter start = 2'b00;
parameter counting = 2'b01;
parameter stop = 2'b10;
reg [2-1:0] local_state, next_local_state;
//minute, second
reg[5:0] sec, next_sec;
reg[5:0] minute, next_minute;
reg[4-1:0] sec_digit0, sec_digit1;
reg[4-1:0] minute_digit0, minute_digit1;
wire clk_1hz;
clk_for_1hz c1(clk, clk_1hz);

always @(posedge clk)begin
    if(rst)begin
        local_state <= start;
        minute <= 6'd0;
        sec <= 6'd0;

    end

    else begin
        local_state <= next_local_state;
        minute <= next_minute;
        sec <= next_sec;
    end
end

always @(*)begin
    if(system_state == accumulate_mode)begin
        case(local_state)
            start:begin
                if(stop_resume)begin
                    next_local_state = counting;
                    
                end

                else begin
                    next_local_state = start;
                end
                next_minute = 6'd0;
                next_sec = 6'd0;
            end

            counting:begin
                if(stop_resume)begin
                    next_local_state = stop;
                    next_minute = minute;
                    next_sec = sec;
                end

                else begin
                    next_local_state = counting;
                    if(clk_1hz)begin
                        if(sec == 6'd59)begin
                            if(minute == 6'd59)begin
                                next_minute = minute;
                                next_sec = sec;
                            end

                            else begin
                                next_minute = minute + 6'd1;
                                next_sec = 6'd0;
                            end
                        end

                        else begin
                            next_minute = minute;
                            next_sec = sec + 6'd1;
                        end
                    end

                    else begin
                        next_minute = minute;
                        next_sec = sec;
                    end
                end
                
            end

            stop:begin
                if(!stop_resume)begin
                    next_local_state = stop;
                    next_minute = minute;
                    next_sec = sec;
                end

                else begin
                    next_local_state = counting;
                    if(clk_1hz)begin
                        if(sec == 6'd59)begin
                            if(minute == 6'd59)begin
                                next_minute = minute;
                                next_sec = sec;
                            end

                            else begin
                                next_minute = minute + 6'd1;
                                next_sec = 6'd0;
                            end
                        end

                        else begin
                            next_minute = minute;
                            next_sec = sec + 6'd1;
                        end
                    end

                    else begin
                        next_minute = minute;
                        next_sec = sec;
                    end
                end
            end
            
            default:begin
                next_local_state = local_state;
                next_minute = minute;
                next_sec = sec;
            
            end
        endcase

    end

    else begin
        if(local_state == counting)begin
            next_local_state = counting;
            if(clk_1hz)begin
                if(sec == 6'd59)begin
                    if(minute == 6'd59)begin
                        next_minute = minute;
                        next_sec = sec;
                    end

                    else begin
                        next_minute = minute + 6'd1;
                        next_sec = 6'd0;
                    end
                end

                else begin
                    next_minute = minute;
                    next_sec = sec + 6'd1;
                end
            end
            else begin
                next_minute = minute;
                next_sec = sec;
            end
        end

        else if(local_state == stop)begin
            next_local_state = stop;
            next_minute = minute;
            next_sec = sec;
        end

        else begin
            next_local_state = local_state;
            next_minute = minute;
            next_sec = sec;
        end
    end
    

end

//seven segment display
//minute
always @(*)begin
    case(minute / 10)
        6'd0:minute_digit0 = 4'd0;
        6'd1:minute_digit0 = 4'd1;
        6'd2:minute_digit0 = 4'd2;
        6'd3:minute_digit0 = 4'd3;
        6'd4:minute_digit0 = 4'd4;
        6'd5:minute_digit0 = 4'd5;
        default:minute_digit0 = 4'd0;
    endcase

    case(minute % 10)
        6'd0:minute_digit1 = 4'd0;
        6'd1:minute_digit1 = 4'd1;
        6'd2:minute_digit1 = 4'd2;
        6'd3:minute_digit1 = 4'd3;
        6'd4:minute_digit1 = 4'd4;
        6'd5:minute_digit1 = 4'd5;
        6'd6:minute_digit1 = 4'd6;
        6'd7:minute_digit1 = 4'd7;
        6'd8:minute_digit1 = 4'd8;
        6'd9:minute_digit1 = 4'd9;
        default:minute_digit1 = 4'd0;
    endcase
end
//sec
always @(*)begin
    case(sec / 10)
        6'd0:sec_digit0 = 4'd0;
        6'd1:sec_digit0 = 4'd1;
        6'd2:sec_digit0 = 4'd2;
        6'd3:sec_digit0 = 4'd3;
        6'd4:sec_digit0 = 4'd4;
        6'd5:sec_digit0 = 4'd5;
        default:sec_digit0 = 4'd0;
    endcase

    case(sec % 10)
        6'd0:sec_digit1 = 4'd0;
        6'd1:sec_digit1 = 4'd1;
        6'd2:sec_digit1 = 4'd2;
        6'd3:sec_digit1 = 4'd3;
        6'd4:sec_digit1 = 4'd4;
        6'd5:sec_digit1 = 4'd5;
        6'd6:sec_digit1 = 4'd6;
        6'd7:sec_digit1 = 4'd7;
        6'd8:sec_digit1 = 4'd8;
        6'd9:sec_digit1 = 4'd9;
        default:sec_digit1 = 4'd0;
    endcase
end

digit_seven_segment dss1(minute_digit0, a);
digit_seven_segment dss2(minute_digit1, b);
digit_seven_segment dss3(sec_digit0, c);
digit_seven_segment dss4(sec_digit1, d);
endmodule