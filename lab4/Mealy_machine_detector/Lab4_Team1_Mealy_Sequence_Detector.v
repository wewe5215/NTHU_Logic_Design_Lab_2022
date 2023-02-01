`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;
reg [4-1:0] next_state;
reg [4-1:0] state;
parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S0_1 = 4'b0100;
parameter S0_10 = 4'b0101;
parameter S0_11 = 4'b0110;
parameter S0_110 = 4'b0111;
parameter S0_101 = 4'b1000;
parameter fail2 = 4'b1001;
parameter fail3 = 4'b1010;

always @(posedge clk) begin
    if(!rst_n)begin
        state <= S0;
    end

    else begin
        state <= next_state;
    end
end

always @(*)begin
    case (state)
        S0: 
            if(in)begin
                dec = 1'b0;
                next_state = S0_1;
            end

            else begin
                dec = 1'b0;
                next_state = S1;
            end
        S1:
            //01
            if(in)begin
                dec = 1'b0;
                next_state = S2;
            end
            //00
            else begin
                dec = 1'b0;
                next_state = fail2;
            end
        S2:
            //011
            if(in)begin
                dec = 1'b0;
                next_state = S3;
            end
            //010
            else begin
                dec = 1'b0;
                next_state = fail3;
            end
        S3:
            if(in)begin
                //0111 v
                dec = 1'b1;
                next_state = S0;
            end

            else begin
                //0110
                dec = 1'b0;
                next_state = S0;
            end
        S0_1:
            //11
            if(in)begin
                dec = 1'b0;
                next_state = S0_11;
            end
            //10
            else begin
                dec = 1'b0;
                next_state = S0_10;
            end
        S0_10:
            //101
            if(in)begin
                dec = 1'b0;
                next_state = S0_101;
            end
            //100
            else begin
                dec = 1'b0;
                next_state = fail3;
            end
        S0_11:
            //111
            if(in)begin
                dec = 1'b0;
                next_state = fail3;
            end
            //110
            else begin
                dec = 1'b0;
                next_state = S0_110;
            end
        S0_110:
            //1101
            if(in)begin
                dec = 1'b0;
                next_state = S0;
            end
            //1100 v
            else begin
                dec = 1'b1;
                next_state = S0;
            end
        S0_101:
            //1011 v
            if(in)begin
                dec = 1'b1;
                next_state = S0;
            end

            else begin
                dec = 1'b0;
                next_state = S0;
            end
        fail2:
            if(in)begin
                dec = 1'b0;
                next_state = fail3;
            end

            else begin
                dec = 1'b0;
                next_state = fail3;
            end
        fail3:
            if(in)begin
                dec = 1'b0;
                next_state = S0;
            end

            else begin
                dec = 1'b0;
                next_state = S0;
            end
        default: 
            if(in)begin
                dec = 1'b0;
                next_state = S0_1;
            end

            else begin
                dec = 1'b0;
                next_state = S1;
            end
    endcase

end

endmodule
