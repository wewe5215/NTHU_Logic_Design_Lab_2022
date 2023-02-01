module SampleDisplay(
    output wire [6:0] display,
    output wire [3:0] digit,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk
    );
    
    parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
    parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
    parameter [8:0] KEY_CODES_00 = 9'b0_0100_0101; // 0 => 45
    parameter [8:0] KEY_CODES_01 = 9'b0_0001_0110; // 1 => 16
    parameter [8:0] KEY_CODES_02 = 9'b0_0001_1110; // 2 => 1E
    parameter [8:0] KEY_CODES_03 = 9'b0_0010_0110; // 3 => 26
    parameter [8:0] KEY_CODES_04 = 9'b0_0010_0101; // 4 => 25
    parameter [8:0] KEY_CODES_05 = 9'b0_0010_1110; // 5 => 2E
    parameter [8:0] KEY_CODES_06 = 9'b0_0011_0110; // 6 => 36
    parameter [8:0] KEY_CODES_07 = 9'b0_0011_1101; // 7 => 3D
    parameter [8:0] KEY_CODES_08 = 9'b0_0011_1110; // 8 => 3E
    parameter [8:0] KEY_CODES_09 = 9'b0_0100_0110; // 9 => 46
        
    parameter [8:0] KEY_CODES_10 = 9'b0_0111_0000; // right_0 => 70
    parameter [8:0] KEY_CODES_11 = 9'b0_0110_1001; // right_1 => 69
    parameter [8:0] KEY_CODES_12 = 9'b0_0111_0010; // right_2 => 72
    parameter [8:0] KEY_CODES_13 = 9'b0_0111_1010; // right_3 => 7A
    parameter [8:0] KEY_CODES_14 = 9'b0_0110_1011; // right_4 => 6B
    parameter [8:0] KEY_CODES_15 = 9'b0_0111_0011; // right_5 => 73
    parameter [8:0] KEY_CODES_16 = 9'b0_0111_0100; // right_6 => 74
    parameter [8:0] KEY_CODES_17 = 9'b0_0110_1100; // right_7 => 6C
    parameter [8:0] KEY_CODES_18 = 9'b0_0111_0101; // right_8 => 75
    parameter [8:0] KEY_CODES_19 = 9'b0_0111_1101; // right_9 => 7D
    
    reg [15:0] nums, next_nums;
    reg [3:0] key_num;
    reg [9:0] last_key;
    
    wire shift_down;
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    
    assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
    
    SevenSegment seven_seg (
        .display(display),
        .digit(digit),
        .nums(nums),
        .rst(rst),
        .clk(clk)
    );
        
    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            nums <= 16'b0;
        end else begin
            nums <= next_nums;
        end
    end
    always @ (*) begin
        next_nums = nums;
        if (been_ready && key_down[last_change] == 1'b1) begin
            if (key_num != 4'b1111) begin
                if (shift_down == 1'b1) begin
                    next_nums = {key_num, nums[15:4]};
                end else begin
                    next_nums = {nums[11:0], key_num};
                end
            end else next_nums = next_nums;
        end else next_nums = next_nums;
    end

    always @ (*) begin
        case (last_change)
            KEY_CODES_00 : key_num = 4'b0000;
            KEY_CODES_01 : key_num = 4'b0001;
            KEY_CODES_02 : key_num = 4'b0010;
            KEY_CODES_03 : key_num = 4'b0011;
            KEY_CODES_04 : key_num = 4'b0100;
            KEY_CODES_05 : key_num = 4'b0101;
            KEY_CODES_06 : key_num = 4'b0110;
            KEY_CODES_07 : key_num = 4'b0111;
            KEY_CODES_08 : key_num = 4'b1000;
            KEY_CODES_09 : key_num = 4'b1001;
            KEY_CODES_10 : key_num = 4'b0000;
            KEY_CODES_11 : key_num = 4'b0001;
            KEY_CODES_12 : key_num = 4'b0010;
            KEY_CODES_13 : key_num = 4'b0011;
            KEY_CODES_14 : key_num = 4'b0100;
            KEY_CODES_15 : key_num = 4'b0101;
            KEY_CODES_16 : key_num = 4'b0110;
            KEY_CODES_17 : key_num = 4'b0111;
            KEY_CODES_18 : key_num = 4'b1000;
            KEY_CODES_19 : key_num = 4'b1001;
            default      : key_num = 4'b1111;
        endcase
    end
    
endmodule
