`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/13 14:44:33
// Design Name: 
// Module Name: test_clk_100kHz
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


module test_clk_100kHz;

reg clk,rst_n;
wire out_clock;

clock_100kHz uut(
.clk(clk),
.rst_n(rst_n),
.out_100kHz(out_clock));

initial begin
    clk = 0;
    rst_n = 1;
    
    #10 rst_n = 0;
    #10 rst_n = 1;
end

always #5 clk = ~clk;

endmodule
