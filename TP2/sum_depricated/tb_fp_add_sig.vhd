library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_add_significand is
end;


architecture behavioral of tb_add_significand is
    constant NE: integer := 7;
    constant NF: integer :=21;
    signal Fx: std_logic_vector(NF-1 downto 0) := "110100111101000011000";
    signal Fy: std_logic_vector(NF-1 downto 0) := "001101000101001010110";
    signal is_0: std_logic := '1';
    signal saturation: std_logic_vector(1 downto 0) := "00";
    signal exp_diff: std_logic_vector(NE downto 0) := std_logic_vector(to_signed(-18, NE+1));
    signal flag_2c: std_logic_vector(1 downto 0) := "00";
    signal Fz: std_logic_vector(NF-1 downto 0);
    signal index: integer;

begin
    is_0 <= '0' after 20000 ns;
    exp_diff <= std_logic_vector(to_signed(0, NE+1)) after 10000 ns;
    Fx <= std_logic_vector(to_unsigned(37680, NF)) after 10000 ns;
    Fy <= std_logic_vector(to_unsigned(37660, NF)) after 10000 ns;
    flag_2c <= "01" after 10000 ns;

    SIG: entity work.add_significand(behavioral)
            generic map(
                NF => NF,
                NE => NE
            )
            port map (
                Fx => Fx,
                Fy => Fy,
                is_0 => is_0,
                saturation => saturation,
                exp_diff => exp_diff,
                flag_2c => flag_2c,
                Fz => Fz,
                index => index
            );
end;