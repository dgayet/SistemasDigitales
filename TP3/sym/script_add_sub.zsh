ghdl -a ../src/cordic/add_sub_logic.vhd ../src/cordic/tb_add_sub_logic.vhd
ghdl -s ../src/cordic/add_sub_logic.vhd ../src/cordic/tb_add_sub_logic.vhd
ghdl -e tb_add_sub_logic
ghdl -r tb_add_sub_logic --vcd=tb_add_sub_logic.vcd --stop-time=1000ns
gtkwave tb_add_sub_logic.vcd