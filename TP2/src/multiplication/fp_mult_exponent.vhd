library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exponent is
    generic (
        NE : natural := 7
    );
    port (
        Ex : in std_logic_vector(NE-1 downto 0);
        Ey : in std_logic_vector(NE-1 downto 0);
        is_0 : in std_logic;
        add1 : in std_logic;
        Ez : out std_logic_vector(NE-1 downto 0);
        saturation : out std_logic_vector (1 downto 0)
    );
end;

architecture behavioral of exponent is
    signal Ex_ext : unsigned(NE+1 downto 0);
    signal Ey_ext : unsigned(NE+1 downto 0);
    signal Ez_pre : unsigned(NE+1 downto 0);
    signal aux_add1 : unsigned(NE+1 downto 0);
    signal aux_Ez : unsigned(NE-1 downto 0);

    signal EXC_2C :  unsigned(NE+1 downto 0) := not to_unsigned(2**(NE-1)-1, NE+2) + 1;
    signal OVERFLOW_VALUE : unsigned(NE-1 downto 0) := to_unsigned(2**(NE)-1, NE);
    signal ZERO_VALUE : unsigned(NE-1 downto 0) := to_unsigned(0, NE);

begin
    Ex_ext <= unsigned("00" & Ex);
    Ey_ext <= unsigned("00" & Ey);
    aux_add1 <= to_unsigned(1, NE+2) when add1='1' else to_unsigned(0, NE+2);
    Ez_pre <= Ex_ext + Ey_ext + EXC_2C + aux_add1;
    saturation <= std_logic_vector(Ez_pre(NE+1 downto NE));
    aux_Ez <= Ez_pre(NE-1 downto 0) when Ez_pre(NE+1 downto NE)="00" else 
              OVERFLOW_VALUE when Ez_pre(NE+1 downto NE)="01" else ZERO_VALUE;
    Ez <= std_logic_vector(aux_Ez) when is_0='0' else std_logic_vector(ZERO_VALUE);
end;