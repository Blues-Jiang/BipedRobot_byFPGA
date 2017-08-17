`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 14:03:17
// Design Name: 
// Module Name: clock_50Hz
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

module clock_50Hz(clk,rst_n,out_50Hz,out_50Hz_pulse);

input clk,rst_n;
output reg out_50Hz,out_50Hz_pulse;

reg [31:0] counter;

always @ (posedge clk or negedge rst_n)
    if (!rst_n) begin
        out_50Hz_pulse <= 0;
        out_50Hz <= 0;
        counter <= 0;
    end
    else begin   //clk=100MHz
        if (counter >= 32'd1_999_999) begin
            counter <= 0;
            out_50Hz_pulse <= 1;
            out_50Hz <= 1;
        end
        else begin
            if (counter < 32'd1_000_000)        out_50Hz <= 1;
            else if (counter < 32'd2_000_000)   out_50Hz <= 0;
            counter <= counter + 1;
            out_50Hz_pulse <= 0;
        end
    end
        
endmodule
