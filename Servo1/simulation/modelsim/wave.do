onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab2/clk
add wave -noupdate /lab2/lu
add wave -noupdate -color Green /lab2/pwm
add wave -noupdate /lab2/PWM_length_first
add wave -noupdate /lab2/PWM_length_second
add wave -noupdate /lab2/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {10500 ns}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 20ns -dutycycle 50 -starttime 0us -endtime 10us sim:/lab2/clk 
wave create -driver freeze -pattern constant -value 1 -starttime 0us -endtime 10us sim:/lab2/lu 
WaveCollapseAll -1
wave clipboard restore
