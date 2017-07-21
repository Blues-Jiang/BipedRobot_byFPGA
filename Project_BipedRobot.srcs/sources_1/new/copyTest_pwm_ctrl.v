`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/20 18:04:27
// Design Name: 
// Module Name: copyTest_pwm_ctrl
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


module copyTest_pwm_ctrl(clk,rst_n,out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3);
input clk,rst_n;
//input [7:0] data;
output wire out_pwm_l1,out_pwm_l2,out_pwm_l3,out_pwm_r1,out_pwm_r2,out_pwm_r3;//PWM Signal to drive Servos

//Flag List
//reg updateFlag;     //Depend on 50kHz clock.It's a flag to update the duty cycle
reg runLoopFlag;    //If you need to cycle the action group,this flag should be set as 1
reg run1StepFlag;   //Run action group step by step.
reg isRunningFlag;  //
reg setOffsetFlag;

wire clk_100MHz,clk_50kHz,clk_50kHz_pulse;

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
parameter SPEED=8'd5;//Servo move speed. -> LDX-218 -> 4.5бу LDX-227 -> 6.75бу

reg [8:0] curActionGroup;
parameter AddrInit = 9'd0,
    AddrMoveForword = 9'd1,
    AddrMoveBackword = 9'd9,
    AddrTurnLeft = 9'd17,
    AddrTurnRight = 9'd20;
    

clock_100MHz ins_clk_100MHz(
.clk(clk),
.rst_n(rst_n),
.out_100MHz(clk_100MHz)
);

clock_50kHz ins_clk_50kHz(
.clk(clk),
.rst_n(rst_n),
.out_50kHz(clk_50kHz),
.out_50kHz_pulse(clk_50kHz_pulse)
);

//Servo PWM driver module
pwm pwm_l1(.clk(clk_100MHz),.rst(clk_50kHz_pulse),.pwm_duty(cur_duty_l1),.pwm_offset(offset_l1),.pwm_out(out_pwm_l1));
pwm pwm_l2(.clk(clk_100MHz),.rst(clk_50kHz_pulse),.pwm_duty(cur_duty_l2),.pwm_offset(offset_l2),.pwm_out(out_pwm_l2));
pwm pwm_l3(.clk(clk_100MHz),.rst(clk_50kHz_pulse),.pwm_duty(cur_duty_l3),.pwm_offset(offset_l3),.pwm_out(out_pwm_l3));
pwm pwm_r1(.clk(clk_100MHz),.rst(clk_50kHz_pulse),.pwm_duty(cur_duty_r1),.pwm_offset(offset_r1),.pwm_out(out_pwm_r1));
pwm pwm_r2(.clk(clk_100MHz),.rst(clk_50kHz_pulse),.pwm_duty(cur_duty_r2),.pwm_offset(offset_r2),.pwm_out(out_pwm_r2));
pwm pwm_r3(.clk(clk_100MHz),.rst(clk_50kHz_pulse),.pwm_duty(cur_duty_r3),.pwm_offset(offset_r3),.pwm_out(out_pwm_r3)); 

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
.enb(clk_50kHz),
.addrb(readMemAddr),//[8:0]
.doutb(memBuffer)//[63:0],{takeTime,Null,nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3}
);

reg [7:0] counter;
reg [7:0] state;
parameter Sbegin=8'd0,SreadMem=8'd1,Swait4Action=8'd2,SupdateAddr=8'd3,Swait4continue=8'd4,Sreset=8'hfe,Sstop=8'hff;

//Reset other signal
always @ ( negedge rst_n )
begin
    writeData <= 8'd0;
    writeAddr <= 12'd0;
    curActionGroup <= AddrMoveForword;
    runLoopFlag <= 1;    //If you need to cycle the action group,this flag should be set as 1
    run1StepFlag <= 0;   //Run action group step by step.
    isRunningFlag <= 1;  //
    setOffsetFlag <= 0;
end

reg [7:0] offsetState;

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
always @ ( posedge clk_50kHz_pulse or negedge rst_n )//Driven variable:cur_duty_xx
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
            if ( clk_50kHz_pulse ) begin
                readMemAddr <= curActionGroup;
                state <= SreadMem;
            end
            else state <= Sbegin;
        end
        //SupdateAddr
        SreadMem: begin
            //{leftTimes,ActionGroupNo,NC,lastAction,nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} <= memBuffer; //this memory seq is not sequential
            {nxt_duty_r3,nxt_duty_r2,nxt_duty_r1,nxt_duty_l3,nxt_duty_l2,nxt_duty_l1,ActionGroupNo,NC,firstAction,lastAction,leftTimes} <= memBuffer;
            state <= Swait4Action;
        end
        Swait4Action: begin
            if ( clk_50kHz_pulse ) begin
                if ( leftTimes > 0 ) begin //this action is not finished
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
            if(!isRunningFlag) state <= Sstop;
            else begin
                if (lastAction) begin
                    readMemAddr <= curActionGroup;
                    state <= Swait4continue;
                end
                else begin
                    readMemAddr <= readMemAddr + 1;
                    state <= Swait4continue;
                end
            end
        end
        Swait4continue: begin
            if (runLoopFlag)            state <= SreadMem;
            else if (run1StepFlag)  state <= SreadMem;
            else                                 state <= Swait4continue;
        end
        Sreset: begin
            {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {6{8'd150}};
            //isRunningFlag <= 0;
            state <= Sstop;
        end
//        SsetOffset: begin
//            if(setOffsetFlag) begin
//                
//            end
//        end
        Sstop: begin
            if (setOffsetFlag)  {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {6{8'd150}};
            else    {nxt_duty_l1,nxt_duty_l2,nxt_duty_l3,nxt_duty_r1,nxt_duty_r2,nxt_duty_r3} = {cur_duty_l1,cur_duty_l2,cur_duty_l3,cur_duty_r1,cur_duty_r2,cur_duty_r3};
            if (isRunningFlag)  state <= Sstop;
            else    state <= Sbegin;
        end
        default: begin
            state <= Sstop;
        end
    endcase
end

endmodule

module clock_100MHz(clk,rst_n,out_100MHz);
    
input clk,rst_n;
output reg out_100MHz;
    
reg [15:0] counter;
    
always @ (posedge clk or negedge rst_n)
    if (!rst_n)
        begin
            out_100MHz <= 0;
            counter <= 0;
        end
    else
        if (counter == 16'd499) //clk=100MHz
            begin
                out_100MHz <= !out_100MHz;
                counter <= 0;
            end
        else 
            begin
                out_100MHz <= out_100MHz;
                counter <= counter + 1;
            end
            
endmodule

module clock_50kHz(clk,rst_n,out_50kHz,out_50kHz_pulse);

input clk,rst_n;
output reg out_50kHz,out_50kHz_pulse;

reg [31:0] counter;

always @ (posedge clk or negedge rst_n)
    if (!rst_n) begin
        out_50kHz_pulse <= 0;
        out_50kHz <= 0;
        counter <= 0;
    end
    else begin   //clk=100MHz
        if (counter >= 32'd1_999) begin
            counter <= 0;
            out_50kHz_pulse <= 1;
            out_50kHz <= 1;
        end
        else begin
            if (counter < 32'd1_000)        out_50kHz <= 1;
            else if (counter < 32'd2_000)   out_50kHz <= 0;
            counter <= counter + 1;
            out_50kHz_pulse <= 0;
        end
    end
        
endmodule
