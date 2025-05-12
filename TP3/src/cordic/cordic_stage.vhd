library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_stage is
    generic (
        ITERS : natural := 16
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        rot_0_vec_1 : in std_logic;
        start : in std_logic;
        x_in : in std_logic_vector(ITERS+1 downto 0);
        y_in : in std_logic_vector(ITERS+1 downto 0);
        z_in : in std_logic_vector(ITERS+1 downto 0);
        x_out : out std_logic_vector(ITERS+1 downto 0);
        y_out : out std_logic_vector(ITERS+1 downto 0);
        z_out : out std_logic_vector(ITERS+1 downto 0);
        ready : out std_logic
    );
end;

architecture behavioral of cordic_stage is
    constant N : natural := ITERS+2;

    type t_array_mux is array(0 to ITERS-1) of signed(N-1 downto 0);
    constant BETAS : t_array_mux := (
        to_signed(32768,N),
        to_signed(19344,N),
        to_signed(10221,N),
        to_signed(5188,N),
        to_signed(2604,N),
        to_signed(1303,N),
        to_signed(652,N),
        to_signed(326,N),
        to_signed(163,N),
        to_signed(81,N),
        to_signed(41,N),
        to_signed(20,N),
        to_signed(10,N),
        to_signed(5,N),
        to_signed(3,N),
        to_signed(1,N)
    );

    signal x_reg : std_logic_vector(N-1 downto 0);
    signal y_reg : std_logic_vector(N-1 downto 0);
    signal z_reg : std_logic_vector(N-1 downto 0);

    signal x_aux : signed(N-1 downto 0) := (others => '0');
    signal y_aux : signed(N-1 downto 0) := (others => '0');
    signal z_aux : signed(N-1 downto 0) := (others => '0');

    signal x_i :  signed(N-1 downto 0);
    signal y_i :  signed(N-1 downto 0);
    signal z_i :  signed(N-1 downto 0);
    signal beta_i : signed(N-1 downto 0);

    signal iteration : integer range 0 to ITERS-1 := 0;
    signal it : std_logic_vector(3 downto 0) := (others => '0');
    signal it_reg : std_logic_vector(3 downto 0) := (others => '0');

    signal not_ready : std_logic;

begin
    it <= std_logic_vector(to_unsigned(iteration,4));

    x_i <= signed(x_in) when (start='1' or rst='1') else signed(x_reg);
    y_i <= signed(y_in) when (start='1' or rst='1') else signed(y_reg);
    z_i <= signed(z_in) when (start='1' or rst='1') else signed(z_reg);

    beta_i <= BETAS(iteration);

    not_ready <= '0' when unsigned(it_reg)=ITERS-1 else '1';

    counter : entity work.counter_N(behavioral2)
                    generic map (
                        N => ITERS
                    )
                    port map (
                        clk_i => clk,
                        rst_i => rst,
                        restart => start,
                        count => iteration
                    );

    add_sub_logic: entity work.add_sub(behavioral)
                        generic map (
                            N => N
                        )
                        port map (
                            x_in => x_i,
                            y_in => y_i,
                            z_in => z_i,
                            shift => iteration,
                            beta_i => beta_i,
                            rot_0_vec_1 => rot_0_vec_1,
                            x_out => x_aux,
                            y_out => y_aux,
                            z_out => z_aux
                        );

    regIter : entity work.reg(behavioral)
        generic map(4)
        port map(
            clk => clk,
            rst => rst,
            ena => '1',
            D => it,
            Q => it_reg
        );

    regX: entity work.reg(behavioral)
        generic map(N)
        port map(
            clk => clk,
            rst => rst,
            ena => '1',
            D => std_logic_vector(x_aux),
            Q => x_reg
        );

    regY: entity work.reg(behavioral)
        generic map(N)
        port map(
            clk => clk,
            rst => rst,
            ena => '1',
            D => std_logic_vector(y_aux),
            Q => y_reg
        );
    
    regZ: entity work.reg(behavioral)
    generic map(N)
    port map(
        clk => clk,
        rst => rst,
        ena => '1',
        D => std_logic_vector(z_aux),
        Q => z_reg
    );

    x_out <= x_reg;
    y_out <= y_reg;
    z_out <= z_reg;
    ready <= not not_ready;
end;