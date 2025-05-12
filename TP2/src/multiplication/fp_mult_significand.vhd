library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity significand is
    generic (
        NF : natural := 21
    );
    port (
        Fx : in std_logic_vector(NF-1 downto 0);
        Fy : in std_logic_vector(NF-1 downto 0);
        is_0 : in std_logic;
        saturation : in std_logic_vector(1 downto 0);
        Fz : out std_logic_vector(NF-1 downto 0);
        add1 : out std_logic
    );
end;


architecture behavioral of significand is
    signal Fx_ext : unsigned(NF downto 0);
    signal Fy_ext : unsigned(NF downto 0);
    signal Fz_ext : unsigned(2*NF+1 downto 0);
    signal Fz_aux : unsigned(NF-1 downto 0);
    signal Fz_pre : unsigned(NF-1 downto 0);
    signal Fz_MSB : std_logic;
    signal aux_sat : std_logic;

    constant ZERO_VALUE : unsigned(NF-1 downto 0) := to_unsigned(0, NF);
    constant SAT_VALUE : unsigned(NF-1 downto 0) := to_unsigned(2**NF -1, NF);

begin

    Fx_ext <= unsigned('1' & Fx);
    Fy_ext <= unsigned('1' & Fy);
    Fz_ext <= Fx_ext * Fy_ext;
    Fz_MSB <= Fz_ext(2*NF+1);
    Fz_aux <= Fz_ext(2*NF downto NF+1) when Fz_MSB='1' else Fz_ext(2*NF-1 downto NF);
    Fz_pre <= Fz_aux when (saturation="10" or saturation="00") else 
              SAT_VALUE when saturation="01" else ZERO_VALUE;

    aux_sat <='0' when (is_0='0') else '1';
    Fz <= std_logic_vector(Fz_pre) when is_0='0' else std_logic_vector(ZERO_VALUE);
    add1 <= Fz_MSB;
end;