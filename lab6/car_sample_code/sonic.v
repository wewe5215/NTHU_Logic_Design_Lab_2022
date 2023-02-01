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
