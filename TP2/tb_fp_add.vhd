library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_add is
end;

architecture behavioral of tb_add is
    constant TCK: time:= 20 ns; 
    constant NE : natural := 7;
    constant NF : natural := 21;

    signal clk: std_logic:= '0';
    signal rst: std_logic:= '1';

    signal add_sub : std_logic := '0';
    signal x : std_logic_vector(NF+NE downto 0) := std_logic_vector(to_unsigned(344186440,NF+NE+1));
    signal y : std_logic_vector(NF+NE downto 0) := std_logic_vector(to_unsigned(76253588,NF+NE+1));
    signal z : std_logic_vector(NF+NE downto 0);


begin 
     -- Generacion del clock y rst del sistema
    clk <= not(clk) after TCK/2; -- reloj
    rst <= '0' after 1 ns;

    add_sub <= '1' after 10000 ns;

    ADD : entity work.fp_add(behavioral)
        generic map (
            NE => NE,
            NF => NF
        )
        port map (
            clk => clk,
            rst => rst,
            add_sub => add_sub,
            x => x,
            y => y,
            z => z
        );
end;