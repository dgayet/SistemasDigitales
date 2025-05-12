library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_add is
    generic (
        NE : natural := 7;
        NF : natural := 21
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        add_sub : in std_logic;
        x : in std_logic_vector(NF+NE downto 0);
        y : in std_logic_vector(NF+NE downto 0);
        z : out std_logic_vector(NF+NE downto 0)
    );
end;

architecture behavioral of fp_add is
    function search_implicit_1(value: unsigned(2**NE+NF downto 0)) return integer is
        variable found : boolean := false;
        variable ind : integer range 0 to 2**NE+NF := 0;

    begin
        for i in (2**NE + NF) downto 0 loop
            if not found then 
                ind := i;
            end if;
            if value(i) = '1' then
                found := true;
            end if;
        end loop;

        return ind;
    end;


    signal is_0 : std_logic_vector(1 downto 0) := "00";
    signal saturation : std_logic_vector(1 downto 0) := "00";

    signal x_reg : std_logic_vector(NF+NE downto 0) := (others => '0');
    signal y_reg : std_logic_vector(NF+NE downto 0) := (others => '0');
    signal z_reg : std_logic_vector(NF+NE downto 0) := (others => '0');

    signal Sx : std_logic := '0';
    signal Fx : std_logic_vector(NF-1 downto 0) := (others => '0');
    signal Ex : std_logic_vector(NE-1 downto 0) := (others => '0');

    signal Sy : std_logic := '0';
    signal Fy : std_logic_vector(NF-1 downto 0) := (others => '0');
    signal Ey : std_logic_vector(NE-1 downto 0) := (others => '0');

    signal Sz : std_logic := '0';
    signal Fz : std_logic_vector(NF-1 downto 0) := (others => '0');
    signal Ez : std_logic_vector(NE-1 downto 0) := (others => '0');

    -- constantes y seniales del calculo del significante
    constant F_SAT_VALUE : std_logic_vector(NF-1 downto 0) := std_logic_vector(to_unsigned(2**NF-1, NF));
    constant F_ZERO_VALUE : std_logic_vector(NF-1 downto 0) := std_logic_vector(to_unsigned(0, NF));
    constant E_SAT_VALUE : std_logic_vector(NE-1 downto 0) := std_logic_vector(to_unsigned(2**NE-1, NE));
    constant E_ZERO_VALUE : std_logic_vector(NE-1 downto 0) := std_logic_vector(to_unsigned(0, NE));


    signal Fx_ext : unsigned(NF downto 0) := (others => '0');
    signal Fy_ext : unsigned(NF downto 0) := (others => '0');
    
    signal aligned_Fx : unsigned(NF+2**NE-1 downto 0) := (others => '0');
    signal aligned_Fy : unsigned(NF+2**NE-1 downto 0) := (others => '0');

    signal Mx : unsigned(NF+2**NE+1 downto 0) := (others => '0');
    signal My : unsigned(NF+2**NE+1 downto 0) := (others => '0');

    signal Sx_ext : std_logic := '0';
    signal Sy_ext : std_logic := '0';

    signal Mz_pre : unsigned(NF+2**NE+1 downto 0) := (others => '0');
    signal Mz : unsigned(NF+2**NE+1 downto 0) := (others => '0'); 
    signal Mz_shift : unsigned(NF+2**NE+1 downto 0) := (others => '0');
    signal Fz_pre : unsigned(NF-1 downto 0) := (others => '0');
    signal Fz_aux : std_logic_vector(NF-1 downto 0) := (others => '0');

    signal abs_exp_diff : unsigned(NE downto 0) := (others => '0');
    signal aux_index : integer range 0 to 2**NE+NF := 0;
    signal shift : integer := 0;
    signal lower_index : integer range 0 to 2**NE+NF := 20;
    signal upper_index : integer range 0 to 2**NE+NF := 0;


    -- constantes y seniales del calculo del exponente

    signal Ex_ext : unsigned(NE+1 downto 0);
    signal Ey_ext : unsigned(NE+1 downto 0);
    signal Ez_pre : unsigned(NE+1 downto 0);
    signal aux_Ez : std_logic_vector(NE-1 downto 0); 

    signal exp_diff : unsigned(NE+1 downto 0);
    signal index : unsigned(NE+1 downto 0);

