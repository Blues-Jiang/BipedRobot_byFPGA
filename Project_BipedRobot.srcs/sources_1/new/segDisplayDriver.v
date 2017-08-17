`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/21 15:17:42
// Design Name: 
// Module Name: segDisplayDriver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Driver for 4-digits 7-segments display.
module segDisplayDriver(clk,data,out_dig,out_seg);

input clk;
input [15:0] data;
output [3:0] out_dig;
output [7:0] out_seg;

//分频
reg [31:0] clk_cnt;
reg clk_500Hz;

always @ (posedge clk)
    if(clk_cnt == 32'd200_000) begin
        clk_cnt <= 1'b0;
        clk_500Hz <= ~clk_500Hz;
    end
    else
        clk_cnt <= clk_cnt + 1'b1;

//Digit Control
reg [3:0] dig_ctrl = 4'b1110;
always @(posedge clk_500Hz)
dig_ctrl <= { dig_ctrl[2:0], dig_ctrl[3] };

//Segment Control
reg [4:0] seg_ctrl;
always @ (dig_ctrl)
    case(dig_ctrl)
        4'b1110:    seg_ctrl={1'b0,data[3:0]};
        4'b1101:    seg_ctrl={1'b0,data[7:4]};
        4'b1011:    seg_ctrl={1'b0,data[11:8]};
        4'b0111:    seg_ctrl={1'b0,data[15:12]};
        default:      seg_ctrl=5'h1f;
    endcase
//----------------------------------------------------------
//解码模块
reg [7:0] seg_reg;
//seg_reg = {dp,g,f,e,d,c,b,a}
always @( seg_ctrl )
    case( seg_ctrl )
        5'h00:  seg_reg = 8'b1100_0000;//0
        5'h01:  seg_reg = 8'b1111_1001;//1
        5'h02:  seg_reg = 8'b1010_0100;//2
        5'h03:  seg_reg = 8'b1011_0000;//3
        5'h04:  seg_reg = 8'b1001_1001;//4
        5'h05:  seg_reg = 8'b1001_0010;//5
        5'h06:  seg_reg = 8'b1000_0010;//6
        5'h07:  seg_reg = 8'b1111_1000;//7
        5'h08:  seg_reg = 8'b1000_0000;//8
        5'h09:  seg_reg = 8'b1001_0000;//9
        5'h0a:  seg_reg = 8'b1000_1000;//a
        5'h0b:  seg_reg = 8'b1000_0011;//b
        5'h0c:  seg_reg = 8'b1100_0110;//c
        5'h0d:  seg_reg = 8'b1010_0001;//d
        5'h0e:  seg_reg = 8'b1000_0110;//e
        5'h0f:  seg_reg = 8'b1000_1110;//f
        5'h10:  seg_reg = 8'b1111_1111;//None
        5'h11:  seg_reg = 8'b1100_0111;//L
        5'h12:  seg_reg = 8'b1010_1111;//r
        5'h13:  seg_reg = 8'b1010_0001;//d
        5'h14:  seg_reg = 8'b1010_0011;//o
        5'h15:  seg_reg = 8'b1010_1011;//n
        5'h16:  seg_reg = 8'b1000_0110;//e
//         5'hf:seg_reg=8'b1111_1111;//不显示
        default:seg_reg = 8'b1111_1111;//None
    endcase
//----------------------------------------------------------
assign out_dig = dig_ctrl;
assign out_seg = seg_reg;

endmodule
