library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.t_types.all;

entity semaphore is
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;
        green_1     : out std_logic;
        yellow_1    : out std_logic;
        red_1       : out std_logic;
        green_2     : out std_logic;
        yellow_2    : out std_logic;
        red_2       : out std_logic
    );
end semaphore;

architecture behavioral of semaphore is
    constant SECS_G : unsigned := to_unsigned(30, 5);
    constant SECS_YR: unsigned := to_unsigned(3, 5);
    signal state : t_state;
    signal is_Nsec : std_logic;
    signal N : unsigned(4 downto 0);
    
begin
    N_SEL: N <= SECS_G when ((state=S0) OR (state=S3)) else SECS_YR; 

    NC_I: entity work.counter_Nsec(behavioral)
        port map (
            clk_i => clk_i,
            rst_i => rst_i,
            Ncount => N,
            sec_N => is_Nsec
        );

    L_CONT_I: entity work.lights_controller(behavioral)
            port map(
                state => state,
                green_1 => green_1,
                yellow_1 => yellow_1,
                red_1 => red_1,
                green_2 => green_2,
                yellow_2 => yellow_2,
                red_2 => red_2
            );

    FSM_I: entity work.fsm(behavioral)
            port map(
                clk_i => clk_i,
                rst_i => rst_i,
                sec_N => is_Nsec,
                state => state
              );
end behavioral;