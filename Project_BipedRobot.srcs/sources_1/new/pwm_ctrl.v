`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/10 17:05:28
// Design Name: 
// Module Name: pwm_ctrl
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


module pwm_ctrl(clk,rst_n,out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3);
input clk,rst_n;
input [7:0] data;
output wire out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3;//PWM Signal to drive Servos

wire clk_100kHz,clk_50Hz,clk_50Hz_pulse;

reg [7:0] cur_duty_l1,cur_duty_l2,cur_duty_l3,cur_duty_r1,cur_duty_r2,cur_duty_r3;//Duty Cycle of Servos  ->  Current State
reg [7:0] nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3;//Duty Cycle of Servos  ->  Next State from Action Group
reg [7:0] leftTimes;
//8-bit in Mem 
reg [3:0] ActionGroupNo;
reg [2:0] NC;
reg lastAction;
wire [63:0] memBuffer;
reg [7:0] offset_l1,offset_l2,offset_l3,offset_r1,offset_r2,offset_r3;//Offset correction signal of Servos

reg [8:0] readMemAddr;
parameter SPEED=8'd5;//Servo move speed. -> LDX-218 -> 4.5бу LDX-227 -> 6.75бу

//Flag List
//reg updateFlag;     //Depend on 50Hz clock.It's a flag to update the duty cycle
reg runLoopFlag;    //If you need to cycle the action group,this flag should be set as 1
reg run1StepFlag;   //Run action group step by step.
reg isRunningFlag;  //

parameter AddrInit = 9'd0,
    AddrMoveForword = 9'd1,
    AddrMoveBackword = 9'd2,
    AddrTurnLeft = 9'd3,
    AddrTurnRight = 9'd4;
    

clock_100kHz ins_clk_100kHz(
.clk(clk),
.rst_n(rst_n),
.out_100kHz(clk_100kHz)
);

clock_50Hz ins_clk_50Hz(
.clk(clk),
.rst_n(rst_n),
.out_50Hz(clk_50Hz),
.out_50Hz_pulse(clk_50Hz_pulse)
);

//Servo PWM driver module
pwm pwm_l1(.clk(clk_100kHz),.rst(clk_50Hz_pulse),.pwm_duty(cur_duty_l1),.pwm_offset(offset_l1),.pwm_out(out_pwm_l1));
pwm pwm_l2(.clk(clk_100kHz),.rst(clk_50Hz_pulse),.pwm_duty(cur_duty_l2),.pwm_offset(offset_l2),.pwm_out(out_pwm_l2));
pwm pwm_l3(.clk(clk_100kHz),.rst(clk_50Hz_pulse),.pwm_duty(cur_duty_l3),.pwm_offset(offset_l3),.pwm_out(out_pwm_l3));
pwm pwm_r1(.clk(clk_100kHz),.rst(clk_50Hz_pulse),.pwm_duty(cur_duty_r1),.pwm_offset(offset_r1),.pwm_out(out_pwm_r1));
pwm pwm_r2(.clk(clk_100kHz),.rst(clk_50Hz_pulse),.pwm_duty(cur_duty_r2),.pwm_offset(offset_r2),.pwm_out(out_pwm_r2));
pwm pwm_r3(.clk(clk_100kHz),.rst(clk_50Hz_pulse),.pwm_duty(cur_duty_r3),.pwm_offset(offset_r3),.pwm_out(out_pwm_r3)); 

reg [11:0] writeAddr;
reg [7:0]  writeData;

//Menery of Action Group
ActionGroupMem ins_ActionGroupMem(
//Port A writter
.clka(clk),
.ena(1'd0),
.wea(1'd0),
.addra(writeAddr),//[11:0]
.dina(writeData),//[7:0]
//Port B reader
.clkb(clk),
.enb(clk_50Hz),
.addrb(readMemAddr),//[8:0]
.doutb(memBuffer)//[63:0],{takeTime,Null,nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3}
);

reg [7:0] counter;
reg [7:0] state;
parameter Sbegin=8'd0,SreadMem=8'd1,Swait4Action=8'd2,SupdateAddr=8'd3,Sreset=8'hfe,Sstop=8'hff;

//Reset other signal
always @ ( negedge rst_n )
begin
    runLoopFlag <= 1;
    writeData <= 8'd0;
    writeAddr <= 12'd0;
end

//It's for offset signal,the offset value is changeable
always @ (posedge clk or negedge rst_n )
if(!rst_n) begin
    {offset_l1,offset_l2,offset_l3,offset_r1,offset_r2,offset_r3} <= {6{8'd150}};
end
else begin
    if(!isRunningFlag) begin
        
    end
end

//Update Servo State(cur_pwm <= nxt_pwm)
always @ ( posedge clk_50Hz_pulse or negedge rst_n )//Driven variable:cur_duty_xx
if(!rst_n) begin
    {cur_duty_l1,cur_duty_l2,cur_duty_l3,cur_duty_r1,cur_duty_r2,cur_duty_r3} <= {6{8'd150}};
end
else begin
    if      (cur_duty_l1 <= (nxt_duty_l1+SPEED) && cur_duty_l1 >= (nxt_duty_l1-SPEED)) cur_duty_l1 <= nxt_duty_l1;
    else if (cur_duty_l1 > nxt_duty_l1) cur_duty_l1 <= cur_duty_l1 - SPEED;
    else if (cur_duty_l1 < nxt_duty_l1) cur_duty_l1 <= cur_duty_l1 + SPEED;
    if      (cur_duty_l2 <= (nxt_duty_l2+SPEED) && cur_duty_l2 >= (nxt_duty_l2-SPEED)) cur_duty_l2 <= nxt_duty_l2;
    else if (cur_duty_l2 > nxt_duty_l2) cur_duty_l2 <= cur_duty_l2 - SPEED;
    else if (cur_duty_l2 < nxt_duty_l2) cur_duty_l2 <= cur_duty_l2 + SPEED;
    if      (cur_duty_l3 <= (nxt_duty_l3+SPEED) && cur_duty_l3 >= (nxt_duty_l3-SPEED)) cur_duty_l3 <= nxt_duty_l3;
    else if (cur_duty_l3 > nxt_duty_l3) cur_duty_l3 <= cur_duty_l3 - SPEED;
    else if (cur_duty_l3 < nxt_duty_l3) cur_duty_l3 <= cur_duty_l3 + SPEED;
    if      (cur_duty_r1 <= (nxt_duty_r1+SPEED) && cur_duty_r1 >= (nxt_duty_r1-SPEED)) cur_duty_r1 <= nxt_duty_r1;
    else if (cur_duty_r1 > nxt_duty_r1) cur_duty_r1 <= cur_duty_r1 - SPEED;
    else if (cur_duty_r1 < nxt_duty_r1) cur_duty_r1 <= cur_duty_r1 + SPEED;
    if      (cur_duty_r2 <= (nxt_duty_r2+SPEED) && cur_duty_r2 >= (nxt_duty_r2-SPEED)) cur_duty_r2 <= nxt_duty_r2;
    else if (cur_duty_r2 > nxt_duty_r2) cur_duty_r2 <= cur_duty_r2 - SPEED;
    else if (cur_duty_r2 < nxt_duty_r2) cur_duty_r2 <= cur_duty_r2 + SPEED;
    if      (cur_duty_r3 <= (nxt_duty_r3+SPEED) && cur_duty_r3 >= (nxt_duty_r3-SPEED)) cur_duty_r3 <= nxt_duty_r3;
    else if (cur_duty_r3 > nxt_duty_r3) cur_duty_r3 <= cur_duty_r3 - SPEED;
    else if (cur_duty_r3 < nxt_duty_r3) cur_duty_r3 <= cur_duty_r3 + SPEED;
end

//Main FSM,read Memory of Action Group,
always @ ( posedge clk or negedge rst_n )//Driven variable:nxt_duty_xx,takeTime,Addr of memory
if(!rst_n) begin
    state <= Sbegin;
end
else begin
    case(state)
        Sbegin: begin
            if ( clk_50Hz_pulse ) begin
                readMemAddr <= AddrMoveForword;
                state <= SreadMem;
            end
            else state <= Sbegin;
        end
        //SupdateAddr
        SreadMem: begin
            //{leftTimes,ActionGroupNo,NC,lastAction,nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} <= memBuffer;
            {nxt_duty_r3,nxt_duty_r2,nxt_duty_r1,nxt_duty_l3,nxt_duty_l2,nxt_duty_l1,ActionGroupNo,NC,lastAction,leftTimes} <= memBuffer;
            state <= Swait4Action;
        end
        Swait4Action: begin
            if ( clk_50Hz_pulse ) begin
                if ( leftTimes > 0 ) begin //the action not finished
                    leftTimes <= leftTimes - 1;
                    state <= Swait4Action;
                end
                else begin // leftTimes == 0,this action is finished
                    state <= SupdateAddr;
                end
            end
            else state <= Swait4Action;
        end
        SupdateAddr: begin
            if (lastAction) begin
                if (runLoopFlag) begin
                    readMemAddr <= AddrMoveForword;
                    state <= SreadMem;
                end
                else begin
                    state <= Sstop;
                end
            end
            else begin
                readMemAddr <= readMemAddr + 1;
                state <= SreadMem;
            end
        end
        Sreset: begin
            {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {6{8'd150}};
            isRunningFlag <= 0;
            state <= Sstop;
        end
        Sstop: begin
            {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {cur_duty_l1,cur_duty_l2,cur_duty_l3,cur_duty_r1,cur_duty_r2,cur_duty_r3};
            isRunningFlag <= 0;
            state <= Sstop;
        end
        default: begin
            state <= Sstop;
        end
    endcase
end

endmodule
