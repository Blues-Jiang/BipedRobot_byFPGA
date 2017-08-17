`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 14:03:17
// Design Name: 
// Module Name: clock_5Hz
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

module clock_5Hz(clk,rst_n,out_5Hz);

input clk,rst_n;
output reg out_5Hz;

reg [31:0] counter;

always @ (posedge clk or negedge rst_n)
    if (!rst_n)
        begin
            out_5Hz <= 0;
            counter <= 0;
        end
    else
        if (counter >= 32'd10_000_000)   //clk=100MHz
            begin
                out_5Hz <= !out_5Hz;
                counter <= 0;
            end
        else
            begin
                out_5Hz <= out_5Hz;
                counter <= counter + 1;
            end
        
endmodule
