library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fp_sig is
end;

architecture behavioral of tb_fp_sig is
    constant NF : natural := 23;
    signal Fx : std_logic_vector(NF-1 downto 0) := std_logic_vector(to_unsigned(2, NF));
    signal Fy : std_logic_vector(NF-1 downto 0) := std_logic_vector(to_unsigned(2, NF));
    signal is_0 : std_logic;
    signal saturation : std_logic := '0';


    signal Fz : std_logic_vector(NF-1 downto 0);
    signal add1 : std_logic;


    begin
    Fx <= std_logic_vector(to_unsigned(2**NF-1, NF)) after 20 ns, -- valido : AB=10
          std_logic_vector(to_unsigned(0, NF)) after 80 ns,  -- 0
          std_logic_vector(to_unsigned(2**NF-1, NF)) after 100 ns, -- valido: AB=11
          std_logic_vector(to_unsigned(1, NF)) after 140 ns; -- valido: AB=01

    Fy <= std_logic_vector(to_unsigned(10, NF)) after 20 ns, -- valido
          std_logic_vector(to_unsigned(0, NF)) after 60 ns, -- 0
          std_logic_vector(to_unsigned(2**NF-1, NF)) after 80 ns;

    is_0 <= '1' when (unsigned(Fx)=0 OR unsigned(Fy)=0) else '0';
    saturation <= '1' after 15 ns, '0' after 40 ns, '1' after 160 ns;

    EXP_INST: entity work.significand(behavioral)
                    generic map (
                        NF => NF
                    )
                    port map (
                        Fx => Fx,
                        Fy => Fy,
                        is_0 => is_0,
                        saturation => saturation,
                        Fz => Fz,
                        add1 => add1
                    );

end;