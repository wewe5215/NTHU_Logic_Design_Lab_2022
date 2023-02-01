`timescale 1ns/1ps

module Time_display(
    input clk,
    input rst,
    input [2-1:0] system_state,
    input change_left,
    input change_right,
    input setting,
    output [7-1:0] a, b, c, d,
    output reg[4:0] hour,
    output reg[5:0] minute,
    output setting_mode_on
);
//system state
parameter clock_mode = 2'b00;
parameter alarm_mode = 2'b01;
parameter accumulate_mode = 2'b10;
parameter countdown_mode = 2'b11;
//local state
parameter start = 2'b00;
parameter counting = 2'b01;
parameter set = 2'b10;
reg [2-1:0] local_state, next_local_state;
//hour, minute
reg[4:0] next_hour;
reg[5:0] next_minute;
reg[12-1:0] counter, next_counter;
reg[4-1:0] hour_digit0, hour_digit1;
reg[4-1:0] minute_digit0, minute_digit1;
wire clk_1hz;
assign setting_mode_on = (local_state == set) ? 1'b1 : 1'b0;

clk_for_1hz c1(clk, clk_1hz);
always @(posedge clk) begin
    if(rst)begin
        local_state <= counting;
        hour <= 5'd0;
        minute <= 6'd0;
        counter <= 12'd0;
    end

    else begin
        local_state <= next_local_state;
        hour <= next_hour;
        minute <= next_minute;
        counter <= next_counter;
    end
end

always @(*)begin
    if(system_state == clock_mode)begin
        case(local_state)
            /*start:begin
                next_local_state = counting;
                next_hour = hour;
                next_minute = minute;
                next_counter = 12'd0;
            end*/

            counting:begin
                if(setting)begin
                    next_local_state = set;
                    next_hour = hour;
                    next_minute = minute;
                    next_counter = 12'd0;
                end

                else begin
                    next_local_state = counting;
                    if(clk_1hz)begin
                        if((counter + 12'd1) % 3600 == 0)begin

                            if(hour == 5'd23)
                                next_hour = 5'd0;
                            else
                                next_hour = hour + 5'd1;
                        end

                        else
                            next_hour = hour;

                        if((counter + 12'd1) % 60 == 0)begin
                            if(minute == 6'd59)
                                next_minute = 6'd0;
                            else
                                next_minute = minute + 6'd1;
                        end

                        else
                            next_minute = minute;

                        if(counter == 12'd3599)
                            next_counter = 12'd0;
                        else    
                            next_counter = counter + 12'd1;
                    end

                    else begin
                        next_hour = hour;
                        next_minute = minute;
                        next_counter = counter;
                    end
                end
                
            end

            set:begin
                if(!setting)begin
                    next_local_state = set;
                    if(change_left)begin
                        if(hour == 5'd23)
                            next_hour = 5'd0;
                        else
                            next_hour = hour + 5'd1;
                    end

                    else begin
                        next_hour = hour;
                    end

                    if(change_right)begin
                        if(minute == 6'd59)
                            next_minute = 6'd0;
                        else
                            next_minute = minute + 6'd1;
                    end

                    else begin
                        next_minute = minute;
                    end
                    
                end

                else begin
                    next_local_state = counting;
                    next_hour = hour;
                    next_minute = minute;
                end
                next_counter = 12'd0;
            end

            default:begin
                next_local_state = local_state;
                next_hour = hour;
                next_minute = minute;
                next_counter = counter;
            end
        endcase
    end

    else begin
        next_local_state = counting;
        if(clk_1hz)begin
            if((counter + 12'd1) % 3600 == 0)begin

                if(hour == 5'd23)
                    next_hour = 5'd0;
                else
                    next_hour = hour + 5'd1;
            end

            else
                next_hour = hour;

            if((counter + 12'd1) % 60 == 0)begin
                if(minute == 6'd59)
                    next_minute = 6'd0;
                else
                    next_minute = minute + 6'd1;
            end

            else
                next_minute = minute;

            if(counter == 12'd3599)
                next_counter = 12'd0;
            else    
                next_counter = counter + 12'd1;
        end

        else begin
            next_hour = hour;
            next_minute = minute;
            next_counter = counter;
        end
    end
end

//seven segment display
//hour
always @(*)begin
    //digit0
    if(hour / 10 == 5'd0)
        hour_digit0 = 4'd0;
    else if(hour / 10 == 5'd1)
        hour_digit0 = 4'd1;
    else if(hour / 10 == 5'd2)
        hour_digit0 = 4'd2;
    else
        hour_digit0 = 4'd0;
    //digit1
    case(hour % 10)
        5'd0:hour_digit1 = 4'd0;
        5'd1:hour_digit1 = 4'd1;
        5'd2:hour_digit1 = 4'd2;
        5'd3:hour_digit1 = 4'd3;
        5'd4:hour_digit1 = 4'd4;
        5'd5:hour_digit1 = 4'd5;
        5'd6:hour_digit1 = 4'd6;
        5'd7:hour_digit1 = 4'd7;
        5'd8:hour_digit1 = 4'd8;
        5'd9:hour_digit1 = 4'd9;
        default:hour_digit1 = 4'd0;
    endcase
end
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

digit_seven_segment dss1(hour_digit0, a);
digit_seven_segment dss2(hour_digit1, b);
digit_seven_segment dss3(minute_digit0, c);
digit_seven_segment dss4(minute_digit1, d);
endmodule