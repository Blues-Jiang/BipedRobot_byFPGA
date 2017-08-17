`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/14 15:02:19
// Design Name: 
// Module Name: hex2bcd
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


module hex2bcd(hex_in,bcd_out);
//input clk,rst;
input [15:0] hex_in;
output [15:0] bcd_out;

wire [3:0] outdig,dig4,dig3,dig2,dig1;
wire [15:0] temp4,temp3,temp2,temp1;

assign bcd_out = (outdig == 4'd0)?{dig4,dig3,dig2,dig1}:16'h9999;
/*always @ (dig3 or dig2 or dig1 or dig0)
begin
    bcd_out <= {((dig3<=4'd9)?dig3:4'd9), ((dig2<=4'd9)?dig2:4'd9), ((dig1<=4'd9)?dig1:4'd9), ((dig0<=4'd9)?dig0:4'd9)};
end*/

getBCD ins_dig5(.din(hex_in), .bcd(outdig), .resttemp(temp4) );
getBCD ins_dig4(.din(temp4),  .bcd(dig4),   .resttemp(temp3) );
getBCD ins_dig3(.din(temp3),  .bcd(dig3),   .resttemp(temp2) );
getBCD ins_dig2(.din(temp2),  .bcd(dig2),   .resttemp(temp1) );
getBCD ins_dig1(.din(temp1),  .bcd(dig1),   .resttemp()      );
    
endmodule

module getBCD(din, bcd, resttemp);
input [15:0] din;
output [3:0] bcd;
output [15:0] resttemp;

wire [19:0] buffer;

assign buffer = {3'd0,din,1'd0} + {1'd0,din,3'd0};
//assign buffer = (din<<1) + (din<<3);
assign bcd = buffer[19:16];
assign resttemp = buffer[15:0];

endmodule