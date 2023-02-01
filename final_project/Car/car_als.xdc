set_property IOSTANDARD LVCMOS18 [get_ports {left[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {left[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {right[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {right[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports echo]
set_property IOSTANDARD LVCMOS18 [get_ports left_motor]
set_property IOSTANDARD LVCMOS18 [get_ports left_signal]
set_property IOSTANDARD LVCMOS18 [get_ports mid_signal]
set_property IOSTANDARD LVCMOS18 [get_ports right_motor]
set_property IOSTANDARD LVCMOS18 [get_ports right_signal]
set_property IOSTANDARD LVCMOS18 [get_ports rst]
set_property IOSTANDARD LVCMOS18 [get_ports trig]
set_property IOSTANDARD LVCMOS18 [get_ports turn_back]
set_property PACKAGE_PIN L2 [get_ports {left[1]}]
set_property PACKAGE_PIN J2 [get_ports {left[0]}]
set_property PACKAGE_PIN K2 [get_ports {right[1]}]
set_property PACKAGE_PIN H2 [get_ports {right[0]}]
set_property PACKAGE_PIN C16 [get_ports echo] 
set_property PACKAGE_PIN A16 [get_ports right_signal]
set_property PACKAGE_PIN B15 [get_ports mid_signal]
set_property PACKAGE_PIN B16 [get_ports left_signal]
set_property PACKAGE_PIN H1 [get_ports right_motor]
set_property PACKAGE_PIN J1 [get_ports left_motor] 
set_property PACKAGE_PIN U18 [get_ports rst]

set_property PACKAGE_PIN C15 [get_ports trig] 
set_property PACKAGE_PIN P3 [get_ports turn_back]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]


set_property IOSTANDARD LVCMOS18 [get_ports cs]
set_property PACKAGE_PIN K3 [get_ports cs]
set_property IOSTANDARD LVCMOS18 [get_ports miso]
set_property PACKAGE_PIN M1 [get_ports miso]
set_property IOSTANDARD LVCMOS18 [get_ports spi_sclk]
set_property PACKAGE_PIN N1 [get_ports spi_sclk]

set_property IOSTANDARD LVCMOS18 [get_ports cs_mon]
set_property IOSTANDARD LVCMOS18 [get_ports Din_mon]
set_property IOSTANDARD LVCMOS18 [get_ports sclk_mon]
set_property PACKAGE_PIN J3 [get_ports sclk_mon]
set_property PACKAGE_PIN L3 [get_ports cs_mon]
set_property PACKAGE_PIN M2 [get_ports Din_mon]

set_property IOSTANDARD LVCMOS18 [get_ports w3]
set_property IOSTANDARD LVCMOS18 [get_ports w7]
set_property PACKAGE_PIN N3 [get_ports w3]
set_property PACKAGE_PIN P1 [get_ports w7]
