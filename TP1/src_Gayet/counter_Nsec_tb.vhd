library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_Nsec_tb is
end;

architecture behavioral of counter_Nsec_tb is
    constant NCOUNT : unsigned := to_unsigned(30, 5);
    signal clk_i : std_logic := '0';
    signal rst_i : std_logic := '1';
    signal is_max: std_logic;
begin

    clk_i <= not clk_i after 1 ns;
    rst_i <= '0' after 3 ns;

    DUT: entity work.counter_Nsec(behavioral)
        port map (
            clk_i => clk_i,
            rst_i => rst_i,
            Ncount => NCOUNT,
            is_max => is_max
        );
end architecture;
