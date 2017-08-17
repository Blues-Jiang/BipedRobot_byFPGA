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

module Top(clk,rst_n,sw,btn,DIPsw,trig,echo,RS232_rx,RS232_tx,LED,dig,seg,out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3);
input clk,rst_n;
input sw;
input [4:0] btn;
input [3:0] DIPsw;
input RS232_rx;
output RS232_tx;
input echo;
output trig;

output [3:0] dig;
output [7:0] seg;
output wire out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3;
output wire [7:0] LED;

wire isRunningFlag,resetFlag;
//wire setOffsetFlag;
wire [3:0] hwCtrlActionGroup;

wire interrupt;
wire [7:0] bt_data;
wire [23:0] distance;

//Bluetooth Module
UART_top Bluetooth(
.clk(clk),
.rst_n(rst_n),
.tx_int(interrupt),
.data_in(data_reg),
.RS232_rx(RS232_rx),
.RS232_tx(RS232_tx),
.data_out(bt_data)
);

assign LED[0] = isRunningFlag;
assign LED[1] = resetFlag;
assign LED[7:4] = hwCtrlActionGroup;

pwm_ctrl ins_pwm_ctrl(
.clk(clk),
.rst_n(rst_n),
.ActionGroupCtrl(hwCtrlActionGroup),
.distance(distance),
.resetFlag(resetFlag),
.isRunningFlag(isRunningFlag),
//.runLoopFlag(runLoopFlag),
//.run1StepFlag(run1StepFlag),
//.setOffsetFlag(1'b0),
.out_pwm_l1(out_pwm_l1),
.out_pwm_l2(out_pwm_l2),
.out_pwm_l3(out_pwm_l3),
.out_pwm_r1(out_pwm_r1),
.out_pwm_r2(out_pwm_r2),
.out_pwm_r3(out_pwm_r3),
.clk_int(interrupt));

data_in ins_dataIn(
.clk(clk),
.rst_n(rst_n),
.sw(sw),
.btn(btn),
.DIPsw(DIPsw),
.resetFlag(resetFlag),
.isRunningFlag(isRunningFlag),
//.runLoopFlag(runLoopFlag),
//.run1StepFlag(run1StepFlag),
.agCtrlFlag(hwCtrlActionGroup)
//.setOffsetFlag(setOffsetFlag)
);

segDisplayDriver ins_segDisplay(
.clk(clk),
.data(distance[23:8]),
.out_dig(dig),
.out_seg(seg));

Sonic ins_ultraSonic(
.clk(clk),
.rst_n(rst_n),
.trig(trig),
.echo(echo),
.distance(distance));


//    reg en_forward;      //ǰ��ʹ��
//    reg en_back;         //����ʹ��
//    reg en_keepdistance;  //���־���ʹ��
//    reg en_welcome;      //��ӭʹ��
//    reg en_kick;         //�����˶� 
//    reg en_slide;         //�����˶�
    

reg [7:0] data_reg;
reg digitFlag=0;   //λ���л���־
//reg out_of_distance=0;   //�����Զ��־
//reg in_distance=0;       //���������־

always@(posedge interrupt)
    if(digitFlag==0) begin
	   digitFlag<=1;
	   data_reg <= {4'b0011,distance[15:12]};
    end  
    else begin
      digitFlag<=0;
		data_reg <= {4'b0011,distance[19:16]};
    end

endmodule
