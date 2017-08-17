`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/11 11:19:14
// Design Name: 
// Module Name: EEPROM_Top
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

//The driver of EEPROM device 24C02
//It's I2C bus
module EEPROM_Top(clk, rst_n, rw_en, SCL, SDA);
input clk, rst_n, rw_en;
inout SCL, SDA;
input data_in;
output wire data_out;

wire SCL_en,SCL_o,SDA_en,SDA_o;
reg SCL_i,SDA_i;

assign SCL = (SCL_en)?1'bz:SCL_o;
assign SDA = (SDA_en)?1'bz:SDA_o;

always @ 

localparam I2CAddr = 7'b1010_000; //Device Address is 000,the LSB is the R/W bit.

endmodule
