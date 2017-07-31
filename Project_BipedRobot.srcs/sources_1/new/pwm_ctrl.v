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


module pwm_ctrl(clk,rst_n,distance,ActionGroupCtrl,isRunningFlag,runLoopFlag,run1StepFlag,resetFlag,out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3,clk_int);
input clk,rst_n;
//input [7:0] data;
output wire out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3;//PWM Signal to drive Servos

input [2:0] ActionGroupCtrl;
input [23:0] distance;
wire out_of_distance;   //距离过远标志
wire close_distance;    //距离过近标志
//Flag List
//reg updateFlag;     //Depend on 50Hz clock.It's a flag to update the duty cycle
input runLoopFlag;    //If you need to cycle the action group,this flag should be set as 1
input run1StepFlag;   //Run action group step by step.
input isRunningFlag;  //
//input setOffsetFlag;
input resetFlag;
reg onceOffFlag;

wire clk_100kHz,clk_50Hz,clk_50Hz_pulse;

output wire clk_int;
assign clk_int = clk_50Hz_pulse;

reg [7:0] cur_duty_l1,cur_duty_l2,cur_duty_l3,cur_duty_r1,cur_duty_r2,cur_duty_r3;//Duty Cycle of Servos  ->  Current State
reg [7:0] nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3;//Duty Cycle of Servos  ->  Next State from Action Group
reg [7:0] leftTimes;
//8-bit in Mem 
reg [3:0] ActionGroupNo;
reg [1:0] NC;
reg firstAction,lastAction;
wire [63:0] memBuffer;
reg [7:0] offset_l1,offset_l2,offset_l3,offset_r1,offset_r2,offset_r3;//Offset correction signal of Servos

reg [8:0] readMemAddr;
parameter SPEED=8'd5;//Servo move speed. -> LDX-218 -> 4.5° LDX-227 -> 6.75°

reg [8:0] curActionGroup;
parameter AddrInit = 9'd0,
    AddrMoveForword = 9'd1,
    AddrMoveBackword = 9'd9,
    AddrTurnLeft = 9'd17,
    AddrTurnRight = 9'd20,
    AddrWelcome = 9'd24;

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
reg memEn;

