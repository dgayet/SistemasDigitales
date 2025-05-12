library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_add_sub_logic is
end;

architecture behavioral of tb_add_sub_logic is
    constant N : natural := 18;
    signal x_in : signed(N-1 downto 0) := not to_signed(10000, N) + 1;
    signal y_in : signed(N-1 downto 0) := not to_signed(3000, N) + 1;
    signal z_in : signed(N-1 downto 0) := to_signed(35000, N);

    signal x_out : signed(N-1 downto 0) ;
    signal y_out : signed(N-1 downto 0);
    signal z_out : signed(N-1 downto 0);

    signal beta_i : signed(N-1 downto 0) := to_signed(32768, N);
    signal selec : std_logic;

    signal iteration : integer := 0;

begin
    x_in <= not to_signed(500, N) + 1 after 10 ns;
    y_in <= not to_signed(16500, N) + 1 after 10 ns;
    z_in <= not to_signed(17112,N)+1 after 10 ns;
    beta_i <= to_signed(10221, N) after 10 ns;
    selec <= z_in(N-1), '0' after 20 ns;
    iteration <=  2 after 10 ns;

    ADD_SUB : entity work.add_sub(behavioral)
            generic map (
        N => N
    )
    port map (
        x_in => x_in,
        y_in => y_in,
        z_in => z_in,
        beta_i => beta_i,
        shift => iteration,
        selec => selec,
        x_out => x_out,
        y_out => y_out,
        z_out => z_out
    );
end;
