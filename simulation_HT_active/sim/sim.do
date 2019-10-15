if {[file  isdirectory work]} {vdel -all -lib work}
vlib work 
vmap work work

vcom -work work ../HermesOdyssey/Hermes_package.vhd 
vcom -work work ../HermesOdyssey/Hermes_buffer.vhd 
vcom -work work ../HermesOdyssey/Hermes_bufferInfected.vhd 
vcom -work work ../HermesOdyssey/Hermes_crossbar.vhd 
vcom -work work ../HermesOdyssey/Hermes_switchcontrol.vhd 
vcom -work work ../HermesOdyssey/HardwareTrojan.vhd 
vcom -work work ../HermesOdyssey/RouterInfected.vhd

vcom -work work ./tb.vhd

vsim -novopt work.tb

do wave2.do
do shutup.do

run 2000 ns
