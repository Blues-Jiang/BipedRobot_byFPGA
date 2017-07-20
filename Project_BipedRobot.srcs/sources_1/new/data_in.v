`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/18 10:59:33
// Design Name: 
// Module Name: data_in
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


module data_in(clk,rst_n,sw,btn,DIPsw,isRunningFlag,runLoopFlag,run1StepFlag);
input clk,rst_n;
input sw;
input [4:0] btn;
input [3:0] DIPsw;
//input [7:0] din;

output wire isRunningFlag;
output wire runLoopFlag;
output wire run1StepFlag;
//output wire setOffsetFlag;

btn2btn sw_isRunning(.clk(clk),.rst_n(rst_n),.din(sw),.flag(isRunningFlag));
btn2sw  btn_runLoop(.clk(clk),.rst_n(rst_n),.din(btn[0]),.flag(!runLoopFlag));
btn2btn  btn_run1Step(.clk(clk),.rst_n(rst_n),.din(btn[1]),.flag(!run1StepFlag));
//btn2sw btn_setOffset(.clk(clk),.rst_n(rst_n),.din(sw),.flag(!setOffsetFlag));

endmodule

module btn2sw(clk,rst_n,din,flag);
input clk,rst_n,din;
output reg flag;

reg [31:0] counter;
reg [2:0] state;

parameter SstableHigh=0,SunstableHigh=1,Snegedge=2,SstableLow=3,SunstableLow=4,Sposedge=5;

always @ (posedge clk or negedge rst_n)
if (!rst_n) begin
    state <= SstableHigh;
    counter <= 32'd0;
    flag <= 1'b0;
end
else begin
    case(state)
        SstableHigh: begin
            if(din == 1'b1) begin
                state <= SstableHigh;
            end
            else begin
                counter <= 0;
                state <= SunstableHigh;
            end
        end
        SunstableHigh: begin
            if(counter >= 32'd2_000_000) begin
                counter <= 32'd0;
                if ( din == 1'b0 )     state <= Snegedge;
                else    state <= SstableHigh;
            end
            else begin
                counter <= counter + 1;
                state <= SunstableHigh;
            end
        end
        Snegedge: begin
            flag <= ~flag;
            state <= SstableLow;
        end
        SstableLow: begin
            if(din == 1'b0) begin
                state <= SstableLow;
            end
            else begin
                counter <= 0;
                state <= SunstableLow;
            end
        end
        SunstableLow: begin
            if(counter >= 32'd2_000_000) begin
                counter <= 32'd0;
                if ( din == 1'b1 )     state <= Sposedge;
                else    state <= SstableLow;
            end
            else begin
                counter <= counter + 1;
                state <= SunstableLow;
            end
        end
        Sposedge: begin
            state <= SstableHigh;
        end
    endcase
end

endmodule

module btn2btn(clk,rst_n,din,flag);
input clk,rst_n,din;
output reg flag;

reg [31:0] counter;
reg [2:0] state;

parameter SstableHigh=0,SunstableHigh=1,Snegedge=2,SstableLow=3,SunstableLow=4,Sposedge=5;

always @ (posedge clk or negedge rst_n)
if (!rst_n) begin
    state <= SstableHigh;
    counter <= 32'd0;
    flag <= 1'b0;
end
else begin
    case(state)
        SstableHigh: begin
            if(din == 1'b1) begin
                state <= SstableHigh;
            end
            else begin
                counter <= 0;
                state <= SunstableHigh;
            end
        end
        SunstableHigh: begin
            if(counter >= 32'd2_000_000) begin
                counter <= 32'd0;
                if ( din == 1'b0 )     state <= Snegedge;
                else    state <= SstableHigh;
            end
            else begin
                counter <= counter + 1;
                state <= SunstableHigh;
            end
        end
        Snegedge: begin
            flag <= 1'b0;
            state <= SstableLow;
        end
        SstableLow: begin
            if(din == 1'b0) begin
                state <= SstableLow;
            end
            else begin
                counter <= 0;
                state <= SunstableLow;
            end
        end
        SunstableLow: begin
            if(counter >= 32'd2_000_000) begin
                counter <= 32'd0;
                if ( din == 1'b1 )     state <= Sposedge;
                else    state <= SstableLow;
            end
            else begin
                counter <= counter + 1;
                state <= SunstableLow;
            end
        end
        Sposedge: begin
            flag <= 1'b1;
            state <= SstableHigh;
        end
    endcase
end

endmodule
