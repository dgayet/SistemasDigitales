ghdl -a ../src/register.vhd ../src/fp_mult_exponent.vhd ../src/fp_mult_significand.vhd ../src/fp_multiplication.vhd ../src/delay_gen.vhd ../src/testbench_mult.vhd
ghdl -s ../src/register.vhd ../src/fp_mult_exponent.vhd ../src/fp_mult_significand.vhd ../src/fp_multiplication.vhd ../src/delay_gen.vhd ../src/testbench_mult.vhd
ghdl -e pf_testbench
ghdl -r pf_testbench --vcd=pf_testbench.vcd
gtkwave pf_testbench.vcd