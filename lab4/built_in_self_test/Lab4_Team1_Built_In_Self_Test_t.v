`timescale 1ns/1ps

module Built_In_Self_Test_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg scan_en = 1'b0;
wire scan_in;
wire scan_out;
parameter cyc = 10;
Built_In_Self_Test b0(clk, rst_n, scan_en, scan_in, scan_out);

always #(cyc / 2)clk = !clk;
initial begin
    $monitor("clk = %b, rst_n = %b, scan_en = %b | scan_in = %b, scan_out = %b",
            clk, rst_n, scan_en, scan_in, scan_out);
end

initial begin
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    
    scan_en = 1'b1;
    #(cyc * 8)
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)

    @(negedge clk)
    rst_n = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)


    @(negedge clk)
    rst_n = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)


    @(negedge clk)
    rst_n = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 8)

    @(negedge clk)
    $finish;

end
endmodule