`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/10 10:07:18
// Design Name: 
// Module Name: clock_100kHz
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


module clock_100kHz(clk,rst_n,out_100kHz);
    
input clk,rst_n;
output reg out_100kHz;
    
reg [15:0] counter;
    
always @ (posedge clk or negedge rst_n)
    if (!rst_n)
        begin
            out_100kHz <= 0;
            counter <= 0;
        end
    else
        if (counter == 16'd499) //clk=100MHz
            begin
                out_100kHz <= !out_100kHz;
                counter <= 0;
            end
        else 
            begin
                out_100kHz <= out_100kHz;
                counter <= counter + 1;
            end
            
endmodule
