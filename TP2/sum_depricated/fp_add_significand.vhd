library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_significand is
    generic (
        NF : natural := 23;
        NE : natural := 8
    );
    port (
        Fx : in std_logic_vector(NF-1 downto 0);
        Fy : in std_logic_vector(NF-1 downto 0);
        is_0 : in std_logic; -- cambiar por un vector de dos posiciones;
        saturation : in std_logic_vector(1 downto 0);
        exp_diff : in std_logic_vector(NE downto 0); -- no en absoluto;
        flag_2c : in std_logic_vector(1 downto 0);
        Fz : out std_logic_vector(NF-1 downto 0);
        index : out integer
    );
end;

architecture behavioral of add_significand is 
    function search_implicit_1(x: unsigned(2**NE+NF downto 0)) return integer is
        variable found : boolean := false;
        variable ind : integer range 0 to 2**NE+NF := 0;

    begin
        for i in (2**NE + NF) downto 0 loop
            if not found then 
                ind := i;
            end if;
            if x(i) = '1' then
                found := true;
            end if;
        end loop;

        return ind;
    end;
    constant SAT_VALUE : std_logic_vector(NF-1 downto 0) := std_logic_vector(to_unsigned(2**NF-2, NF));
    constant ZERO_VALUE : std_logic_vector(NF-1 downto 0) := std_logic_vector(to_unsigned(0, NF));

    signal Fx_ext : unsigned(NF downto 0);
    signal Fy_ext : unsigned(NF downto 0);
    signal abs_exp_diff : unsigned(NE downto 0);

    signal aligned_Fx : unsigned(NF+2**NE-1 downto 0);
    signal aligned_Fy : unsigned(NF+2**NE-1 downto 0);

    signal Mx : unsigned(NF+2**NE downto 0);
    signal My : unsigned(NF+2**NE downto 0);

    signal Mz_pre : unsigned(NF+2**NE downto 0);
    signal Mz : unsigned(NF+2**NE downto 0); 

    signal Fz_pre : unsigned(NF-1 downto 0) := (others => '0');

    signal aux_index : integer range 0 to 2**NE+NF;
    signal lower_index : integer range 0 to 2**NE+NF := 20;
    signal upper_index : integer range 0 to 2**NE+NF := 0;

begin
    Fx_ext <= ('1' & unsigned(Fx)) when exp_diff(NE) = '0' else ('1' & unsigned(Fy));
    Fy_ext <= ('1' & unsigned(Fy)) when exp_diff(NE) = '0' else ('1' & unsigned(Fx));
    abs_exp_diff <= unsigned(exp_diff) when exp_diff(NE) = '0' else (not unsigned(exp_diff) + 1);

    aligned_Fy <= to_unsigned(0, 2**NE-1) & Fy_ext;
    aligned_Fx <= to_unsigned(0, 2**NE-1-to_integer(abs_exp_diff)) & Fx_ext & to_unsigned(0, to_integer(abs_exp_diff));


    Mx <= '0' & unsigned(aligned_Fx) when flag_2c(1)='0' else ('1' & unsigned(not aligned_Fx + 1));
    My <= '0' & unsigned(aligned_Fy) when flag_2c(0)='0' else unsigned( '1' & not aligned_Fy + 1);

    Mz_pre <=  Mx + My;
    Mz <= Mz_pre when (Mz_pre(2**NE+NF)='0') else (not Mz_pre+1);

    aux_index <= search_implicit_1(Mz);

    upper_index <= aux_index-1 when (aux_index>0) else 0;
    lower_index <= aux_index-NF when (aux_index-NF > 0) else 0;
    Fz_pre(NF-1 downto (NF-1 - (upper_index-lower_index))) <= Mz(upper_index downto lower_index);

   --falta saturacion y 0 ;

    -- Fz <= std_logic_vector(Fz_pre) when (saturation="10") else
    --             SAT_VALUE when (saturation="11") else 
    --             ZERO_VALUE when (saturation="01");
    Fz <= Fz_pre;
    index <= aux_index - (NF+to_integer(abs_exp_diff));
end;