onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/router/address
add wave -noupdate /tb/router/clock
add wave -noupdate /tb/router/reset
add wave -noupdate -expand /tb/router/rx
add wave -noupdate -expand /tb/router/data_in
add wave -noupdate -expand /tb/router/FWest/buf
add wave -noupdate -expand /tb/router/credit_o
add wave -noupdate -expand /tb/router/tx
add wave -noupdate -expand /tb/router/data_out
add wave -noupdate -expand /tb/router/credit_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 201
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1050 ns}
