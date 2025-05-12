library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_top is
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

architecture behavioral of cordic_top is
signal x_i_ap : std_logic_vector(ITERS+1 downto 0);
signal y_i_ap : std_logic_vector(ITERS+1 downto 0);
signal z_i_ap : std_logic_vector(ITERS+1 downto 0);

signal x_o_bp : std_logic_vector(ITERS+1 downto 0);
signal y_o_bp : std_logic_vector(ITERS+1 downto 0);
signal z_o_bp : std_logic_vector(ITERS+1 downto 0);

signal x_o_ap : std_logic_vector(2*(ITERS+1)+1 downto 0);
signal y_o_ap : std_logic_vector(2*(ITERS+1)+1 downto 0);

signal GAIN : signed(ITERS+1 downto 0) := "010011011010111101"; -- 79594



begin
    PRE: entity work.pre_cordic(behavioral)
        generic map(
            N => ITERS+2
        )
        port map (
            x_in => x_in,
            y_in => y_in,
            z_in => z_in,
            rot_0_vec_1 => rot_0_vec_1,
            x_out => x_i_ap,
            y_out => y_i_ap,
            z_out => z_i_ap
        );
        
    CORDIC: entity work.cordic_stage(behavioral)
        generic map(
            ITERS => ITERS
        )
        port map (
            clk => clk,
            rst => rst,
            rot_0_vec_1 => rot_0_vec_1,
            start => start,
            x_in => x_i_ap,
            y_in => y_i_ap,
            z_in => z_i_ap,
            x_out => x_o_bp,
            y_out => y_o_bp,
            z_out => z_o_bp,
            ready => ready
        );

    POST: 

    x_o_ap <= std_logic_vector(signed(x_o_bp)*GAIN);
    y_o_ap <= std_logic_vector(signed(y_o_bp)*GAIN);

    x_out <= x_o_ap(2*ITERS+2 downto ITERS+1);
    y_out <= y_o_ap(2*ITERS+2 downto ITERS+1);
    z_out <= z_o_bp;
    
end;

