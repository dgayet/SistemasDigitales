library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fp_mult is
end;

architecture behavioral of tb_fp_mult is
    constant NF : natural := 21;
    constant NE : natural := 7;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';
    
    signal x : std_logic_vector(NF+NE downto 0) := std_logic_vector(to_unsigned(64371372, NF+NE+1));
    signal y : std_logic_vector(NF+NE downto 0) := std_logic_vector(to_unsigned(27083972, NF+NE+1));
    signal z : std_logic_vector(NF+NE downto 0);
    signal z_int : integer;

begin
    clk <= not clk after 10 ns;
    rst <= '0' after 1 ns;
    z_int <= to_integer(unsigned(z));

    MULT_INST :  entity work.fp_multiplication(behavioral)
                    generic map (
                        NE => NE,
                        NF => NF
                    )
                    port map (
                        clk => clk,
                        rst => rst,
                        x => x,
                        y => y,
                        z => z
                    );    
end;