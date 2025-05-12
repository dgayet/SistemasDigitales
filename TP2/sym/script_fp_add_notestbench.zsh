ghdl -a ../src/register.vhd ../src/fp_add.vhd ../src/tb_fp_add.vhd
ghdl -s ../src/register.vhd ../src/fp_add.vhd ../src/tb_fp_add.vhd
ghdl -e tb_add
ghdl -r tb_add --vcd=tb_add.vcd --stop-time=1000ns
gtkwave tb_add.vcd