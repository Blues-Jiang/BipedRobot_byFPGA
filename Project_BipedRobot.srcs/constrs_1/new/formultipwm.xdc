## Clock & Reset
set_property  -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports clk];
#	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk];
set_property  -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports rst_n];

### RS232
#set_property -dict { PACKAGE_PIN R5 IOSTANDARD LVCMOS33 } [get_ports Rs232_rx];
#set_property -dict { PACKAGE_PIN R3 IOSTANDARD LVCMOS33 } [get_ports Rs232_tx];

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

## 3-Pins Output for PWM
## EES-327 The upper row
set_property -dict { PACKAGE_PIN U3 IOSTANDARD LVCMOS33 } [get_ports out_pwm_l3]; #An_J27
set_property -dict { PACKAGE_PIN R6 IOSTANDARD LVCMOS33 } [get_ports out_pwm_l2]; #An_J28
set_property -dict { PACKAGE_PIN P5 IOSTANDARD LVCMOS33 } [get_ports out_pwm_l1]; #An_J29
#set_property -dict { PACKAGE_PIN P2 IOSTANDARD LVCMOS33 } [get_ports An_J30]; #An_J30
#set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports An_J31]; #An_J31
#set_property -dict { PACKAGE_PIN M6 IOSTANDARD LVCMOS33 } [get_ports An_J32]; #An_J32
#set_property -dict { PACKAGE_PIN G1 IOSTANDARD LVCMOS33 } [get_ports An_J33]; #An_J33
set_property -dict { PACKAGE_PIN N4 IOSTANDARD LVCMOS33 } [get_ports out_pwm_r1]; #An_J34
set_property -dict { PACKAGE_PIN P3 IOSTANDARD LVCMOS33 } [get_ports out_pwm_r2]; #An_J35
set_property -dict { PACKAGE_PIN K6 IOSTANDARD LVCMOS33 } [get_ports out_pwm_r3]; #An_J36
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

#set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports {LED[0]}];
#set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports {LED[1]}];
#set_property -dict { PACKAGE_PIN C9 IOSTANDARD LVCMOS33 } [get_ports {LED[2]}];
#set_property -dict { PACKAGE_PIN B9 IOSTANDARD LVCMOS33 } [get_ports {LED[3]}];
#set_property -dict { PACKAGE_PIN B8 IOSTANDARD LVCMOS33 } [get_ports {LED[4]}];
#set_property -dict { PACKAGE_PIN A8 IOSTANDARD LVCMOS33 } [get_ports {LED[5]}];
#set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33 } [get_ports {LED[6]}];
#set_property -dict { PACKAGE_PIN C10 IOSTANDARD LVCMOS33 } [get_ports {LED[7]}];