//Menery of Action Group
blk_mem_gen_0 ins_ActionGroupMem(
//Port A writter
.clka(clk),
.ena(1'd0),
.wea(1'd0),
.addra(writeAddr),//[11:0]
.dina(writeData),//[7:0]
//Port B reader
.clkb(clk),
.enb(memEn),
.addrb(readMemAddr),//[8:0]
.doutb(memBuffer)//[63:0],{takeTime,Null,nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3}
);

reg [7:0] counter;
reg [7:0] state;
parameter Sbegin=8'd0,SreadMem=8'd1,Swait4Action=8'd2,SupdateAddr=8'd3,Swait4continue=8'd4,Sbuffer1=8'd5,Sbuffer2=8'd6,Sreset=8'hfe,Sstop=8'hff;

//Reset other signal
always @ ( negedge rst_n )
begin
    writeData <= 8'd0;
    writeAddr <= 12'd0;
end

reg [7:0] offsetState;

//It's for offset signal,the offset value is changeable
always @ (posedge clk or negedge rst_n )
if(!rst_n) begin
    {offset_l1,offset_l2,offset_l3,offset_r1,offset_r2,offset_r3} <= {6{8'd150}};
end
//else begin
//    if(!isRunningFlag) begin
        
//    end
//end

assign out_of_distance = (distance[19:12] > 8'b00110000)?1'b1:1'b0;
assign close_distance  = (distance[19:12] < 8'b00001100)?1'b1:1'b0;

always @ ( posedge clk or negedge rst_n )
if (!rst_n) begin
    curActionGroup <= AddrInit;
end
else begin
    case(ActionGroupCtrl)
        3'b001: curActionGroup <= AddrMoveForword;
        3'b010: curActionGroup <= AddrMoveBackword;
        3'b011: begin //keep distance
            if(out_of_distance)     curActionGroup <= AddrMoveForword;
            else if(close_distance) curActionGroup <= AddrMoveBackword;
            else                    curActionGroup <= AddrInit;
        end
        3'b100: begin
            curActionGroup <= AddrWelcome;
        end
        //3'b101: curActionGroup <= AddrKick;
        //3'b110: curActionGroup <= AddrSlide;
        default:curActionGroup <= AddrInit;
    endcase
end




//Update Servo State(cur_pwm <= nxt_pwm)
always @ ( posedge clk_50Hz_pulse )//Driven variable:cur_duty_xx
begin
    if      (nxt_duty_l1 > 250 || nxt_duty_l1 < 50) cur_duty_l1 <= cur_duty_l1;
    else if (cur_duty_l1 <= (nxt_duty_l1+SPEED) && cur_duty_l1 >= (nxt_duty_l1-SPEED)) cur_duty_l1 <= nxt_duty_l1;
    else if (cur_duty_l1 > nxt_duty_l1) cur_duty_l1 <= cur_duty_l1 - SPEED;
    else if (cur_duty_l1 < nxt_duty_l1) cur_duty_l1 <= cur_duty_l1 + SPEED;
    if      (nxt_duty_l2 > 250 || nxt_duty_l2 < 50) cur_duty_l2 <= cur_duty_l2;
    else if (cur_duty_l2 <= (nxt_duty_l2+SPEED) && cur_duty_l2 >= (nxt_duty_l2-SPEED)) cur_duty_l2 <= nxt_duty_l2;
    else if (cur_duty_l2 > nxt_duty_l2) cur_duty_l2 <= cur_duty_l2 - SPEED;
    else if (cur_duty_l2 < nxt_duty_l2) cur_duty_l2 <= cur_duty_l2 + SPEED;
    if      (nxt_duty_l3 > 250 || nxt_duty_l3 < 50) cur_duty_l3 <= cur_duty_l3;
    else if (cur_duty_l3 <= (nxt_duty_l3+SPEED) && cur_duty_l3 >= (nxt_duty_l3-SPEED)) cur_duty_l3 <= nxt_duty_l3;
    else if (cur_duty_l3 > nxt_duty_l3) cur_duty_l3 <= cur_duty_l3 - SPEED;
    else if (cur_duty_l3 < nxt_duty_l3) cur_duty_l3 <= cur_duty_l3 + SPEED;
    if      (nxt_duty_r1 > 250 || nxt_duty_r1 < 50) cur_duty_r1 <= cur_duty_r1;
    else if (cur_duty_r1 <= (nxt_duty_r1+SPEED) && cur_duty_r1 >= (nxt_duty_r1-SPEED)) cur_duty_r1 <= nxt_duty_r1;
    else if (cur_duty_r1 > nxt_duty_r1) cur_duty_r1 <= cur_duty_r1 - SPEED;
    else if (cur_duty_r1 < nxt_duty_r1) cur_duty_r1 <= cur_duty_r1 + SPEED;
    if      (nxt_duty_r2 > 250 || nxt_duty_r2 < 50) cur_duty_r2 <= cur_duty_r2;
    else if (cur_duty_r2 <= (nxt_duty_r2+SPEED) && cur_duty_r2 >= (nxt_duty_r2-SPEED)) cur_duty_r2 <= nxt_duty_r2;
    else if (cur_duty_r2 > nxt_duty_r2) cur_duty_r2 <= cur_duty_r2 - SPEED;
    else if (cur_duty_r2 < nxt_duty_r2) cur_duty_r2 <= cur_duty_r2 + SPEED;
    if      (nxt_duty_r3 > 250 || nxt_duty_r3 < 50) cur_duty_r3 <= cur_duty_r3;
    else if (cur_duty_r3 <= (nxt_duty_r3+SPEED) && cur_duty_r3 >= (nxt_duty_r3-SPEED)) cur_duty_r3 <= nxt_duty_r3;
    else if (cur_duty_r3 > nxt_duty_r3) cur_duty_r3 <= cur_duty_r3 - SPEED;
    else if (cur_duty_r3 < nxt_duty_r3) cur_duty_r3 <= cur_duty_r3 + SPEED;
end

//Main FSM,read Memory of Action Group,
always @ ( posedge clk or negedge rst_n )//Driven variable:nxt_duty_xx,takeTime,Addr of memory
if(!rst_n) begin
    state <= Sstop;
    onceOffFlag <= 0;
    memEn <= 0;
end
else begin
    case(state)
        Sbegin: begin
            if ( clk_50Hz_pulse ) begin
                memEn <= 1;
                readMemAddr <= curActionGroup;
                state <= Sbuffer1;
            end
            else state <= Sbegin;
        end
        //SupdateAddr
        Sbuffer1: begin
            state <= SreadMem;
        end
        SreadMem: begin
            //{leftTimes,ActionGroupNo,NC,lastAction,nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} <= memBuffer; //this memory seq is not sequential
            {nxt_duty_r3,nxt_duty_r2,nxt_duty_r1,nxt_duty_l3,nxt_duty_l2,nxt_duty_l1,ActionGroupNo,NC,firstAction,lastAction,leftTimes} <= memBuffer;
            memEn <= 0;
            state <= Swait4Action;
        end
        Swait4Action: begin
            if ( clk_50Hz_pulse ) begin
                if ( leftTimes > 0 ) begin //this action is not finished
                    leftTimes <= leftTimes - 1;
                    state <= Swait4Action;
                end
                else begin // leftTimes == 0,this action is finished
                    memEn <= 1;
                    state <= SupdateAddr;
                end
            end
            else state <= Swait4Action;
        end
        SupdateAddr: begin
            if(!isRunningFlag) state <= Sstop;
            else begin
                if (lastAction) begin
                    readMemAddr <= curActionGroup;
                    state <= Sbuffer2;
                end
                else begin
                    readMemAddr <= readMemAddr + 1;
                    state <= Sbuffer2;
                end
            end
        end
        Sbuffer2: begin
            state <= Swait4continue;
        end
        Swait4continue: begin
            if (runLoopFlag)        state <= SreadMem;
            else if (run1StepFlag)  state <= SreadMem;
            else                    state <= Swait4continue;
        end
        Sreset: begin
            {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {6{8'd150}};
            //isRunningFlag <= 0;
            if (isRunningFlag)  state <= Sbegin;
            else                state <= Sreset;
        end
//        SsetOffset: begin
//            if(setOffsetFlag) begin
//                
//            end
//        end
        Sstop: begin
            //if (setOffsetFlag)  {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {6{8'd150}};
            {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {cur_duty_l1,cur_duty_l2,cur_duty_l3,cur_duty_r1,cur_duty_r2,cur_duty_r3};
            if (isRunningFlag)  state <= Sbegin;
            else if(resetFlag)  state <= Sreset;
            else                state <= Sstop;
        end
        default: begin
            state <= Sstop;
        end
    endcase
end

endmodule
