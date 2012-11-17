transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/Dropbox/DB\ Documents/Heriot-Watt/Year\ 3/Semester\ 1/Systems\ Project/Digital\ and\ Software/Systems-project/Color\ sorter {F:/Dropbox/DB Documents/Heriot-Watt/Year 3/Semester 1/Systems Project/Digital and Software/Systems-project/Color sorter/color.v}

