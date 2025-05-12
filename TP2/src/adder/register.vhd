library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
    generic(N: integer := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;
        ena : in std_logic;
        D : in std_logic_vector(N-1 downto 0);
        Q : out std_logic_vector(N-1 downto 0)
    );
end;

architecture behavioral of reg is
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