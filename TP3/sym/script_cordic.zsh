ghdl -a ../src/cordic/register.vhd ../src/cordic/counter_N.vhd ../src/cordic/add_sub_logic.vhd ../src/cordic/cordic_stage.vhd ../src/cordic/pre_cordic.vhd ../src/cordic/cordic_top.vhd  ../src/cordic/tb_cordic.vhd
ghdl -s ../src/cordic/register.vhd ../src/cordic/counter_N.vhd ../src/cordic/add_sub_logic.vhd ../src/cordic/cordic_stage.vhd ../src/cordic/pre_cordic.vhd ../src/cordic/cordic_top.vhd  ../src/cordic/tb_cordic.vhd
ghdl -e tb_cordic
ghdl -r tb_cordic --vcd=tb_cordic.vcd --stop-time=1000ns
gtkwave tb_cordic.vcd