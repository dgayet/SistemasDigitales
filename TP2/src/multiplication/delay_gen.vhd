library ieee;
use ieee.std_logic_1164.all;

entity delay_gen is
    generic(
            N: natural:= 26;
            DELAY: natural:= 0
        );
    port(
        clk: in std_logic;
        rst: in std_logic;
        A: in std_logic_vector(N-1 downto 0);
        B: out std_logic_vector(N-1 downto 0)
    );
end;


architecture behavioral of delay_gen is
    type std_logic_matrix is array(DELAY-1 downto 0) of std_logic_vector(N-1 downto 0);   
    signal sr : std_logic_matrix;
begin
    process(clk,rst)
    begin
        if rst='1' then
            sr <= (others=>(others=>'0'));
        elsif clk = '1' and clk'event then
            sr(DELAY-1 downto 1) <= sr(DELAY-2 downto 0);
            sr(0) <= A;
        end if;
    end process;
    B <= sr(DELAY-1);
end;