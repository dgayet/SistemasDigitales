library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_unrolled_top is
    generic (
        ITERS : natural := 16;
        PIPELINE : boolean := True
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        rot_0_vec_1_in : in std_logic;
        x_in : in std_logic_vector(ITERS+1 downto 0);
        y_in : in std_logic_vector(ITERS+1 downto 0);
        z_in : in std_logic_vector(ITERS+1 downto 0);
        x_out : out std_logic_vector(ITERS+1 downto 0);
        y_out : out std_logic_vector(ITERS+1 downto 0);
        z_out : out std_logic_vector(ITERS+1 downto 0);
       rot_0_vec_1_out : out std_logic
    );
end;

architecture behavioral of cordic_unrolled_top is
    constant N : natural := ITERS+2;
    type signed_matrix is array(integer range <>) of signed(N-1 downto 0);

    constant BETAS : signed_matrix(0 to ITERS-1) := (
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

    signal x_i :  signed_matrix(ITERS downto 0);
    signal y_i :  signed_matrix(ITERS downto 0);
    signal z_i :  signed_matrix(ITERS downto 0);

    signal x_o :  signed_matrix(ITERS-1 downto 0);
    signal y_o :  signed_matrix(ITERS-1 downto 0);
    signal z_o :  signed_matrix(ITERS-1 downto 0);

    signal r0_v1 : std_logic_vector(ITERS downto 0);
begin
    x_i(0) <= signed(x_in);
    y_i(0) <= signed(y_in);
    z_i(0) <= signed(z_in);
    r0_v1(0) <=  rot_0_vec_1_in; 

    x_out <= std_logic_vector(x_i(ITERS));
    y_out <= std_logic_vector(y_i(ITERS));
    z_out <= std_logic_vector(z_i(ITERS));
    rot_0_vec_1_out <= r0_v1(ITERS);


    cordic: for i in 0 to ITERS-1 generate
        cs: entity work.add_sub(behavioral)
                generic map (
                    N => N
                )
                port map (
                    x_in => x_i(i),
                    y_in => y_i(i),
                    z_in => z_i(i),
                    shift => i,
                    beta_i => BETAS(i),
                    rot_0_vec_1 => r0_v1(i),
                    x_out => x_o(i),
                    y_out => y_o(i),
                    z_out => z_o(i)
                );

    pipeline_condition: if PIPELINE generate
    begin
        regX: entity work.reg2(behavioral)
            generic map(N)
            port map(
                clk => clk,
                rst => rst,
                ena => '1',
                D => x_o(i),
                Q => x_i(i+1)
            );

        regY: entity work.reg2(behavioral)
            generic map(N)
            port map(
                clk => clk,
                rst => rst,
                ena => '1',
                D => y_o(i),
                Q => y_i(i+1)
            );
        
        regZ: entity work.reg2(behavioral)
        generic map(N)
        port map(
            clk => clk,
            rst => rst,
            ena => '1',
            D => z_o(i),
            Q => z_i(i+1)
        );

        reg_rv: entity work.reg2(behavioral)
        generic map(N)
        port map(
            clk => clk,
            rst => rst,
            ena => '1',
            D => z_o(i),
            Q => z_i(i+1)
        );


        else generate
            x_i(i+1) <= x_o(i);
            y_i(i+1) <= y_o(i);
            z_i(i+1) <= z_o(i);
            r0_v1(i) <= rot_0_vec_1_in;
        end generate;

    end generate;

end;