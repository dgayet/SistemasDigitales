library IEEE;
use IEEE.std_logic_1164.all;
use iEEE.numeric_std.all;

entity reg2 is
    generic(N: integer := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;
        ena : in std_logic;
        D : in signed(N-1 downto 0);
        Q : out signed(N-1 downto 0)
    );
end;

architecture behavioral of reg2 is
begin
    process(clk, rst)
    begin
        if rst='1' then
            Q <= (others => '0');
        elsif rising_edge(clk) then
            if ena='1' then
                Q <= D;
            end if;
        end if;
    end process;
end;