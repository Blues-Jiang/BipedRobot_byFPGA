`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 11:11:05
// Design Name: 
// Module Name: clock_1MHz
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


module clock_1MHz(clk,rst_n,out_1MHz);

input clk,rst_n;
output reg out_1MHz;

reg [7:0] counter;

always @ (posedge clk or negedge rst_n)
    if (!rst_n)
        begin
            out_1MHz <= 0;
            counter <= 0;
        end
    else
        if (counter >= 8'd50) //clk=100MHz
            begin
                out_1MHz <= !out_1MHz;
                counter <= 0;
            end
        else 
            begin
                out_1MHz <= out_1MHz;
                counter <= counter + 1;
            end
        
endmodule
