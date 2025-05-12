ghdl -a ../src/fp_add_exponent.vhd ../src/tb_fp_add_exp.vhd
ghdl -s ../src/fp_add_exponent.vhd ../src/tb_fp_add_exp.vhd
ghdl -e tb_add_exponent
ghdl -r tb_add_exponent --vcd=tb_add_exponent.vcd --stop-time=200ns
gtkwave tb_add_exponent.vcd