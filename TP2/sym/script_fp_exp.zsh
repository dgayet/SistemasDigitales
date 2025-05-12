ghdl -a ../src/fp_mult_exponent.vhd ../src/tb_fp_exp.vhd
ghdl -s ../src/fp_mult_exponent.vhd ../src/tb_fp_exp.vhd
ghdl -e tb_fp_exp
ghdl -r tb_fp_exp --vcd=tb_fp_exp.vcd --stop-time=1000ns
gtkwave tb_fp_exp.vcd