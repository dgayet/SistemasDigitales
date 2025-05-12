library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_multiplication is
    generic (
        NE : natural := 7;
        NF : natural := 21
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        x : in std_logic_vector(NF+NE downto 0);
        y : in std_logic_vector(NF+NE downto 0);
        z : out std_logic_vector(NF+NE downto 0)
    );
end;

architecture behavioral of fp_multiplication is
    signal is_0 : std_logic;
    signal sign : std_logic;
    signal add_1 : std_logic;
    signal saturation : std_logic_vector(1 downto 0);

    signal x_reg : std_logic_vector(NF+NE downto 0);
    signal y_reg : std_logic_vector(NF+NE downto 0);
    signal z_reg : std_logic_vector(NF+NE downto 0);

begin

    regX: entity work.reg(behavioral)
        generic map(NF+NE+1)
        port map(
            clk => clk,
            rst => rst,
            ena => '1',
            D => x,
            Q => x_reg
        );

    regY: entity work.reg(behavioral)
        generic map (NF+NE+1)
        port map (
            clk => clk,
            rst => rst,
            ena => '1',
            D => y,
            Q => y_reg
        );

    regZ: entity work.reg(behavioral)
        generic map (NF+NE+1)
        port map (
            clk => clk,
            rst => rst,
            ena => '1',
            D => z_reg,
            Q => z
        );

    IS_0_INST : is_0 <= '1' when (unsigned(x_reg(NF+NE-1 downto 0))=0 OR unsigned(y_reg(NF+NE-1 downto 0))=0)
                        else '0';

    SIGN_INST : sign <= x_reg(NF+NE) XOR y_reg(NF+NE);

    EXP_INST : entity work.exponent(behavioral)
                generic map (
                    NE => NE
                )
                port map (
                    Ex => x_reg(NF+NE-1 downto NF),
                    Ey => y_reg(NF+NE-1 downto NF),
                    is_0 => is_0,
                    add1 => add_1,
                    Ez => z_reg(NF+NE-1 downto NF),
                    saturation => saturation
                );
    
    SIG_INST : entity work.significand(behavioral)
                generic map (
                    NF => NF
                )
                port map (
                    Fx => x_reg(NF-1 downto 0),
                    Fy => y_reg(NF-1 downto 0),
                    is_0 => is_0,
                    saturation => saturation,
                    Fz => z_reg(NF-1 downto 0),
                    add1 => add_1
                );
    
    Z_sign_inst: z_reg(NF+NE) <= sign; 
end;