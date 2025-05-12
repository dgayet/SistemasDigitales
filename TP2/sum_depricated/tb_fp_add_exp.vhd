library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_add_exponent is
end;


architecture behavioral of tb_add_exponent is
    constant NE : natural := 7;
    signal Ex : std_logic_vector(NE-1 downto 0) := "0000111";
    signal Ey : std_logic_vector(NE-1 downto 0) := "0011001";
    signal is_0 : std_logic := '0';
    signal index : integer := 0;
    signal saturation : std_logic_vector(1 downto 0);
    signal exp_diff : std_logic_vector(NE downto 0);
    signal Ez : std_logic_vector(NE-1 downto 0);
begin 

    index <= -1 after 10000 ns, 0 after 20000 ns;
    Ex <= "0001000" after 10000 ns;
    Ey <= "0001000" after 10000 ns;

    EXP : entity work.add_exponent(behavioral)
        generic map (
            NE => NE
        )
        port map (
            Ex => Ex,
            Ey => Ey,
            is_0 => is_0,
            index => index,
            saturation => saturation,
            exp_diff => exp_diff,
            Ez => Ez
        );
end;