`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [4-1:0] wen;
input [8-1:0] a, b, c, d;
output [8-1:0] dout;
output valid;
//reg rstn_state;
//reg [4-1:0] wen_state;
reg [4-1:0] ren;
wire [8-1:0] temp_dout [4-1:0];
wire [4-1:0] temp_error;
reg [2-1:0] state;
reg [2-1:0] fifo_read_state;
reg [2-1:0] fifo_output_state;
reg [8-1:0] dout;
reg valid;
always @(posedge clk)begin
    if(!rst_n)begin
        fifo_read_state <= 2'b00;
        //rstn_state <= rst_n;
    end

    else begin
        
        fifo_read_state <= fifo_read_state + 2'b01;
        fifo_output_state <= fifo_read_state;
        //rstn_state <= rst_n;
        //wen_state <= wen;
    end
end


//ren generator
//read by arbiter or write data --> choose write data
always @(fifo_read_state or wen)begin
    if(!rst_n)begin
        ren = 4'b0000;
    end

    else begin
        if(fifo_read_state == 2'b00)begin
            if(wen[0])ren = 4'b0000;
            else ren = 4'b0001;
        end

        else if(fifo_read_state == 2'b01)begin
            if(wen[1])ren = 4'b0000;
            else ren = 4'b0010;
        end

        else if(fifo_read_state == 2'b10)begin
            if(wen[2])ren = 4'b0000;
            else ren = 4'b0100;
        end

        else begin
            if(wen[3])ren = 4'b0000;
            else ren = 4'b1000;
        end
    end
    
    
end

//decide output
always @(temp_dout[0] or temp_dout[1] or temp_dout[2] or temp_dout[3] or temp_error)begin
    if(!rst_n)begin
        valid = 1'b0;
        dout = 8'b0;
    end

    else begin
        if(fifo_output_state == 2'b00)begin
            if(wen[0])begin
                valid = 1'b0;
                dout = 8'b0;
            end
            else begin
                if(temp_error[0])begin
                    valid = 1'b0;
                    dout = 8'b0;
                end

                else begin
                    valid = 1'b1;
                    dout = temp_dout[0];
                end
            end
            
        end

        else if(fifo_output_state == 2'b01)begin
            if(wen[1])begin
                valid = 1'b0;
                dout = 8'b0;
            end
            else begin
                if(temp_error[1])begin
                    valid = 1'b0;
                    dout = 8'b0;
                end

                else begin
                    valid = 1'b1;
                    dout = temp_dout[1];
                end
            end
        end

        else if(fifo_output_state == 2'b10)begin
            if(wen[2])begin
                valid = 1'b0;
                dout = 8'b0;
            end
            else begin
                if(temp_error[2])begin
                    valid = 1'b0;
                    dout = 8'b0;
                end

                else begin
                    valid = 1'b1;
                    dout = temp_dout[2];
                end
            end
        end

        else begin
            if(wen[3])begin
                valid = 1'b0;
                dout = 8'b0;
            end
            else begin
                if(temp_error[3])begin
                    valid = 1'b0;
                    dout = 8'b0;
                end

                else begin
                    valid = 1'b1;
                    dout = temp_dout[3];
                end
            end
        end
    end
end

FIFO_8 f0(clk, rst_n, wen[0], ren[0], a, temp_dout[0], temp_error[0]);
FIFO_8 f1(clk, rst_n, wen[1], ren[1], b, temp_dout[1], temp_error[1]);
FIFO_8 f2(clk, rst_n, wen[2], ren[2], c, temp_dout[2], temp_error[2]);
FIFO_8 f3(clk, rst_n, wen[3], ren[3], d, temp_dout[3], temp_error[3]);


endmodule

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



