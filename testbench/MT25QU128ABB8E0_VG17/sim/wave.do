onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Testbench/DUT/Vcc
add wave -noupdate /Testbench/DUT/HOLD_DQ3
add wave -noupdate /Testbench/DUT/Vpp_W_DQ2
add wave -noupdate /Testbench/DUT/DQ1
add wave -noupdate /Testbench/DUT/DQ0
add wave -noupdate /Testbench/DUT/S
add wave -noupdate /Testbench/DUT/C_
add wave -noupdate /Testbench/DUT/RESET
add wave -noupdate /Testbench/DUT/RESET2
add wave -noupdate -radix ascii /Testbench/DUT/cmdRecName
add wave -noupdate /Testbench/DUT/cmdLatched
add wave -noupdate /Testbench/DUT/addrLatched
add wave -noupdate /Testbench/DUT/dataLatched
add wave -noupdate /Testbench/DUT/dummyLatched
add wave -noupdate /Testbench/DUT/stat/SR
add wave -noupdate -radix hexadecimal /Testbench/DUT/VolatileReg/VCR
add wave -noupdate /Testbench/DUT/fO
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8530000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 284
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 3
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
WaveRestoreZoom {8432428 ps} {8627573 ps}