begin

    regX: entity work.reg(behavioral)
            generic map(NF+NE+1)
            port map(
                clk => clk,
                rst => rst,
                ena => '1',
                D => x,
                Q => x_reg
            );

    regY: entity work.reg(behavioral)
            generic map (NF+NE+1)
            port map (
                clk => clk,
                rst => rst,
                ena => '1',
                D => y,
                Q => y_reg
            );

    regZ: entity work.reg(behavioral)
            generic map (NF+NE+1)
            port map (
                clk => clk,
                rst => rst,
                ena => '1',
                D => z_reg,
                Q => z
            );
    
    ZERO : is_0 <= "10" when (unsigned(x_reg(NF+NE-1 downto 0))=0 AND unsigned(y_reg(NF+NE-1 downto 0)) /=0) else
                   "10" when (unsigned(x_reg(NF+NE-1 downto 0))/=0 AND unsigned(y_reg(NF+NE-1 downto 0)) =0) else
                   "11" when (unsigned(x_reg(NF+NE-1 downto 0))=0 AND unsigned(y_reg(NF+NE-1 downto 0)) =0) else
                   "00";
    
    EXPONENT :
        Ex <= x_reg(NF+NE-1 downto NF);
        Ey <= y_reg(NF+NE-1 downto NF);

        Ex_ext <= "00" & unsigned(Ex);
        EY_ext <= "00" & unsigned(Ey);

        exp_diff <= Ex_ext + (not Ey_ext + 1);
        index <= unsigned(std_logic_vector(to_signed(shift, NE+2)));

        Ez_pre <= Ex_ext+index when exp_diff(NE)='0' else Ey_ext+index;

        -- chequeo por algun operando = 0;
        aux_Ez <= std_logic_vector(Ez_pre(NE-1 downto 0)) when is_0="00" else
                  Ex when is_0="01" else
                  Ey when is_0="10" else
                  E_ZERO_VALUE;

        -- saturacion
        saturation <= std_logic_vector(Ez_pre(NE+1 downto NE));
        Ez <= aux_Ez when (saturation="00" or saturation="10") else
              E_SAT_VALUE when (saturation="01") else
              E_ZERO_VALUE when (saturation="10");

    SIGNIFICAND : 

        -- tomo el significando de X y de Y
        Fx <= x_reg(NF-1 downto 0);
        Fy <= y_reg(NF-1 downto 0);

        -- elijo Fx* y Fy* segun el MSB de la resta de los exponentes y agrego el 1 implicito
        Fx_ext <= ('1' & unsigned(Fx)) when exp_diff(NE) = '0' else ('1' & unsigned(Fy));
        Fy_ext <= ('1' & unsigned(Fy)) when exp_diff(NE) = '0' else ('1' & unsigned(Fx));

        -- en caso de que la operacion sea una resta debo cambiar el signo del operando Y:
        Sx_ext <= Sx when exp_diff(NE) = '0' else (add_sub XOR Sy);
        Sy_ext <= add_sub XOR Sy when exp_diff(NE) = '0' else Sx;

        -- armo las alineaciones en funcion de la abs(Ex - Ey) 
        abs_exp_diff <= exp_diff(NE downto 0) when exp_diff(NE) = '0' else (not exp_diff(NE downto 0) + 1);
        aligned_Fy <= to_unsigned(0, 2**NE-1) & Fy_ext;
        aligned_Fx <= shift_left(to_unsigned(0, 2**NE-1) & Fx_ext, to_integer(abs_exp_diff));

        -- Complemento a 2 correspondiente a cada mantisa en funcion de su signo y si es una resta o una suma
        Mx <= "00" & unsigned(aligned_Fx) when Sx_ext='0' else ("11" & unsigned(not aligned_Fx + 1));
        My <= "00" & unsigned(aligned_Fy) when Sy_ext='0' else unsigned( "11" & not aligned_Fy + 1);

        -- Sumo ambas mantisas y si resulta negativa complemento.
        Mz_pre <=  Mx + My;
        Mz <= Mz_pre when (Mz_pre(2**NE+NF+1)='0') else (not Mz_pre+1);

        -- Busco el 1 implicito de la mantisa resultante
        aux_index <= search_implicit_1(Mz(2**NE+NF downto 0));
        shift <= aux_index - (NF+to_integer(abs_exp_diff));

        -- Defino los indices que corresponden al significando de Z (Fz),
        -- en caso de que el largo del vector resultante sea < NF, se paddea con 0 a la derecha.
        upper_index <= aux_index-1 when (aux_index>0) else 0;
        lower_index <= aux_index-NF when (aux_index-NF > 0) else 0;
        Mz_shift <= shift_left(Mz, Mz'length - aux_index);

        Fz_pre <= Mz_shift(Mz'length-1 downto Mz'length - NF);

        -- chequeo por algun operando = 0;
        Fz_aux <= std_logic_vector(Fz_pre) when (is_0="00") else
                  Fx when (is_0="01") else 
                  Fy when (is_0="10") else
                  F_ZERO_VALUE;

        -- saturacion
        Fz <= Fz_aux when (saturation="00" or saturation="10") else
        F_SAT_VALUE when (saturation="01") else
        F_ZERO_VALUE when (saturation="10");
    
    SIGN :  
        Sx <= x_reg(NF+NE);
        Sy <= y_reg(NF+NE);
        -- el signo de la salida es el signo de la mantisa resultante 
        -- (dado que complemente cada operando segun fuera necesario)
        Sz <= Mz_pre(2**NE+NF) when is_0="00" else
              Sx when is_0="01" else
              add_sub XOR Sy when is_0="10" else
              '0';

    z_reg <= Sz & Ez & Fz;
end;