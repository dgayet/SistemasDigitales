library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_Nsec is
    port (
        clk_i: in std_logic;
        rst_i: in std_logic;
        Ncount : in unsigned(4 downto 0);
        sec_N: out std_logic
    );
end;

architecture behavioral of counter_Nsec is
    constant NCYCLES: natural := 5;
    --constant NCYCLES: natural := 50000000;
    signal aux_count: unsigned(4 downto 0);
    signal is_1sec: std_logic;
begin

    sec_N <= '1' when ((aux_count = Ncount-1) AND (is_1sec='1')) else '0';
    process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            aux_count <= (others => '0');
        elsif clk_i='1' and clk_i'event then
            if (is_1sec = '1') then
                if (aux_count = Ncount-1) then
                    aux_count <= (others => '0');
                else
                    aux_count <= aux_count + 1;
                end if;
            end if;
        end if;
    end process;

    I_C1sec: entity work.counter_1sec(behavioral)
        generic map (
            Ncycles => NCYCLES
        )
        port map (
            clk_i => clk_i,
            rst_i => rst_i,
            sec_1 => is_1sec
        );
end;

