`timescale 1ns / 1ps

module RoundRobinArbiter_tb;
reg clk=0;
reg rst_n=0;
reg [3:0] wen=4'b0000;
reg [7:0] a, b, c, d;
wire [7:0] dout;
wire valid;
//
Round_Robin_FIFO_Arbiter RRA(
    .clk(clk), 
    .rst_n(rst_n),
    .wen(wen),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .dout(dout),
    .valid(valid)
);
//
always #10 clk = ~clk;
initial begin
    $monitor("clk = %b, rst_n = %b, wen = %b, a = %d, b = %d, c = %d, d = %d | dout = %d, valid = %b",
    clk, rst_n, wen, a, b, c, d, dout, valid);
end
initial begin
    @(negedge clk)
    rst_n = 1'b0;
    wen = 4'b1111;
    //read empty a
    @(negedge clk)
    rst_n = 1'b1;
    wen = 4'b0000;
    //read empty b
    @(negedge clk)
    wen = 4'b0000;
    //read empty c
    @(negedge clk)
    wen = 4'b0000;
    //read empty d
    @(negedge clk)
    wen = 4'b0000;
    //write data to a
    @(negedge clk)
    wen = 4'b0001;
    a = 8'd1;
    b = 8'd11;
    c = 8'd21;
    d = 8'd31;
    //write data to b
    @(negedge clk)
    wen = 4'b0010;
    a = 8'd1;
    b = 8'd11;
    c = 8'd21;
    d = 8'd31;
    //write data to c
    @(negedge clk)
    wen = 4'b0100;
    a = 8'd1;
    b = 8'd11;
    c = 8'd21;
    d = 8'd31;
    //write data to d
    @(negedge clk)
    wen = 4'b1000;
    a = 8'd1;
    b = 8'd11;
    c = 8'd21;
    d = 8'd31;
    //write data to bc read a
    @(negedge clk)
    wen = 4'b0110;
    a = 8'd2;
    b = 8'd12;
    c = 8'd22;
    d = 8'd32;
    //write data to cd read b
    @(negedge clk)
    wen = 4'b1100;
    a = 8'd2;
    b = 8'd13;
    c = 8'd23;
    d = 8'd32;
    //write data to da read c
    @(negedge clk)
    wen = 4'b1001;
    a = 8'd2;
    b = 8'd13;
    c = 8'd23;
    d = 8'd33;
    //write data to ab read d
    @(negedge clk)
    wen = 4'b0011;
    a = 8'd3;
    b = 8'd13;
    c = 8'd23;
    d = 8'd33;
    //write data to abc
    @(negedge clk)
    wen = 4'b0111;
    a = 8'd4;
    b = 8'd14;
    c = 8'd24;
    d = 8'd33;
    //write data to bcd
    @(negedge clk)
    wen = 4'b1110;
    a = 8'd5;
    b = 8'd15;
    c = 8'd25;
    d = 8'd34;
    //write data to cda
    @(negedge clk)
    wen = 4'b1101;
    a = 8'd5;
    b = 8'd16;
    c = 8'd26;
    d = 8'd35;
    //write data to dab
    @(negedge clk)
    wen = 4'b1011;
    a = 8'd6;
    b = 8'd16;
    c = 8'd27;
    d = 8'd36;
    //write data to abcd
    @(negedge clk)
    wen = 4'b1111;
    a = 8'd7;
    b = 8'd17;
    c = 8'd27;
    d = 8'd37;
    @(negedge clk)
    wen = 4'b1111;
    a = 8'd8;
    b = 8'd18;
    c = 8'd28;
    d = 8'd38;
    @(negedge clk)
    a = 8'd9;
    b = 8'd19;
    c = 8'd29;
    d = 8'd39;
    @(negedge clk)
    wen = 4'b0000;
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    @(negedge clk)
    wen = 4'b1000;
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    @(negedge clk)
    wen = 4'b1000;
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    //read c
    @(negedge clk)
    wen = 4'b1000;
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    //reset
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    wen = 4'b1111;
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    @(negedge clk)
    wen = 4'b0000;
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    @(negedge clk)
    $finish;

end
endmodule

