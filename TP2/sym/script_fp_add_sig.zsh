ghdl -a ../src/fp_add_significand.vhd ../src/tb_fp_add_sig.vhd
ghdl -s ../src/fp_add_significand.vhd ../src/tb_fp_add_sig.vhd
ghdl -e tb_add_significand
ghdl -r tb_add_significand --vcd=tb_add_significand.vcd
gtkwave tb_add_significand.vcd