`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;
reg dec; 

parameter s0 = 3'd0;
parameter s1 = 3'd1;
parameter s2 = 3'd2;
parameter s3 = 3'd3;
parameter s4 = 3'd4;
parameter s5 = 3'd5;
parameter s6 = 3'd6;
parameter s7 = 3'd7;

reg [2:0] state, next_state;

always@(posedge clk) begin
    if (rst_n == 0) begin
        state <= s0;
    end 
    else begin
        state <= next_state;
    end
end 

always @(*) begin 
    case ( state ) 
        s0: begin //x 
            dec = 0;
            if( in == 1 ) begin
                next_state = s1; 
            end 
            else begin
                next_state = s0; //1
            end 
        end 
        
        s1: begin //1
            dec = 0;
            if ( in == 1 ) begin
                next_state = s2; 
            end 
            else begin
                next_state = s0; //2
            end 
        end 
        
        s2: begin //11
            dec = 0;
            if ( in == 1 ) begin
                next_state = s3; 
            end 
            else begin
                next_state = s0; //3
            end 
        end
        
        s3: begin //111
            dec = 0;
            if ( in == 0 ) begin
                next_state = s4; 
            end 
            else begin
                next_state = s3; 
            end 
        end
        
        s4: begin //1110
            dec = 0;
            if ( in == 0 ) begin
                next_state = s5; 
            end 
            else begin
                next_state = s1;
            end 
        end
        
        s5: begin //11100
            dec = 0;
            if ( in == 1 ) begin
                next_state = s6; 
            end 
            else begin
                next_state = s0; //4
            end 
        end
        
        s6: begin //111001     
            dec = 0;  
            if ( in == 1 ) begin
                next_state = s7;      
            end 
            else begin
                next_state = s5; //5
            end 
        end
        
        s7: begin
            if ( in == 1 ) begin
                next_state = s3; 
                dec = 1;
            end 
            else begin
                next_state = s0; //6
                dec = 0;
            end 
        end
        
        default: begin
            next_state = s0;
            dec = 0; 
        end 
        
    endcase
end 

endmodule 