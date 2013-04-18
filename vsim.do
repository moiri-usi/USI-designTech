#create work library
vlib work

#compile the files
vcom -reportprogress 300 -work work ../components/array_t.vhd
vcom -reportprogress 300 -work work ../components/adder.vhd
vcom -reportprogress 300 -work work ../components/mul.vhd
vcom -reportprogress 300 -work work ../components/reg.vhd

vcom -reportprogress 300 -work work ./fir_base.vhd
vcom -reportprogress 300 -work work ./fir_base_wrapper.vhd
vcom -reportprogress 300 -work work ./tb_fir_base.vhd

#start simulation (optimisation off)
vsim -novopt work.tb_fir_base

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fir_base/reset
add wave -noupdate /tb_fir_base/clk
add wave -noupdate -color Gold -format Analog-Interpolated -height 200 -max 2048.0 /tb_fir_base/i
add wave -noupdate -color Red -format Analog-Interpolated -height 200 -max 14000000.0 /tb_fir_base/o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {1 us}

#run the simulation
run 1000 ns

