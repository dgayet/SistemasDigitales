ghdl -a --std=08 register.vhd add_sub_logic.vhd cordic_unrolled_top.vhd tb_cordic_unrolled.vhd
ghdl -s --std=08 register.vhd add_sub_logic.vhd cordic_unrolled_top.vhd tb_cordic_unrolled.vhd
ghdl -e tb_cordic_unrolled
ghdl -r tb_cordic_unrolled --vcd=tb_cordic_unrolled.vcd --stop-time=1000ns
gtkwave tb_cordic_unrolled.vcd