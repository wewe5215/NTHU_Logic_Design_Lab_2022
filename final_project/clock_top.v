`timescale 1ns/1ps

module clock_Top (
    input clk,
    input reset,//up_btn
    input change_left,//left_btn
    input change_right,//right_btn
    input change_mode,//mid_btn
    input setting,//down_btn
    input switch0,
    input switch1,
    output [4-1:0] AN,
    output [7-1:0] seven_seg,
    output reg[2-1:0] state,
    output ring
);
wire rst_de, cl_de, cr_de, cm_de, set_de;
wire rst_on, cl_on, cr_on, cm_on, set_on;
wire clk_display, clk_1hz;
wire stop_ring, stop_resume_count;
wire alarm_ring, cd_ring;
wire setting_mode;
reg [2-1:0] next_state;

reg  last_switch0, last_switch1;

wire [7-1:0] a0, a1, a2, a3;
wire [7-1:0] b0, b1, b2, b3;
wire [7-1:0] c0, c1, c2, c3;
wire [7-1:0] d0, d1, d2, d3;
reg [7-1:0] a, b, c, d;
wire [4:0] Timer_hour;
wire [5:0] Timer_minute;
wire Timer_setting, Alarm_setting, Countdown_setting;
parameter clock_mode = 2'b00;
parameter alarm_mode = 2'b01;
parameter accumulate_mode = 2'b10;
parameter countdown_mode = 2'b11;

debounce d10(rst_de, reset, clk);
debounce d11(cl_de, change_left, clk);
debounce d12(cr_de, change_right, clk);
debounce d13(cm_de, change_mode, clk);
debounce d14(set_de, setting, clk);

onepulse o0(rst_de, clk, rst_on);
onepulse o1(cl_de, clk, cl_on);
onepulse o2(cr_de, clk, cr_on);
onepulse o3(cm_de, clk, cm_on);
onepulse o4(set_de, clk, set_on);

clk_for_display c10(clk, clk_display);
clk_for_1hz c11(clk, clk_1hz);
//audio_TOP aaat(clk, rst_on, ring, pmod_1, pmod_2, pmod_4);
always @(posedge clk)begin
    if(rst_on)begin
        state <= clock_mode;
        
    end

    else begin
        state <= next_state;
        
    end
    last_switch0 <= switch0;
    last_switch1 <= switch1;
end


always @(*)begin
    if(cm_on && !setting_mode)begin
        case(state)
            clock_mode:
                next_state = alarm_mode;
            alarm_mode:
                next_state = accumulate_mode;
            accumulate_mode:
                next_state = countdown_mode;
            countdown_mode:
                next_state = clock_mode;
            default:
                next_state = alarm_mode;
        endcase
    end

    else begin
        next_state = state;
    end

end





assign stop_ring = (last_switch0 != switch0) ? 1'b1 : 1'b0;
assign stop_resume_count = (last_switch1 != switch1) ? 1'b1 : 1'b0;
assign setting_mode = (Timer_setting || Alarm_setting || Countdown_setting) ? 1'b1 : 1'b0;
assign ring = (alarm_ring || cd_ring) ? 1'b1 : 1'b0;
always @(*)begin
    case(state)
        clock_mode:begin
            a = a0;
            b = b0;
            c = c0;
            d = d0;
        end
        alarm_mode:begin
            a = a1;
            b = b1;
            c = c1;
            d = d1;
        end
        accumulate_mode:begin
            a = a2;
            b = b2;
            c = c2;
            d = d2;
        end
        countdown_mode:begin
            a = a3;
            b = b3;
            c = c3;
            d = d3;
        end
        default:begin
            a = a0;
            b = b0;
            c = c0;
            d = d0;
        end

    endcase

end
Time_display td(clk, rst_on, state, cl_on, cr_on, set_on, a0, b0, c0, d0, Timer_hour, Timer_minute, Timer_setting);
Alarm_display ad(clk, rst_on, state, cl_on, cr_on, set_on, Timer_hour, Timer_minute, stop_ring, a1, b1, c1, d1, alarm_ring, Alarm_setting);
Accumulate_Time att(clk, rst_on, state, cl_on, cr_on, set_on, stop_resume_count, a2, b2, c2, d2);
Countdown cd(clk, rst_on, state, cl_on, cr_on, set_on, stop_ring, stop_resume_count, a3, b3, c3, d3, cd_ring, Countdown_setting);
seven_show ss(clk, clk_display, rst_on, a, b, c, d, AN, seven_seg);
endmodule

module digit_seven_segment(digit, seven_segment);
input [4-1:0] digit;
output reg [7-1:0] seven_segment;

always@(*)begin
    case(digit)
    //abcdefg
        4'b0000: seven_segment = 7'b0000001;
        4'b0001: seven_segment = 7'b1001111;
        4'b0010: seven_segment = 7'b0010010;
        4'b0011: seven_segment = 7'b0000110;
        4'b0100: seven_segment = 7'b1001100;
        4'b0101: seven_segment = 7'b0100100;
        4'b0110: seven_segment = 7'b0100000;
        4'b0111: seven_segment = 7'b0001111;
        4'b1000: seven_segment = 7'b0000000;
        4'b1001: seven_segment = 7'b0001100;
        4'b1010: seven_segment = 7'b0001000;
        4'b1011: seven_segment = 7'b1100000;
        default: seven_segment = 7'b0000001;
    endcase
end

endmodule

module seven_show(clk, clk_display, rst, a, b, c, d, an, led);
	input clk, clk_display, rst;
	input [7-1:0] a, b, c, d;
	output [3:0] an;
	output [7-1:0] led;
	reg [3:0] an;
	reg [3:0] next_an;
	reg [7-1:0] led;
	reg [7-1:0] next_led;

	parameter size = 8;
	
	always @(posedge clk)begin
		if(rst)begin
			an <= 4'b0;
            led <= 7'b1111111;
		end else begin
			an <= next_an;
       		led <= next_led;
			
		end
	end

    always @(*)begin
        if(clk_display)begin
            next_an = (an == 4'b1110) ? 4'b1101:
                        (an == 4'b1101) ? 4'b1011:
                        (an == 4'b1011) ? 4'b0111:
                        (an == 4'b0111) ? 4'b1110:4'b1101;
        end

        else begin
            next_an = an;
        end
    end

    
	always @(*)begin
		if(clk_display)begin
			if(next_an == 4'b1110)begin
                    next_led = d;	
                end 
                else if(next_an == 4'b1101) begin
                    next_led = c;
                end 
                else if(next_an == 4'b1011) begin
                    next_led = b;
                end 
                else begin 
                    next_led = a;
                end
		end

        else begin
		    next_led = led;
        end
	end
endmodule

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

module clk_for_display(clk_in, clk_out);
input clk_in;
output clk_out;
reg [17-1:0] count;
parameter size = 17;
always@(posedge clk_in)begin
    count <= count + 1'b1;
end
assign clk_out = (count == {size{1'b1}}) ? 1'b1 : 1'b0;


endmodule

module clk_for_1hz(clk_in, clk_out);
input clk_in;
output clk_out;
reg [27-1:0] count;
parameter size = 27;
always@(posedge clk_in)begin
    count <= count + 1'b1;
end
assign clk_out = (count == {size{1'b1}}) ? 1'b1 : 1'b0;


endmodule