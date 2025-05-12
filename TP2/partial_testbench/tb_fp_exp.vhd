library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fp_exp is
end;

architecture behavioral of tb_fp_exp is
    constant NE : natural := 8;
    signal Ex : std_logic_vector(NE-1 downto 0):= std_logic_vector(to_unsigned(130, NE));
    signal Ey : std_logic_vector(NE-1 downto 0):= std_logic_vector(to_unsigned(20, NE));
    signal is_0 : std_logic;
    signal add1 : std_logic := '1';


    signal Ez : std_logic_vector(NE-1 downto 0);
    signal saturation : std_logic;

    begin
    Ex <= std_logic_vector(to_unsigned(30, NE)) after 20 ns, -- valido
          std_logic_vector(to_unsigned(100, NE)) after 40 ns, -- satura por negativo
          std_logic_vector(to_unsigned(0, NE)) after 80 ns,  -- 0
          std_logic_vector(to_unsigned(255, NE)) after 100 ns; -- satura por overflow

    Ey <= std_logic_vector(to_unsigned(100, NE)) after 20 ns, -- valido
          std_logic_vector(to_unsigned(5, NE)) after 40 ns, -- satura por negativo
          std_logic_vector(to_unsigned(0, NE)) after 60 ns, -- 0
          std_logic_vector(to_unsigned(150, NE)) after 80 ns, -- satura por overflow
          std_logic_vector(to_unsigned(127, NE)) after 100 ns; -- satura por overflow + 1

    is_0 <= '1' when (unsigned(Ex)=0 OR unsigned(Ey)=0) else '0';
    add1 <= '0' after 10 ns, '1' after 130 ns, '0' after 140 ns;

    EXP_INST: entity work.exponent(behavioral)
                    generic map (
                        NE => NE
                    )
                    port map (
                        Ex => Ex,
                        Ey => Ey,
                        is_0 => is_0,
                        add1 => add1,
                        Ez => Ez,
                        saturation => saturation
                    );

end;