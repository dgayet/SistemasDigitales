library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.t_types.all;

entity semaphore_tb is
end;

architecture behavioral of semaphore_tb is
signal clk : std_logic := '1';
signal rst : std_logic := '1';

signal rojo_1 : std_logic;
signal amarillo_1 : std_logic;
signal verde_1 : std_logic;

signal rojo_2 : std_logic;
signal amarillo_2 : std_logic;
signal verde_2 : std_logic;

begin
    clk <= not clk after 10 ns;
    rst <= '0' after 20 ns;

    SEMAPHORE: entity work.semaphore(behavioral)
        port map (
        clk_i       => clk,        
        rst_i       => rst,        
        green_1     => verde_1,
        yellow_1    => amarillo_1,
        red_1       => rojo_1,
        green_2     => verde_2,
        yellow_2    => amarillo_2,
        red_2       => rojo_2
        );

end behavioral;