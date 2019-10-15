
clear -all


#set DESIGN RouterInfected

# analyze the design
analyze -vhdl  ../HermesOdyssey/Hermes_package.vhd 
analyze -vhdl  ../HermesOdyssey/Hermes_buffer.vhd 
analyze -vhdl  ../HermesOdyssey/Hermes_bufferInfected.vhd 
analyze -vhdl  ../HermesOdyssey/Hermes_crossbar.vhd 
analyze -vhdl  ../HermesOdyssey/Hermes_switchcontrol.vhd 
analyze -vhdl  ../HermesOdyssey/HardwareTrojan.vhd 
analyze -vhdl  ../HermesOdyssey/RouterInfected.vhd
analyze -vhdl  ../HermesOdyssey/RouterInfected_wrapper.vhd

# Analyze property files
analyze -sva bindings.sv hermes_prop.sv 

#set_evaluate_properties_on_formal_reset off
#set_analyze_libunboundsearch true

# elaborate the design, point to the design top level
elaborate -vhdl -top {RouterInfected_wrapper}

#connect -list

# Set up Clocks and Resets
# Hermes' SwitchControl module uses both clock edges !!! it requires -both_edges
clock clock -factor 1 -phase 1
reset -expression {reset = 1};
#get_reset_info

sanity_check -verbose -analyze all

# get designs statistics
get_design_info
#Statistics [for instance "sanduiche"]
#---------------------------
# Flops:         2 (10) (0 property flop bits)
# Latches:       0 (0)
# Gates:         80 (501)
# Nets:          95
# Ports:         12
# RTL Lines:     113
# RTL Instances: 1
# Embedded Assumptions: 0
# Embedded Assertions:  0
# Embedded Covers:      0

# Prove properties
# 1st pass: Quick validation of properties with default engines
#set_max_trace_length 150
prove -all

#check_assumptions -minimize -conflict -task <embedded>

# Report proof results
report



