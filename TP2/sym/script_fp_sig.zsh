ghdl -a ../src/fp_mult_significand.vhd ../src/tb_fp_sig.vhd
ghdl -s ../src/fp_mult_significand.vhd ../src/tb_fp_sig.vhd
ghdl -e tb_fp_sig
ghdl -r tb_fp_sig --vcd=tb_fp_sig.vcd --stop-time=1000ns
gtkwave tb_fp_sig.vcd