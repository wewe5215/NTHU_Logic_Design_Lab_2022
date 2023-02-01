`timescale 1ns/1ps
module tracker_sensor(clk, reset, mode_before_backward, turn_back, tracker_state);
    input clk;
    input reset;
    input [3-1:0] mode_before_backward;
    input turn_back;
    output reg [3-1:0] tracker_state;
    reg [2-1:0] state, next_state;
    reg [4-1:0] counter, next_counter;
    wire [7:0] out;
    wire clk_1hz;
    reg done, next_done;
    parameter STOP = 3'b000;
    parameter LEFT = 3'b001;
    parameter CENTER = 3'b010;
    parameter RIGHT = 3'b011;
    parameter BACKWARD = 3'b100;
    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    //modified by 109062320
    clk_for_1hz cf1(clk, clk_1hz);
    Many_To_One_LFSR lsfrrr(clk, !reset, out);
    always @(posedge clk)begin
        if(reset)begin
            state <= out[1:0];
            done <= 1'b1;
            counter <= 4'd0;
        end


        else begin
            state <= next_state;
            done <= next_done;
            counter <= next_counter;
        end

    end
    //direction 
    always @(*)begin
        if(turn_back)
            next_done = 1'b0;
        else begin
            //if we need change direction because of turn back
            if(!done)begin
                if(out[1:0] != mode_before_backward)begin
                    next_state = out[1:0];
                    next_done = 1'b1;
                end

                else begin
                    next_state = state;
                    next_done = 1'b0;
                end
            end

            else begin
                //change direction after a period of time
                if(counter == 4'd9)begin
                    if(out[1:0] != state)begin
                        next_state = out[1:0];
                        next_counter = 4'd0;
                    end

                    else begin
                        next_state = state;
                        next_counter = counter;
                    end

                end

                else begin
                    next_state = state;
                    if(clk_1hz)begin
                        next_counter = counter + 4'd1;
                    end

                    else begin
                        next_counter = counter;
                    end

                end

                next_done = done;
            end
        end

    end
    //policy 
    always @(*)begin
        if(state == 2'b00)begin
            tracker_state = LEFT;
        end

        else if(state == 2'b01)begin
            tracker_state = RIGHT;

        end

        else begin
            tracker_state = CENTER;
        end 

    end
endmodule


module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;
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

endmodule