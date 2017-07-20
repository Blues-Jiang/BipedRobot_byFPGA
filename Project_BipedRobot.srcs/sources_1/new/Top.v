`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 10:27:15
// Design Name: 
// Module Name: Top
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

//          Left      |      Right
//  LDX-227 <- pwm_l1 | pwm_r1 -> LDX-227
//  LDX-218 <- pwm_l2 | pwm_r2 -> LDX-218
//  LDX-218 <- pwm_l3 | pwm_r3 -> LDX-218

module Top(clk,rst_n,sw,btn,DIPsw,out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3);
input clk,rst_n;
input sw;
input [4:0] btn;
input [3:0] DIPsw;
//input RS232_rx;
//output RS232_tx;
//output [7:0] LED;
//output [7:0] data;
//output [3:0] sel;
output wire out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3;

wire isRunningFlag,runLoopFlag,run1StepFlag;
//wire setOffsetFlag;

//Bluetooth Module
/*UART_top Bluetooth(
.clk(clk),
.rst_n(rst_n),
.RS232_rx(RS232_rx),
.RS232_tx(RS232_tx)
);*/

pwm_ctrl ins_pwm_ctrl(
.clk(clk),
.rst_n(rst_n),
.isRunningFlag(isRunningFlag),
.runLoopFlag(runLoopFlag),
.run1StepFlag(run1StepFlag),
.setOffsetFlag(1'b0),
.out_pwm_l1(out_pwm_l1),
.out_pwm_l2(out_pwm_l2),
.out_pwm_l3(out_pwm_l3),
.out_pwm_r1(out_pwm_r1),
.out_pwm_r2(out_pwm_r2),
.out_pwm_r3(out_pwm_r3));

data_in ins_dataIn(
.clk(clk),
.rst_n(rst_n),
.sw(sw),
.btn(btn),
.DIPsw(DIPsw),
.isRunningFlag(isRunningFlag),
.runLoopFlag(runLoopFlag),
.run1StepFlag(run1StepFlag)
//.setOffsetFlag(setOffsetFlag)
);

endmodule
