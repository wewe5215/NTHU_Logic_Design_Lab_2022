`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [1:0] out;
output reg [2:0] state;
reg [2:0] next_state;
reg [1:0] next_out;
parameter S0 = 3'b000;//11
parameter S1 = 3'b001;//01
parameter S2 = 3'b010;//11
parameter S3 = 3'b011;//10
parameter S4 = 3'b100;//10
parameter S5 = 3'b101;//00

always @(posedge clk) begin
    if(!rst_n)begin
        state <= S0;
        out <= 2'b11;
    end

    else begin
        state <= next_state;
        out <= next_out;
    end
end


always @(*)begin
    case (state)
        S0:
            if(in)begin
                next_state = S2;
                next_out = 2'b11;
            end

            else begin
                next_state = S1;
                next_out = 2'b11;
            end
        S1:
            if(in) begin
                next_state = S5;
                next_out = 2'b01;
            end
            else begin
                next_state = S4;
                next_out = 2'b01;
            end
        S2:
            if(in)begin
                next_state = S3;
                next_out = 2'b11;
            end
            else begin
                next_state = S1;
                next_out = 2'b11;
            end
        S3:
             
            if(in) begin
                next_state = S0;
                next_out = 2'b10;
            end
            else begin
                next_state = S1;
                next_out = 2'b10;
            end
        S4:
            if(in) begin
                next_state = S5;
                next_out = 2'b10;
            end
            else begin
                next_state = S4;
                next_out = 2'b10;
            end
        S5:
            if(in) begin
                next_state = S0;
                next_out = 2'b00;
            end
            else begin
                next_state = S3;  
                next_out = 2'b00;
            end     
        default: 
            if(in) begin
                next_state = S2;
                next_out = 2'b11;
            end
            else begin
                next_state = S1;
                next_out = 2'b11;
            end
    endcase

end



endmodule