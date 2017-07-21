`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/20 18:17:53
// Design Name: 
// Module Name: test_pwm_ctrl
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


module test_pwm_ctrl;

reg clk,rst_n;
wire pwm_L1,pwm_L2,pwm_L3,pwm_R1,pwm_R2,pwm_R3;

copyTest_pwm_ctrl ins_copyTest(
.clk(clk),
.rst_n(rst_n),
.out_pwm_l1(pwm_L1),
.out_pwm_l2(pwm_L2),
.out_pwm_l3(pwm_L3),
.out_pwm_r1(pwm_R1),
.out_pwm_r2(pwm_R2),
.out_pwm_r3(pwm_R3)
);

initial begin
    clk = 0;
    rst_n = 1;
    
    #10 rst_n = 0;
    #10 rst_n = 1;
end

always #5 clk = ~clk;

endmodule

