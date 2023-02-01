`timescale 1ns/1ps
module Top(
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk,
    input wire insert5,
    input wire insert10,
    input wire insert50,
    input wire cancel,
    output wire [6:0] display,
    output wire [3:0] AN,
    output wire [3:0] LED);
    //for keyboard
    //A --> 1C
    parameter [8:0] A = 9'b0_0001_1100;
    //S --> 1B
    parameter [8:0] S = 9'b0_0001_1011;
    //D --> 23
    parameter [8:0] D = 9'b0_0010_0011;
    //F --> 2B
    parameter [8:0] F = 9'b0_0010_1011;
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;

    KeyboardDecoder key_de(
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );
    //for button
    wire de_rst, de_insert5, de_insert10, de_insert50, de_cancel;
    wire on_rst, on_insert5, on_insert10, on_insert50, on_cancel;

    debounce d0(rst, clk, de_rst);
    one_pulse o0(de_rst, clk, on_rst);

    debounce d1(insert5, clk, de_insert5);
    one_pulse o1(de_insert5, clk, on_insert5);

    debounce d2(insert10, clk, de_insert10);
    one_pulse o2(de_insert10, clk, on_insert10);

    debounce d3(insert50, clk, de_insert50);
    one_pulse o3(de_insert50, clk, on_insert50);

    debounce d4(cancel, clk, de_cancel);
    one_pulse o4(de_cancel, clk, on_cancel);

    //for vending machine
    wire clk1hz;
    wire coffee, coke, oolong, water;
    wire [12-1:0] money;
    wire [4-1:0] available_drink;
    assign coffee = key_down[A] && been_ready;
    assign coke = key_down[S] && been_ready;
    assign oolong = key_down[D] && been_ready;
    assign water = key_down[F] && been_ready;

    clk_for_1hz c0(clk, clk1hz);
    vending_machine vm(
        clk,
        clk1hz,
        on_rst,
        on_insert5,
        on_insert10,
        on_insert50,
        on_cancel,
        coffee,
        coke,
        oolong,
        water, 
        money,
        available_drink
    );
    //for LED
    assign LED = available_drink;
    //for seven segment
    wire clk_display;
    clk_for_display c1(clk, clk_display);
    seven_segment ss(
        clk, 
        clk_display,
        on_rst,
        money,
        display,
        AN);

endmodule

module seven_segment(
    input clk, 
    input clk_display,
    input reset,
    input [12-1:0] money,
    output reg [6:0] seven_segment,
    output reg [3:0] AN 
);
reg [4-1:0] display, next_display;
reg [3:0] next_AN;
wire [4-1:0] digit0, digit1, digit2, digit3;

assign digit0 = money % 10;
assign digit1 = (money < 12'd10) ? 4'd10 : 
                (money >= 12'd100) ? 4'd0 : money / 10;
assign digit2 = (money >= 12'd100) ? 4'd1 : 4'd10;
assign digit3 = 4'd10;
always @(posedge clk)begin
    if(reset)begin
        AN <= 4'b0111;
        display <= 4'b1111;
    end

    else begin
        AN <= next_AN;
        display <= next_display;
    end
end
always @(*)begin
    if(clk_display)begin
        case(AN)
            4'b0111:begin
                next_AN = 4'b1011;
                next_display = digit2;
            end
            4'b1011:begin
                next_AN = 4'b1101;
                next_display = digit1;
            end
            4'b1101:begin
                next_AN = 4'b1110;
                next_display = digit0;
            end
            4'b1110:begin
                next_AN = 4'b0111;
                next_display = digit3;
            end
            default:begin
                next_AN = 4'b1011;
                next_display = digit2;
            end

        endcase

    end

    else begin
        next_AN = AN;
        next_display = display;

    end

end

//seven segment
always @(*)begin
    case(display)
        4'd0: seven_segment = 7'b0000001;
        4'd1: seven_segment = 7'b1001111;
        4'd2: seven_segment = 7'b0010010;
        4'd3: seven_segment = 7'b0000110;
        4'd4: seven_segment = 7'b1001100;
        4'd5: seven_segment = 7'b0100100;
        4'd6: seven_segment = 7'b0100000;
        4'd7: seven_segment = 7'b0001111;
        4'd8: seven_segment = 7'b0000000;
        4'd9: seven_segment = 7'b0001100;
        default: seven_segment = 7'b1111111;


    endcase

end

endmodule

module vending_machine(
    input clk,
    input clk_1hz,
    input reset,
    input insert5,
    input insert10,
    input insert50,
    input cancel,
    input coffee,
    input coke,
    input oolong,
    input water,
    output reg[12-1:0] money,
    output reg[4-1:0] available_drink
);
parameter return = 1'b0;
parameter insert = 1'b1;
reg next_state, state;
reg [12-1:0] next_money;
reg [4-1:0] next_available_drink;
wire insert_money;
assign insert_money = insert5 || insert10 || insert50;
always @(posedge clk)begin
    if(reset)begin
        state <= return;
        money <= 12'd0;
        available_drink <= 4'b0000;
    end

    else begin
        state <= next_state;
        money <= next_money;
        available_drink <= next_available_drink;
    end

end
//state transition
always @(*)begin
    if(state == return)begin
        if(insert_money)
            next_state = insert;
        else 
            next_state = return;
    end

    else begin
        if(cancel)
            next_state = return;
        else begin
            if(money >= 12'd80 && coffee)
                next_state = return;
            else if(money >= 12'd30 && coke)
                next_state = return;
            else if(money >= 12'd25 && oolong)
                next_state = return;
            else if(money >= 12'd20 && water)
                next_state = return;
            else 
                next_state = insert;

        end
    end


end

//change money
always @(*)begin
    if(state == return)begin
        if(insert_money)begin
            if(insert5)
                next_money = money + 12'd5;
            else if(insert10)
                next_money = money + 12'd10;
            else
                next_money = money + 12'd50;


        end

        else begin
            if(clk_1hz)begin
                if(money > 12'd5)begin
                    next_money = money - 12'd5;
                end

                else begin
                    next_money = 12'd0;
                end
            end
            
            else begin
                next_money = money;
            end

        end
        

    end

    else begin
        if(insert_money)begin
            if(insert5)begin
                if(money + 12'd5 > 12'd100)
                    next_money = 12'd100;
                else 
                    next_money = money + 12'd5;
            end

            else if(insert10)begin
                if(money + 12'd10 > 12'd100)
                    next_money = 12'd100;
                else 
                    next_money = money + 12'd10;
            end

            else if(insert50)begin
                if(money + 12'd50 > 12'd100)
                    next_money = 12'd100;
                else 
                    next_money = money + 12'd50;
            end

            else
                next_money = money;

        end

        else begin
            if(money >= 12'd80 && coffee)
                next_money = money - 12'd80;
            else if(money >= 12'd30 && coke)
                next_money = money - 12'd30;
            else if(money >= 12'd25 && oolong)
                next_money = money - 12'd25;
            else if(money >= 12'd20 && water)
                next_money = money - 12'd20;
            else 
                next_money = money;

        end

    end

end
//change available drink
//coffee, coke, oolong, water
always @(*)begin
    if(money >= 12'd80)
        next_available_drink = 4'b1111;
    else if(money >= 12'd30)
        next_available_drink = 4'b0111;
    else if(money >= 12'd25)
        next_available_drink = 4'b0011;
    else if(money >= 12'd20)
        next_available_drink = 4'b0001;
    else 
        next_available_drink = 4'b0000;

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
    
    reg [9:0] key, next_key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state, next_state;
    reg been_ready, been_extend, been_break;
    reg next_been_ready, next_been_extend, next_been_break;
    
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
    
    one_pulse op (
        .pb_one_pulse(pulse_been_ready),
        .pb_debounced(been_ready),
        .clk(clk)
    );
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            been_ready  <= 1'b0;
            been_extend <= 1'b0;
            been_break  <= 1'b0;
            key <= 10'b0_0_0000_0000;
        end else begin
            state <= next_state;
            been_ready  <= next_been_ready;
            been_extend <= next_been_extend;
            been_break  <= next_been_break;
            key <= next_key;
        end
    end
    
    always @ (*) begin
        case (state)
            INIT:            next_state = (key_in == IS_INIT) ? WAIT_FOR_SIGNAL : INIT;
            WAIT_FOR_SIGNAL: next_state = (valid == 1'b0) ? WAIT_FOR_SIGNAL : GET_SIGNAL_DOWN;
            GET_SIGNAL_DOWN: next_state = WAIT_RELEASE;
            WAIT_RELEASE:    next_state = (valid == 1'b1) ? WAIT_RELEASE : WAIT_FOR_SIGNAL;
            default:         next_state = INIT;
        endcase
    end
    always @ (*) begin
        next_been_ready = been_ready;
        case (state)
            INIT:            next_been_ready = (key_in == IS_INIT) ? 1'b0 : next_been_ready;
            WAIT_FOR_SIGNAL: next_been_ready = (valid == 1'b0) ? 1'b0 : next_been_ready;
            GET_SIGNAL_DOWN: next_been_ready = 1'b1;
            WAIT_RELEASE:    next_been_ready = next_been_ready;
            default:         next_been_ready = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_extend = (is_extend) ? 1'b1 : been_extend;
        case (state)
            INIT:            next_been_extend = (key_in == IS_INIT) ? 1'b0 : next_been_extend;
            WAIT_FOR_SIGNAL: next_been_extend = next_been_extend;
            GET_SIGNAL_DOWN: next_been_extend = next_been_extend;
            WAIT_RELEASE:    next_been_extend = (valid == 1'b1) ? next_been_extend : 1'b0;
            default:         next_been_extend = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_break = (is_break) ? 1'b1 : been_break;
        case (state)
            INIT:            next_been_break = (key_in == IS_INIT) ? 1'b0 : next_been_break;
            WAIT_FOR_SIGNAL: next_been_break = next_been_break;
            GET_SIGNAL_DOWN: next_been_break = next_been_break;
            WAIT_RELEASE:    next_been_break = (valid == 1'b1) ? next_been_break : 1'b0;
            default:         next_been_break = 1'b0;
        endcase
    end
    always @ (*) begin
        next_key = key;
        case (state)
            INIT:            next_key = (key_in == IS_INIT) ? 10'b0_0_0000_0000 : next_key;
            WAIT_FOR_SIGNAL: next_key = next_key;
            GET_SIGNAL_DOWN: next_key = {been_extend, been_break, key_in};
            WAIT_RELEASE:    next_key = next_key;
            default:         next_key = 10'b0_0_0000_0000;
        endcase
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