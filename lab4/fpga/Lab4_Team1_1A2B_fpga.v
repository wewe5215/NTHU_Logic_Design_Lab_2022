`timescale 1ns/1ps

module FPGA_1A2B (clk, reset, start, enter, input_num, out0, out1, out2, out3, AN, seven_segment);
input clk, reset;
input start, enter;
input [4-1:0] input_num;
output [4-1:0] out0, out1, out2, out3;
output [4-1:0] AN;
output [7-1:0] seven_segment;
wire debounced_reset, debounced_start, debounced_enter;
wire one_pulsed_reset, one_pulsed_start, one_pulsed_enter;
wire clk_display;
parameter init = 4'b0000;
parameter gen_ans0 = 4'b0001;
parameter gen_ans1 = 4'b0010;
parameter gen_ans2 = 4'b0011;
parameter gen_ans3 = 4'b0100;
parameter guess_ans3 = 4'b0101;
parameter guess_ans2 = 4'b0110;
parameter guess_ans1 = 4'b0111;
parameter guess_ans0 = 4'b1000;
parameter show_correctness = 4'b1001;

reg [4-1:0] state, next_state;
reg [4-1:0] show_digit0, show_digit1, show_digit2, show_digit3;
wire [3-1:0] num_A, num_B;
reg [4-1:0] gen_digit0, gen_digit1, gen_digit2, gen_digit3;
reg [4-1:0] next_gen_digit0, next_gen_digit1, next_gen_digit2, next_gen_digit3;
reg [4-1:0] put_digit0, put_digit1, put_digit2, put_digit3;
reg [4-1:0] next_put_digit0, next_put_digit1, next_put_digit2, next_put_digit3;
wire [7:0] random_number0, random_number1, random_number2, random_number3;
wire [7-1:0] seven_segment_digit0, seven_segment_digit1, seven_segment_digit2, seven_segment_digit3;
debounce d0(reset, clk, debounced_reset);
debounce d1(start, clk, debounced_start);
debounce d2(enter, clk, debounced_enter);
one_pulse o0(debounced_reset, clk, one_pulsed_reset);
one_pulse o1(debounced_start, clk, one_pulsed_start);
one_pulse o2(debounced_enter, clk, one_pulsed_enter);
clk_for_display clkd(clk, clk_display);
assign out0 = gen_digit0;
assign out1 = gen_digit1;
assign out2 = gen_digit2;
assign out3 = gen_digit3;

Many_To_One_LFSR1 lfsr1(clk, !one_pulsed_reset, random_number0, random_number1);
Many_To_One_LFSR2 lfsr2(clk, !one_pulsed_reset, random_number2, random_number3);
show_AB show(gen_digit0, gen_digit1, gen_digit2, gen_digit3, put_digit0, put_digit1, put_digit2, put_digit3, num_A, num_B);
digit_seven_segment d10(show_digit0, seven_segment_digit0);
digit_seven_segment d11(show_digit1, seven_segment_digit1);
digit_seven_segment d12(show_digit2, seven_segment_digit2);
digit_seven_segment d13(show_digit3, seven_segment_digit3);
seven_show show1(clk, !one_pulsed_reset, seven_segment_digit0, seven_segment_digit1, seven_segment_digit2, seven_segment_digit3, AN, seven_segment, state);
//show_seven_segment show1(clk, one_pulsed_reset, clk_display, state, seven_segment_digit0, seven_segment_digit1, seven_segment_digit2, seven_segment_digit3, AN, seven_segment);
always@(posedge clk)begin
    if(one_pulsed_reset)begin
        state <= init;

        gen_digit0 <= 4'b0000;
        gen_digit1 <= 4'b0000;
        gen_digit2 <= 4'b0000;
        gen_digit3 <= 4'b0000;

        put_digit0 <= 4'b0000;
        put_digit1 <= 4'b0000;
        put_digit2 <= 4'b0000;
        put_digit3 <= 4'b0000;
        
    end

    else begin
        state <= next_state;

        gen_digit0 <= next_gen_digit0;
        gen_digit1 <= next_gen_digit1;
        gen_digit2 <= next_gen_digit2;
        gen_digit3 <= next_gen_digit3;

        put_digit0 <= next_put_digit0;
        put_digit1 <= next_put_digit1;
        put_digit2 <= next_put_digit2;
        put_digit3 <= next_put_digit3;

    end

end

always@(*)begin
    
        if(state == init)begin
            if(one_pulsed_start)begin
                next_state = gen_ans0;
                show_digit0 = put_digit0;
                show_digit1 = put_digit1;
                show_digit2 = put_digit2;
                show_digit3 = put_digit3;
            end

            else begin
                next_state = state;
                //1A2b
                //digit0 --> b --> 4'd11 = 4'b1011
                show_digit0 = 4'b1011;
                //digit1 --> 2
                show_digit1 = 4'b0010;
                //digit2 --> A
                show_digit2 = 4'b1010;
                //digit3 --> 1
                show_digit3 = 4'b0001;

            end
            next_gen_digit0 = 4'b0;
            next_gen_digit1 = 4'b0;
            next_gen_digit2 = 4'b0;
            next_gen_digit3 = 4'b0;

            next_put_digit0 = put_digit0;
            next_put_digit1 = put_digit1;
            next_put_digit2 = put_digit2;
            next_put_digit3 = put_digit3;
        end
        else if(state == gen_ans0 || state == gen_ans1)begin
            if(random_number1[3:0] != next_gen_digit0 && random_number1[3:0] != next_gen_digit1)begin
                next_state = state + 4'b0001;
                if(state == gen_ans0)
                    next_gen_digit0 = random_number0[3:0];
                else 
                    next_gen_digit1 = random_number1[3:0];
                next_gen_digit2 = gen_digit2;
                next_gen_digit3 = gen_digit3;
                
            end

            else begin
                next_state = state;
                next_gen_digit0 = gen_digit0;
                next_gen_digit1 = gen_digit1;
                next_gen_digit2 = gen_digit2;
                next_gen_digit3 = gen_digit3;
            end

            show_digit0 = put_digit0;
            show_digit1 = put_digit1;
            show_digit2 = put_digit2;
            show_digit3 = put_digit3;
            next_put_digit0 = put_digit0;
            next_put_digit1 = put_digit1;
            next_put_digit2 = put_digit2;
            next_put_digit3 = put_digit3;
        end

        else if(state == gen_ans2 || state == gen_ans3)begin
            if(random_number2[3:0] != next_gen_digit0 && random_number2[3:0] != next_gen_digit1 && random_number3[3:0] != next_gen_digit0 && random_number3[3:0] != next_gen_digit1 && random_number3[3:0] != next_gen_digit2)begin
                next_state = state + 4'b0001;
                if(state == gen_ans2)
                    next_gen_digit2 = random_number2[3:0];
                else 
                    next_gen_digit3 = random_number3[3:0];
                next_gen_digit0 = gen_digit0;
                next_gen_digit1 = gen_digit1;
                
            end

            else begin
                next_state = state;
                next_gen_digit0 = gen_digit0;
                next_gen_digit1 = gen_digit1;
                next_gen_digit2 = gen_digit2;
                next_gen_digit3 = gen_digit3;
            end

            show_digit0 = put_digit0;
            show_digit1 = put_digit1;
            show_digit2 = put_digit2;
            show_digit3 = put_digit3;
            next_put_digit0 = put_digit0;
            next_put_digit1 = put_digit1;
            next_put_digit2 = put_digit2;
            next_put_digit3 = put_digit3;

        end

        else if(state == guess_ans3 || state == guess_ans2 || state == guess_ans1 || state == guess_ans0)begin
            if(one_pulsed_enter)begin
                
                if(state != guess_ans0)begin
                    next_state = state + 4'b0001;
                    //left shift
                    next_put_digit0 = put_digit0;
                    next_put_digit1 = input_num;
                    next_put_digit2 = put_digit1;
                    next_put_digit3 = put_digit2;
                end

                else begin
                    next_state = show_correctness;
                    next_put_digit0 = input_num;
                    next_put_digit1 = put_digit1;
                    next_put_digit2 = put_digit2;
                    next_put_digit3 = put_digit3;
                end
                
            end

            else begin
                next_state = state;
                next_put_digit0 = put_digit0;
                next_put_digit1 = put_digit1;
                next_put_digit2 = put_digit2;
                next_put_digit3 = put_digit3;
            end
            show_digit0 = input_num;
            show_digit1 = put_digit1;
            show_digit2 = put_digit2;
            show_digit3 = put_digit3;

            next_gen_digit0 = gen_digit0;
            next_gen_digit1 = gen_digit1;
            next_gen_digit2 = gen_digit2;
            next_gen_digit3 = gen_digit3;
        end

        else begin
            if(one_pulsed_enter)begin
                if(num_A == 3'b100)begin//4A
                    next_state = init;
                    next_gen_digit0 = 4'd0;
                    next_gen_digit1 = 4'd0;
                    next_gen_digit2 = 4'd0;
                    next_gen_digit3 = 4'd0;

                    
                end

                else begin
                    next_state = guess_ans3;
                    next_gen_digit0 = gen_digit0;
                    next_gen_digit1 = gen_digit1;
                    next_gen_digit2 = gen_digit2;
                    next_gen_digit3 = gen_digit3;
                end
                next_put_digit0 = 4'd0;
                next_put_digit1 = 4'd0;
                next_put_digit2 = 4'd0;
                next_put_digit3 = 4'd0;
            end

            else begin
                next_state = state;
                next_gen_digit0 = gen_digit0;
                next_gen_digit1 = gen_digit1;
                next_gen_digit2 = gen_digit2;
                next_gen_digit3 = gen_digit3;

                next_put_digit0 = put_digit0;
                next_put_digit1 = put_digit1;
                next_put_digit2 = put_digit2;
                next_put_digit3 = put_digit3;

            end
            

            //digit0 --> b --> 4'd11 = 4'b1011
            show_digit0 = 4'b1011;
            //digit1 --> num_B
            show_digit1 = {1'b0, num_B};
            //digit2 --> A
            show_digit2 = 4'b1010;
            //digit3 --> 1
            show_digit3 = {1'b0, num_A};

            

        end
end

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



module show_AB(gen_digit0, gen_digit1, gen_digit2, gen_digit3, put_digit0, put_digit1, put_digit2, put_digit3, num_A, num_B);
input [4-1:0] gen_digit0, gen_digit1, gen_digit2, gen_digit3;
input [4-1:0] put_digit0, put_digit1, put_digit2, put_digit3;
output [3-1:0] num_A, num_B;


assign  num_A = (gen_digit0 == put_digit0 ? 3'b001 : 3'b000) + (gen_digit1 == put_digit1 ? 3'b001 : 3'b000) + (gen_digit2 == put_digit2 ? 3'b001 : 3'b000) + (gen_digit3 == put_digit3 ? 3'b001 : 3'b000);

assign  num_B = (gen_digit0 == put_digit1 || gen_digit0 == put_digit2 || gen_digit0 == put_digit3 ? 3'b001 : 3'b000) + 
            (gen_digit1 == put_digit0 || gen_digit1 == put_digit2 || gen_digit1 == put_digit3 ? 3'b001 : 3'b000) +
            (gen_digit2 == put_digit1 || gen_digit2 == put_digit0 || gen_digit2 == put_digit3 ? 3'b001 : 3'b000) +
            (gen_digit3 == put_digit1 || gen_digit3 == put_digit2 || gen_digit3 == put_digit0 ? 3'b001 : 3'b000);






endmodule

module Many_To_One_LFSR1(clk, rst_n, out1, out2);
input clk;
input rst_n;
reg [7:0] out;
output reg [7:0] out1, out2;
wire [7:0] dff;
assign dff = out;
always @(posedge clk)begin
    if(!rst_n)begin
        out <= 8'b10111101;
    end

    else begin
        out[0] <= (dff[7] ^ dff[3]) ^ (dff[1] ^ dff[2]);
        out[7:1] <= dff[6:0];
    end

end

always@(*)begin
    out1 = out[7:4] % 10;
    out2 = out[3:0] % 10;

end
endmodule

module Many_To_One_LFSR2(clk, rst_n, out1, out2);
input clk;
input rst_n;
reg [7:0] out;
output reg [7:0] out1, out2;
wire [7:0] dff;
assign dff = out;
always @(posedge clk)begin
    if(!rst_n)begin
        out <= 8'b01100111;
    end

    else begin
        out[0] <= (dff[7] ^ dff[3]) ^ (dff[1] ^ dff[2]);
        out[7:1] <= dff[6:0];
    end

end


always@(*)begin
    out1 = out[7:4] % 10;
    out2 = out[3:0] % 10;

end
endmodule

module debounce(pb, clk, pb_debounce);
input pb;
input clk;
output pb_debounce;
reg [4-1:0] dff;

always @(posedge clk)begin
    dff[3:1] <= dff[2:0];
    dff[0] <= pb;
end

assign pb_debounce = (dff == 4'b1111)? 1'b1 : 1'b0;
endmodule

module one_pulse(pb_debounced, clk, pb_one_pulse);
input pb_debounced;
input clk;
output pb_one_pulse;
reg pb_one_pulse;
reg pb_debounced_delay;

always @(posedge clk)begin
    pb_debounced_delay <= pb_debounced;
    pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
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



module seven_show(clk, rst_n, a, b, c, d, an, led, state);
	input clk, rst_n;
	input [7-1:0] a, b, c, d;
	input [4:0] state;
	output [3:0] an;
	output [7-1:0] led;
	reg [3:0] an;
	reg [3:0] next_an;
	reg [7-1:0] led;
	reg [7-1:0] next_led;
    wire clk_display;

	parameter size = 8;
	
	reg [8-1:0] icounter;
	reg [8-1:0] next_icounter;
    clk_for_display clkd(clk, clk_display);
	always @(posedge clk)begin
		if(rst_n == 1'b0)begin
			an <= 4'b0;
			icounter <= 8'b00000000;
		end else begin
			icounter <= next_icounter;
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
			if(next_an == 4'b1110)begin
			    next_icounter = icounter + 8'd1;
				if(icounter >= 8'b10000000 || state == 4'd9 || state == 4'd0)
					next_led = a;
				else
					next_led = 7'b1111111;
			end 
            else if(next_an == 4'b1101) begin
                next_icounter = icounter;
				next_led = b;
			end 
            else if(next_an == 4'b1011) begin
                next_icounter = icounter;
				next_led = c;
			end 
            else begin 
                next_icounter = icounter;
				next_led = d;
			end
			
		end

        else begin
            next_an = an;
		    next_led = led;
		    next_icounter = icounter;

        end
	end
endmodule