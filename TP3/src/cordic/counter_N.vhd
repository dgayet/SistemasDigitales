library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_N is
    generic (
        N : natural := 15
    );
    port (
        clk_i: in std_logic;
        rst_i: in std_logic;
        restart : std_logic;
        count: out integer range 0 to N
    );
end;

architecture behavioral of counter_N is
    signal aux_count: integer range 0 to N := 0;
begin
    count <= aux_count;
    process(clk_i, rst_i)
    begin
        if clk_i='1' and clk_i'event then
            if rst_i = '1' then
                aux_count <= 0;
            else
                 if (aux_count = N-1) then
                    aux_count <= 0;
                else
                    aux_count <= aux_count + 1;
                end if;
            end if;
        end if;
    end process;
end;

architecture behavioral2 of counter_N is
    signal aux_count: integer := 0;
begin
    count <= aux_count;
    process(clk_i, rst_i)
    begin
        if (rst_i = '1') then
            aux_count <= 0;
        elsif clk_i='1' and clk_i'event then
            if (aux_count = N-1 or restart='1') then
                aux_count <= 0;
            else
                aux_count <= aux_count + 1;
            end if;
        end if;
    end process;
end;


