transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/AddRoundKey.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/SubBytes.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/InvShiftRows.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/InvMixColumns.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/hexdriver.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/AES_Control.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/KeyExpansion.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/InvSubHelper.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/AES.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/avalon_aes_interface.sv}
vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/lab9_top.sv}

vlog -sv -work work +incdir+C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test {C:/Users/Mehul/Documents/GitHub/ECE-385/lab9test/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 5000 ns
