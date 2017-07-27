## Clock & Reset
set_property  -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports clk];
#	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk];
set_property  -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports rst_n];

### RS232 Bluetooth Module
#set_property -dict { PACKAGE_PIN R5 IOSTANDARD LVCMOS33 } [get_ports RS232_rx];
#set_property -dict { PACKAGE_PIN R3 IOSTANDARD LVCMOS33 } [get_ports RS232_tx];

## The Ultrasonic Ranging Module
#set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports echo];
#set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports trig];

### 4-bits 7-segment Display
#set_property -dict { PACKAGE_PIN A9 IOSTANDARD LVCMOS33 }  [get_ports {sel[3]}];
#set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports {sel[2]}];
#set_property -dict { PACKAGE_PIN C14 IOSTANDARD LVCMOS33 } [get_ports {sel[1]}];
#set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports {sel[0]}];
#set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports {data[0]}];
#set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports {data[1]}];
#set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33 } [get_ports {data[2]}];
#set_property -dict { PACKAGE_PIN F14 IOSTANDARD LVCMOS33 } [get_ports {data[3]}];
#set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports {data[4]}];
#set_property -dict { PACKAGE_PIN D13 IOSTANDARD LVCMOS33 } [get_ports {data[5]}];
#set_property -dict { PACKAGE_PIN D15 IOSTANDARD LVCMOS33 } [get_ports {data[6]}];
#set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33 } [get_ports {data[7]}];

## 24C02 
#set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports scl]; #An_J20
#set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports sda]; #An_J19
## 3-Pins Output for PWM
set_property -dict { PACKAGE_PIN P2 IOSTANDARD LVCMOS33 } [get_ports out_pwm_l3]; #An_J30
set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports out_pwm_l2]; #An_J31
set_property -dict { PACKAGE_PIN M6 IOSTANDARD LVCMOS33 } [get_ports out_pwm_l1]; #An_J32
set_property -dict { PACKAGE_PIN N4 IOSTANDARD LVCMOS33 } [get_ports out_pwm_r1]; #An_J34
set_property -dict { PACKAGE_PIN P3 IOSTANDARD LVCMOS33 } [get_ports out_pwm_r2]; #An_J35
set_property -dict { PACKAGE_PIN K6 IOSTANDARD LVCMOS33 } [get_ports out_pwm_r3]; #An_J36
## EES-327 The upper row
#set_property -dict { PACKAGE_PIN U3  IOSTANDARD LVCMOS33 } [get_ports An_J27]; #An_J27
#set_property -dict { PACKAGE_PIN R6  IOSTANDARD LVCMOS33 } [get_ports An_J28]; #An_J28
#set_property -dict { PACKAGE_PIN P5  IOSTANDARD LVCMOS33 } [get_ports An_J29]; #An_J29
#set_property -dict { PACKAGE_PIN P2  IOSTANDARD LVCMOS33 } [get_ports An_J30]; #An_J30
#set_property -dict { PACKAGE_PIN N1  IOSTANDARD LVCMOS33 } [get_ports An_J31]; #An_J31
#set_property -dict { PACKAGE_PIN M6  IOSTANDARD LVCMOS33 } [get_ports An_J32]; #An_J32
#set_property -dict { PACKAGE_PIN G1  IOSTANDARD LVCMOS33 } [get_ports An_J33]; #An_J33
#set_property -dict { PACKAGE_PIN N4  IOSTANDARD LVCMOS33 } [get_ports An_J34]; #An_J34
#set_property -dict { PACKAGE_PIN P3  IOSTANDARD LVCMOS33 } [get_ports An_J35]; #An_J35
#set_property -dict { PACKAGE_PIN K6  IOSTANDARD LVCMOS33 } [get_ports An_J36]; #An_J36
## EES-327 The lower row
#set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports An_J12]; #An_J12
#set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports An_J11]; #An_J11
#set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports An_J10]; #An_J10
#set_property -dict { PACKAGE_PIN R11 IOSTANDARD LVCMOS33 } [get_ports An_J9];  #An_J9
#set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports An_J24]; #An_J24
#set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports An_J23]; #An_J23
#set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports An_J22]; #An_J22
#set_property -dict { PACKAGE_PIN L15 IOSTANDARD LVCMOS33 } [get_ports An_J21]; #An_J21
#set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports An_J20]; #An_J20
#set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports An_J19]; #An_J19

#LED List
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports {LED[0]}];
set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports {LED[1]}];
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports {LED[2]}];
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports {LED[3]}];
set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports {LED[4]}];
set_property -dict { PACKAGE_PIN A8  IOSTANDARD LVCMOS33 } [get_ports {LED[5]}];
set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33 } [get_ports {LED[6]}];
set_property -dict { PACKAGE_PIN C10 IOSTANDARD LVCMOS33 } [get_ports {LED[7]}];

## Pmod List
## Pmod A
#set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports JPA1];	#JPA1
#set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports JPA2];	#JPA2
set_property -dict { PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports sw];	#JPA3
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports {btn[0]}];	#JPA4
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports {btn[1]}];	#JPA7
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [get_ports {btn[2]}];	#JPA8
set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports {btn[3]}];	#JPA9
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports {btn[4]}];	#JPA10
## Pmod B
#set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports JPB1];	#JPB1
#set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports JPB2];	#JPB2
#set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports JPB3];	#JPB3
#set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports JPB4];	#JPB4
#set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports JPB7];	#JPB7
#set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports JPB8];	#JPB8
#set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports JPB9];	#JPB9
#set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports JPB10];	#JPB10
## Pmod C
#set_property -dict { PACKAGE_PIN B16 IOSTANDARD LVCMOS33 } [get_ports JPC1];	#JPC1
#set_property -dict { PACKAGE_PIN B17 IOSTANDARD LVCMOS33 } [get_ports JPC2];	#JPC2
#set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports JPC3];	#JPC3
#set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports JPC4];	#JPC4
#set_property -dict { PACKAGE_PIN C16 IOSTANDARD LVCMOS33 } [get_ports JPC7];	#JPC7
#set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports JPC8];	#JPC8
#set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports JPC9];	#JPC9
#set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports JPC10];	#JPC10
## Pmod D
#set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports JPD1];	#JPD1
#set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports JPD2];	#JPD2
#set_property -dict { PACKAGE_PIN B13 IOSTANDARD LVCMOS33 } [get_ports JPD3];	#JPD3
#set_property -dict { PACKAGE_PIN B14 IOSTANDARD LVCMOS33 } [get_ports JPD4];	#JPD4
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33 } [get_ports {DIPsw[3]}];	#JPD7
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [get_ports {DIPsw[2]}];	#JPD8
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [get_ports {DIPsw[1]}];	#JPD9
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [get_ports {DIPsw[0]}];	#JPD10

