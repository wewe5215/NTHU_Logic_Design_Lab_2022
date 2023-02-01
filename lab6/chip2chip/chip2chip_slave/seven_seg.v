//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: Bob Cheng
//
// Create Date: 2019/08/25
// Module Name: decoder and seven_segment endcoder
// Project Name:Chip2Chip
// Additional Comments: display utility modules.
//////////////////////////////////////////////////////////////////////////////////

module decoder(in, out);
	input [3-1:0] in;
	output reg [7:0] out;
	always@(*) begin
		case(in)
			3'b000: out = 8'b0000_0001;
			3'b001: out = 8'b0000_0010;
			3'b010: out = 8'b0000_0100;
			3'b011: out = 8'b0000_1000;
			3'b100: out = 8'b0001_0000;
			3'b101: out = 8'b0010_0000;
			3'b110: out = 8'b0100_0000;
			3'b111: out = 8'b1000_0000;
		endcase
	end
endmodule

module seven_segment(in, out);
    input [8-1:0] in;
    output reg [7-1:0] out;
    always@(*) begin
        out[0] = (in[1]|in[4]);
        out[1] = (in[5]|in[6]);
        out[2] = (in[2]);
        out[3] = (in[1]|in[4]|in[7]);
        out[4] = (in[1]|in[3]|in[4]|in[5]|in[7]);
        out[5] = (in[1]|in[2]|in[3]|in[7]);
        out[6] = (in[0]|in[1]|in[7]);
    end
endmodule
