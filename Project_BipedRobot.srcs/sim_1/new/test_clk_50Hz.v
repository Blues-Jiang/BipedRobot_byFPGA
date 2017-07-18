`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/13 14:47:39
// Design Name: 
// Module Name: test_clk_50Hz
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


module test_clk_50Hz;

reg clk,rst_n;
wire out_clock;

clock_50Hz uut(
.clk(clk),
.rst_n(rst_n),
.out_50Hz(out_clock));

initial begin
    clk = 0;
    rst_n = 1;
    
    #10 rst_n = 0;
    #10 rst_n = 1;
end

always #5 clk = ~clk;

endmodule
