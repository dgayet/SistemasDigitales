library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cordic_unrolled is
end;

architecture behavioral of tb_cordic_unrolled is
    constant N : natural := 16;
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal x_in : std_logic_vector(N+1 downto 0);
    signal y_in : std_logic_vector(N+1 downto 0);
    signal z_in : std_logic_vector(N+1 downto 0);
    signal x_out : std_logic_vector(N+1 downto 0);
    signal y_out : std_logic_vector(N+1 downto 0);
    signal z_out : std_logic_vector(N+1 downto 0);

    signal rot_0_vec_1_out : std_logic;
begin
    clk <= not clk after 2 ns;
    rst <= '0' after 1 ns;

    x_in <= std_logic_vector(to_signed(-10000,N+2));
    y_in <= std_logic_vector(to_signed(-3000,N+2));
    z_in <= std_logic_vector(to_signed(35000,N+2));

    cordic: entity work.cordic_unrolled_top(behavioral)
                generic map (
                    ITERS => N
                )
                port map(
                    clk => clk,
                    rst => rst,
                    rot_0_vec_1_in => '1',
                    x_in => x_in,
                    y_in => y_in,
                    z_in => z_in,
                    x_out => x_out,
                    y_out => y_out,
                    z_out => z_out,
                    rot_0_vec_1_out => rot_0_vec_1_out
                );
end;
