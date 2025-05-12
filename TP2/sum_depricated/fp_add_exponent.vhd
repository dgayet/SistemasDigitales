library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_exponent is
    generic (
        NE : natural := 8
    );
    port (
        Ex : in std_logic_vector(NE-1 downto 0);
        Ey : in std_logic_vector(NE-1 downto 0);
        is_0 : in std_logic; -- cambiar por un vector de dos posiciones;
        index : in integer;
        saturation : out std_logic_vector(1 downto 0);
        exp_diff : out std_logic_vector(NE downto 0); -- no en absoluto;
        Ez : out std_logic_vector(NE-1 downto 0)
    );
end;

architecture behavioral of add_exponent is
    constant OVERFLOW_VALUE : unsigned(NE-1 downto 0) := to_unsigned(2**NE-1, NE);
    constant ZERO_VALUE : unsigned(NE-1 downto 0) := to_unsigned(0, NE);

    signal Ex_ext : unsigned(NE+1 downto 0);
    signal Ey_ext : unsigned(NE+1 downto 0);
    signal Ez_pre : unsigned(NE+1 downto 0);
    signal aux_Ez : unsigned(NE-1 downto 0);

    signal aux_index : unsigned(NE+1 downto 0);
    signal aux_exp_diff : unsigned(NE+1 downto 0);
    signal debug : std_logic;
begin
    Ex_ext <= "00" & unsigned(Ex);
    Ey_ext <= "00" & unsigned(Ey);

    aux_exp_diff <= Ex_ext + (not Ey_ext + 1);
    aux_index <= unsigned(std_logic_vector(to_signed(index, NE+2)));

    debug <= '1' when aux_exp_diff(NE)='0' else '0';
    Ez_pre <= Ex_ext+aux_index when aux_exp_diff(NE)='0' else Ey_ext+aux_index;

    
    aux_Ez <= ZERO_VALUE when Ez_pre(NE+1 downto NE)="11" else 
              OVERFLOW_VALUE when Ez_pre(NE+1 downto NE)="01" else Ez_pre(NE-1 downto 0);
    
    -- Ez <= std_logic_vector(aux_Ez) when is_0='0' else std_logic_vector(ZERO_VALUE); -- cambiar logica a ALGUN operando es 0, el resultado es el q no sea 0.
    Ez <= aux_Ez;
    saturation <= std_logic_vector(Ez_pre(NE+1 downto NE));
    exp_diff <= std_logic_vector(aux_exp_diff(NE downto 0));

end;