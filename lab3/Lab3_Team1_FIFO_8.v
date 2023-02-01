`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output [8-1:0] dout;
output error;
reg [3-1:0] read_ptr;
reg [3-1:0] write_ptr;
reg [4-1:0] full_space;
reg [8-1:0] Mem [8-1:0];
reg [8-1:0] dout;
reg error;

reg [3-1:0] next_read_ptr;
reg [3-1:0] next_write_ptr;
reg [4-1:0] next_full_space;
reg [8-1:0] next_dout;
reg next_error;
always @(posedge clk)begin
    if(!rst_n)begin
        read_ptr <= 3'b000;
        write_ptr <= 3'b000;
        full_space <= 4'b0000;
        dout <= 8'b0;
        error <= 1'b0;
    end

    else begin
        read_ptr <= next_read_ptr;
        write_ptr <= next_write_ptr;
        full_space <= next_full_space;
        dout <= next_dout;
        error <= next_error;
    end
end

always @(*)begin
    //error check
        //(1,1), (1,0), (0,1)
        if(ren == 1 || wen == 1)begin
            //(1,1), (1,0)
            if(ren)begin
                //read empty
                if(full_space == 4'b0000)begin
                    next_error = 1'b1;
                    next_dout = 8'b0;
                    next_read_ptr = read_ptr;
                    next_write_ptr = write_ptr;
                    next_full_space = full_space;
                end
                //correct
                else begin
                    next_error = 1'b0;
                    next_dout = Mem[read_ptr];
                    next_read_ptr = read_ptr + 3'b001;
                    next_write_ptr = write_ptr;
                    next_full_space = full_space - 4'b0001;
                end
            end
            //(0,1)
            else begin
                //write full
                if(full_space == 4'b1000)begin
                    next_error = 1'b1;
                    next_dout = 8'b0;
                    next_read_ptr = read_ptr;
                    next_write_ptr = write_ptr;
                    next_full_space = full_space;
                end

                else begin
                    next_error = 1'b0;
                    next_dout = 8'b0;
                    Mem[write_ptr] = din;
                    next_read_ptr = read_ptr;
                    next_write_ptr = write_ptr + 3'b001;
                    next_full_space = full_space + 4'b0001;
                end
            end
        end

        else begin
            next_error = 1'b0;
            next_dout = 8'b0;
            next_read_ptr = read_ptr;
            next_write_ptr = write_ptr;
            next_full_space = full_space;
        end
end
endmodule



