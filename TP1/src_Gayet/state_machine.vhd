library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.t_types.all;

entity fsm is
    port (
        clk_i       : in std_logic;
        rst_i       : in std_logic;
        sec_N      : in std_logic;
        state       : out t_state
    );
end fsm;

architecture behavioral of fsm is
    signal aux_state : t_state;

begin
    state <= aux_state;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            aux_state <= S0;
        elsif rising_edge(clk_i) then
            if sec_N = '1' then
                case aux_state is
                    when S0 =>
                        aux_state <= S1;
                    when S1 =>
                        aux_state <= S2;
                    when S2 =>
                        aux_state <= S3;
                    when S3 =>
                        aux_state <= S4;
                    when S4 =>
                        aux_state <= S5;
                    when S5 =>
                        aux_state <= S0;
                end case;
            end if;
        end if;
    end process;
end behavioral;