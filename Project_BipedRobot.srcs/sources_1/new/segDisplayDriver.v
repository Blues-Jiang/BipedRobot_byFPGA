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
    if(clk_cnt == 32'd100_000) begin
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
reg [3:0] seg_ctrl;
always @ (dig_ctrl)
    case(dig_ctrl)
        4'b1110:    seg_ctrl=data[3:0];
        4'b1101:    seg_ctrl=data[7:4];
        4'b1011:    seg_ctrl=data[11:8];
        4'b0111:    seg_ctrl=data[15:12];
        default:      seg_ctrl=4'hf;
    endcase
//----------------------------------------------------------
//解码模块
reg [7:0] seg_reg;

always @( seg_ctrl )
    case( seg_ctrl )
        4'h0:   seg_reg = 8'b1100_0000;//0
        4'h1:   seg_reg = 8'b1111_1001;//1
        4'h2:   seg_reg = 8'b1010_0100;//2
        4'h3:   seg_reg = 8'b1011_0000;//3
        4'h4:   seg_reg = 8'b1001_1001;//4
        4'h5:   seg_reg = 8'b1001_0010;//5
        4'h6:   seg_reg = 8'b1000_0010;//6
        4'h7:   seg_reg = 8'b1111_1000;//7
        4'h8:   seg_reg = 8'b1000_0000;//8
        4'h9:   seg_reg = 8'b1001_0000;//9
        //4'ha:   seg_reg = 8'b1100_0111;//L
        //4'hb:   seg_reg = 8'b1010_1111;//r
        
//        4'ha:   seg_reg = 8'b1000_1000;//a
//        4'hb:   seg_reg = 8'b1000_0011;//b
//        4'hc:   seg_reg = 8'b1100_0110;//c
//        4'hd:   seg_reg = 8'b1010_0001;//d
        4'ha:   seg_reg = 8'b1000_1000;//a
        4'hb:   seg_reg = 8'b1000_0011;//b
        4'hc:   seg_reg = 8'b1100_0110;//c
        4'hd:   seg_reg = 8'b1010_0001;//d
        4'he:   seg_reg = 8'b1000_0110;//e
        4'hf:   seg_reg = 8'b1000_1110;//f
//         4'hf:seg_reg=8'b1111_1111;//不显示
        default : seg_reg = 8'b1011_1111;//-
    endcase
//----------------------------------------------------------
assign out_dig = dig_ctrl;
assign out_seg = seg_reg;

endmodule
