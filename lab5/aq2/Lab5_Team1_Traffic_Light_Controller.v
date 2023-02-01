`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output [2:0] hw_light;
output [2:0] lr_light;

parameter A = 3'd1;
parameter B = 3'd2;
parameter C = 3'd3;
parameter D = 3'd4;
parameter E = 3'd5;
parameter F = 3'd6;
parameter Green = 3'b100;
parameter Yellow = 3'b010;
parameter Red = 3'b001;

reg [2:0] state, next_state; //A, B, C, D, E, F
reg [7:0] counter, next_counter; 
reg [2:0] hw_light, lr_light;

always@(posedge clk)begin
    if( rst_n == 0) begin
        state <= A;
        counter <= 0; 
    end 
    else begin
        state <= next_state;
        counter <= next_counter;
    end 
end 

always@(*)begin
    case (state)
        A: begin
            if( counter < 8'd69 ) begin
                next_state = A;
                next_counter = counter + 1;    
            end
            else begin
                if ( lr_has_car == 1 ) begin
                    next_state = B;
                    next_counter = 0;
                end 
                else begin
                    next_state = A; //keep
                    next_counter = counter;
                end
            end 
            hw_light = Green; //green
            lr_light = Red; //red
        end
        
        B: begin
            if( counter < 8'd24 ) begin
                next_state = B;
                next_counter = counter + 1;
            end 
            else begin
                next_state = C;
                next_counter = 0;  
            end 
            hw_light = Yellow; //yellow
            lr_light = Red; //red
        end 
        
        C: begin //3
            next_state = D;
            next_counter = 0;
            hw_light = Red; //red
            lr_light = Red; //red
        end
        
        D: begin
            if( counter < 8'd69 ) begin
                next_state = D;
                next_counter = counter + 1;
            end
            else begin
                next_state = E;
                next_counter = 0;
            end 
            hw_light = Red; //red
            lr_light = Green; //green
        end
        
        E: begin //5
            if( counter < 8'd24 ) begin
                next_state = E;
                next_counter = counter + 1;
            end
            else begin
                next_state = F;
                next_counter = 0;
            end 
            hw_light = Red; //red
            lr_light = Yellow; //yellow
        end
        
        F: begin
            next_state = A;
            next_counter = 0;
            hw_light = Red; //red
            lr_light = Red; //red       
        end 
        
        default: begin
            next_state = A;
            next_counter = 0;
            hw_light = Red; //red
            lr_light = Red; //red    
        end
        
    endcase
end 

endmodule
