library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_1sec is
    -- Ncycles es un generic para poder probar el circuito con una cantidad de ciclos menor.
    generic (
        Ncycles: natural := 50000000
    );
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;
        sec_1 : out std_logic
    );
end;

architecture behavioral of counter_1sec is
    signal cycle_count : unsigned(25 downto 0);
begin

    sec_1 <= '1' when (cycle_count=Ncycles-1) else '0';

    process(clk_i, rst_i)
    begin
        if rst_i='1' then
            cycle_count <= (others => '0');
        elsif rising_edge(clk_i) then
            if (cycle_count = Ncycles-1) then
                cycle_count <= (others => '0');
            else 
                cycle_count <= cycle_count + 1;
            end if;
        end if;
    end process;
end; 