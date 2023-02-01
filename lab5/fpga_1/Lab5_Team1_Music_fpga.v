module TOP (
	input clk,
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	output pmod_1,
	output pmod_2,
	output pmod_4
);
//parameter BEAT_FREQ = 32'd8;	one beat=0.125sec=8 Hz
parameter DUTY_BEST = 10'd512;	//duty cycle=50%

parameter [8:0] W_CODE = 9'b0_0001_1101;
parameter [8:0] S_CODE = 9'b0_0001_1011;
parameter [8:0] R_CODE = 9'b0_0010_1101;
parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0101_1010; //5A
parameter [8:0] RIGHT_SHIFT_CODES = 9'b1_0101_1010;

wire reset;
wire [31:0] freq;
wire [7:0] ibeatNum;
wire [7:0] ibeatNum_temp;
wire beatFreq;

wire [511:0] key_down;
wire enter_down;

wire [8:0] last_change;
wire been_ready;
wire direction_temp;
wire BEAT_FREQ_temp;
assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on

reg [32-1:0]BEAT_FREQ;
reg direction;
assign direction_temp = direction;
assign BEAT_FREQ_temp = BEAT_FREQ;

assign enter_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
assign reset = enter_down;

always @(posedge clk) begin //manipulate beat and speed
    if(reset)begin
        BEAT_FREQ <= 32'd1;
		direction <= 1'b0;
    end

    else begin
		if(been_ready && key_down[last_change] == 1'b1)begin
		  case(last_change)
		      W_CODE:
		          direction <= 1'b0;
		      S_CODE:
		          direction <= 1'b1;
		      R_CODE:
		          if(BEAT_FREQ == 32'd1)
		              BEAT_FREQ <= 32'd2;
		          else
		              BEAT_FREQ <= 32'd1;
		    
		       default:begin
		          BEAT_FREQ <= BEAT_FREQ_temp;
		          direction <= direction_temp;
		         
		       end       
		    endcase
		end
		          
		else begin
		          BEAT_FREQ <= BEAT_FREQ_temp;
		          direction <= direction_temp;
		          
		end
    end
end

KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
);	
// page. 38
//Step 1 : Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .reset(reset),
					 .freq(BEAT_FREQ),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
//Step 2 : manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .reset(reset),
						   .direction(direction),
						   .ibeat(ibeatNum)
);						   
						   	
//Step 3 : Generate variant freq. of tones
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);

// Step 4 : Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .reset(reset), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);
endmodule

//-----PWM.v
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule

//-----KeyboardDecorder.v
module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end
    endmodule
	module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule

//-----PlayerCtrl.v
module PlayerCtrl (
	input clk,
	input reset,
	input direction,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 28;

always @(posedge clk, posedge reset) begin
	if (reset)
		ibeat <= 7'b0;
	else begin
        if(direction == 1'b0)begin
            if(ibeat < BEATLEAGTH)
                ibeat <= ibeat + 1;
            else
                ibeat <= BEATLEAGTH;
        end

        else begin
            if(ibeat > 7'b0)
                ibeat <= ibeat - 1;
            else
               ibeat <= 7'b0;
       end
    end
end

endmodule

//-----Music.v
module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

//defination
`define NM1  32'd523 //C5_freq
`define NM2  32'd587 //D_freq
`define NM3  32'd659 //E_freq
`define NM4  32'd698 //F_freq
`define NM5  32'd784 //G_freq
`define NM6  32'd880 //A_freq
`define NM7  32'd988 //B_freq

`define NM8  32'd2093 //C7_freq
`define NM9  32'd2349 //D_freq
`define NM10 32'd2637 //E_freq
`define NM11 32'd2794 //F_freq
`define NM12 32'd3136 //G_freq
`define NM13 32'd3520 //A_freq
`define NM14 32'd3951 //B_freq

`define NM15 32'd4186 //C8_freq

`define NM0 32'd20000 //slience (over freq.)

always @(*) begin
	case (ibeatNum)	
		8'd0 : tone = `NM1 >> 1; //C4_freq
		8'd1 : tone = `NM2 >> 1;
		8'd2 : tone = `NM3 >> 1;
		8'd3 : tone = `NM4 >> 1;
		8'd4 : tone = `NM5 >> 1;	
		8'd5 : tone = `NM6 >> 1;
		8'd6 : tone = `NM7 >> 1;

		8'd7 : tone = `NM1; //C5_freq
		8'd8 : tone = `NM2;	
		8'd9 : tone = `NM3;
		8'd10 : tone = `NM4;
		8'd11 : tone = `NM5;
		8'd12 : tone = `NM6;	
		8'd13 : tone = `NM7;

		8'd14 : tone = `NM8 >> 1; //C6_freq
		8'd15 : tone = `NM9 >> 1;
		8'd16 : tone = `NM10 >> 1;
		8'd17 : tone = `NM11 >> 1;
		8'd18 : tone = `NM12 >> 1;
		8'd19 : tone = `NM13 >> 1;
		8'd20 : tone = `NM14 >> 1;

		8'd21 : tone = `NM8; //C7_freq
		8'd22 : tone = `NM9;
		8'd23 : tone = `NM10;
		8'd24 : tone = `NM11;
		8'd25 : tone = `NM12;
		8'd26 : tone = `NM13;
		8'd27 : tone = `NM14;
        
		8'd28 : tone = `NM15;
		
		default : tone = `NM1 >> 1;
	endcase
end

endmodule