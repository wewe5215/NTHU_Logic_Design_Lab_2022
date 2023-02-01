`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output reg[2:0] hw_light;
output reg[2:0] lr_light;
reg [3-1:0] state, next_state;
reg [7-1:0] counter, next_counter;
parameter S0 = 3'b000;//g/r
parameter S1 = 3'b001;//y/r
parameter S2 = 3'b010;//r/r
parameter S3 = 3'b011;//r/g
parameter S4 = 3'b100;//r/y
parameter S5 = 3'b101;//r/r

always @(posedge clk) begin
    if(!rst_n)begin
        state <= S0;
        counter <= 7'b0000000;
    end

    else begin
        state <= next_state;
        counter <= next_counter;
    end
end
//green = 3'b100
//yellow = 3'b010
//red = 3'b001
always @(*)begin
    case (state)
        S0:begin//g/r
            hw_light = 3'b100;
            lr_light = 3'b001;
        end
        S1:begin//y/r
            hw_light = 3'b010;
            lr_light = 3'b001;
        end
        S2:begin//r/r
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
        S3:begin//r/g
            hw_light = 3'b001;
            lr_light = 3'b100;
        end
        S4:begin//r/y
            hw_light = 3'b001;
            lr_light = 3'b010;
        end
        S5:begin//r/r
            hw_light = 3'b001;
            lr_light = 3'b001;
        end 
        default:begin
            hw_light = 3'b100;
            lr_light = 3'b001;
        end 
    endcase

end

always @(*)begin
    case(state)
        S0:begin
            if(counter >= 7'd69 && lr_has_car)begin
                next_state = S1;
                next_counter = 7'd0;
            end

            else begin
                next_state = S0;
                next_counter = counter + 7'd1;
            end
        end
        S1:begin
            if(counter == 7'd24)begin
                next_state = S2;
                next_counter = 7'd0;
            end

            else begin
                next_state = S1;
                next_counter = counter + 7'd1;
            end
        end
        S2:begin
            if(counter >= 7'd69 && lr_has_car)begin
                next_state = S1;
                next_counter = 7'd0;
            end

            else begin
                next_state = S0;
                next_counter = counter + 7'd1;
            end
        end
        S3:begin
            if(counter == 7'd0)begin
                next_state = S4;
                next_counter = 7'd0;
            end

            else begin
                next_state = S3;
                next_counter = counter + 7'd1;
            end
        end
        S4:begin
            if(counter == 7'd69)begin
                next_state = S5;
                next_counter = 7'd0;
            end

            else begin
                next_state = S4;
                next_counter = counter + 7'd1;
            end
        end
        S5:begin
            if(counter == 7'd24)begin
                next_state = S1;
                next_counter = 7'd0;
            end

            else begin
                next_state = S5;
                next_counter = counter + 7'd1;
            end
        end

        default:begin
            if(counter >= 7'd69 && lr_has_car)begin
                next_state = S1;
                next_counter = 7'd0;
            end

            else begin
                next_state = S0;
                next_counter = counter + 7'd1;
            end
        end

    endcase

end
endmodule
