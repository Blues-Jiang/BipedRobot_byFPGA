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

module Top( clk,rst_n,
            sw,btn,DIPsw,LED,
            trig,echo,
            RS232_rx,RS232_tx,
            SCL,SDA,
            dig,seg,
            out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3
            );
//Defcult system clock and reset signal
input clk,rst_n;
//Button and switch signal
input sw;
input [4:0] btn;
input [3:0] DIPsw;
//Signal for UART Bluetooth module
input RS232_rx;
output RS232_tx;
//Signal for UltraSonic module
input echo;
output trig;
//Signal for I2C module 24C02
inout SCL, SDA;

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

wire SCL_en,SCL_o,SDA_en,SDA_o;
reg SCL_i,SDA_i;

//Bluetooth Module
UART_top ins_Bluetooth(
.clk(clk),
.rst_n(rst_n),
.tx_int(interrupt),
.data_in(data_reg),
.RS232_rx(RS232_rx),
.RS232_tx(RS232_tx),
.data_out(bt_data)
);

//I2C module 24C02
assign SCL = (SCL_en)?1'bz:SCL_o;//enable is low meant to write
assign SDA = (SDA_en)?1'bz:SDA_o;

always @ (SCL_en)//read the inout port when enable signal is high
    if(SCL_en)  SCL_i = SCL;
always @ (SDA_en)
    if(SDA_en)  SDA_i = SDA;

EEPROM_Top ins_24C02(
.clk(clk),
.rst_n(rst_n),
.rw_en(),
.data_in(),
.data_out(),
.SCL_en(SCL_en),
.SCL_o(SCL_o),
.SCL_i(SCL_i),
.SDA_en(SDA_en),
.SDA_o(SDA_o),
.SDA_i(SDA_i)
);

write_en, flag_write_done,flag_error,flag_read_done,


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


//    reg en_forward;      //前进使能
//    reg en_back;         //后退使能
//    reg en_keepdistance;  //保持距离使能
//    reg en_welcome;      //欢迎使能
//    reg en_kick;         //踢腿运动 
//    reg en_slide;         //滑步运动
    

reg [7:0] data_reg;
reg digitFlag=0;   //位数切换标志
//reg out_of_distance=0;   //距离过远标志
//reg in_distance=0;       //距离过近标志

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
