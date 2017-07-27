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
#set_property -dict { PACKAGE_PIN B16 IOSTANDARD LVCMOS33 } [get_ports sw];	#JPC1
##set_property -dict { PACKAGE_PIN B17 IOSTANDARD LVCMOS33 } [get_ports JPC2];	#JPC2
##set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports JPC3];	#JPC3
#set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports {btn[0]}];	#JPC4
#set_property -dict { PACKAGE_PIN C16 IOSTANDARD LVCMOS33 } [get_ports {btn[1]}];	#JPC7
#set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports {btn[2]}];	#JPC8
#set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports {btn[3]}];	#JPC9
#set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports {btn[4]}];	#JPC10
## Pmod D
#set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports JPD1];	#JPD1
#set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports JPD2];	#JPD2
#set_property -dict { PACKAGE_PIN B13 IOSTANDARD LVCMOS33 } [get_ports JPD3];	#JPD3
#set_property -dict { PACKAGE_PIN B14 IOSTANDARD LVCMOS33 } [get_ports JPD4];	#JPD4
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33 } [ get_ports {DIPsw[3]} ];	#JPD7
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [ get_ports {DIPsw[2]} ];	#JPD8
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [ get_ports {DIPsw[1]} ];	#JPD9
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [ get_ports {DIPsw[0]} ];	#JPD10
