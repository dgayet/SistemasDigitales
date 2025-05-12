library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_1sec_tb is
end;

architecture behavioral of counter_1sec_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal is_1sec : std_logic;
    constant NCYCLES : natural := 5;

begin
    clk <= not clk after 2 ns;
    rst <= '0' after 3 ns;

    COUNTER_1SEC: entity work.counter_1sec(behavioral)
        generic map (
            Ncycles => NCYCLES
        )
        port map (
            clk_i => clk,
            rst_i => rst,
            sec_1 => is_1sec
        );
end architecture;