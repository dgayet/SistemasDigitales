library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.t_types.all;

entity lights_controller is
    port (
        state       : in t_state;
        green_1     : out std_logic;
        yellow_1    : out std_logic;
        red_1       : out std_logic;
        green_2     : out std_logic;
        yellow_2    : out std_logic;
        red_2       : out std_logic
    );
end;

architecture behavioral of lights_controller is
begin

    green_1 <= '1' when (state=S0) else '0';
    yellow_1 <= '1' when ((state=S1) OR (state=S5)) else '0';
    red_1 <= '1' when ((state=S2) OR (state=S3) OR (state=S4)) else '0';
    
    green_2 <= '1' when (state=S3) else '0';
    yellow_2 <= '1' when ((state=S2) OR (state=S4)) else '0';
    red_2 <= '1' when ((state=S0) OR (state=S1) OR (state=S5)) else '0';
        
end behavioral;