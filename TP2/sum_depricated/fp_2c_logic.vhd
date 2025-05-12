library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logic_2c is
    port (
        Sx : in std_logic;
        Sy : in std_logic;
        AS_flag : in std_logic;
        MSB_exp_diff : in std_logic;
        flag_2c : out std_logic_vector(1 downto 0)
    );
end;

architecture behavioral of logic_2c is
    signal sel : std_logic_vector(3 downto 0);
    signal output : std_logic_vector(1 downto 0);
begin
    sel <= AS_flag & Sx & Sy & MSB_exp_diff;
    with sel select
        flag_2c <= "00" when "0000",
                   "00" when "0001",
                   "01" when "0010",
                   "10" when "0011",
                   "10" when "0100",
                   "01" when "0101",
                   "11" when "0110",
                   "11" when "0111",
                   "01" when "1000",
                   "10" when "1001",
                   "00" when "1010",
                   "00" when "1011",
                   "11" when "1100",
                   "11" when "1101",
                   "10" when "1110",
                   "01" when "1111";
end;
