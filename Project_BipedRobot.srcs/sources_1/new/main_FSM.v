`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/15 16:42:26
// Design Name: 
// Module Name: main_FSM
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


module main_FSM();
input clk,rst_n;
input ;

reg [3:0] mainState;
localparam flagRunning = 4'b0001, flagStop = 4'b0000, flagSetOffset = 4'b0010, flagInit = 4'b1000 ;

always @ ( posedge clk or negedge rst_n)
if(!rst_n) begin
    mainState <= flagInit;
end
else begin
    case(mainState)
        flagInit: begin
            
        end
        flagStop: begin
        
        end
    endcase
end


endmodule
