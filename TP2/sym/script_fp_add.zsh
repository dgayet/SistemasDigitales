ghdl -a ../src/register.vhd ../src/fp_add.vhd ../src/delay_gen.vhd ../src/testbench_adder.vhd
ghdl -s ../src/register.vhd ../src/fp_add.vhd ../src/delay_gen.vhd ../src/testbench_adder.vhd
ghdl -e pf_testbench_add
ghdl -r pf_testbench_add --vcd=pf_testbench_add.vcd
gtkwave pf_testbench_add.vcd