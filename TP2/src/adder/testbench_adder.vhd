library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity pf_testbench_add is
end entity pf_testbench_add;


architecture pf_testbench_add_arq of pf_testbench_add is
    constant TCK: time:= 20 ns; -- periodo de reloj
    constant DELAY: natural:= 2; -- retardo de procesamiento del DUV
    constant NF : natural := 21;
    constant EXP_SIZE_T: natural:= 7; -- tamanio exponente
    constant WORD_SIZE_T: natural:= NF+EXP_SIZE_T+1; -- tamanio de datos
    signal clk: std_logic := '0';
    signal rst: std_logic := '1';
    signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
    signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
    signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
    signal z_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0'); 
    signal z_duv: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
    signal ciclos: integer := 0; signal errores: integer := 0;
    -- La senal z_del_aux se define por un problema de conversion
    signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');

    signal add_sub : std_logic := '1';

    file datos: text open read_mode is "../testbench/fsub_21_7.txt";
    -- Declaracion del componente a probar
    component fp_add is
        generic(
                NE: natural := 8;
                NF: natural := 23
            );
            port(
                clk : in std_logic;
                rst : in std_logic;
                add_sub : in std_logic;
                x : in std_logic_vector(NF+NE downto 0);
                y : in std_logic_vector(NF+NE downto 0);
                z : out std_logic_vector(NF+NE downto 0)
                );
    end component fp_add ;
    -- Declaracion de la linea de retardo
    component delay_gen is
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
    end component;
begin
    -- Generacion del clock del sistema
    clk <= not(clk) after TCK/ 2; -- reloj
    rst <= '0' after 1 ns;

    Test_Sequence: process
        variable l: line;

        variable ch: character:= ' ';
        variable aux: integer;
    begin
        while not(endfile(datos)) loop
            wait until rising_edge(clk);
            -- solo para debugging
            ciclos <= ciclos + 1;
            -- se lee una linea del archivo de valores de prueba
            readline(datos, l);
            -- se extrae un entero de la linea
            read(l, aux);
            -- se carga el valor del operando A
            a_file <= to_unsigned(aux, WORD_SIZE_T);
            -- se lee un caracter (es el espacio)
            read(l, ch);
            -- se lee otro entero de la linea
            read(l, aux);
            -- se carga el valor del operando B
            b_file <= to_unsigned(aux, WORD_SIZE_T);
            -- se lee otro caracter (es el espacio)
            read(l, ch);
            -- se lee otro entero
            read(l, aux);
            -- se carga el valor de salida (resultado)
            z_file <= to_unsigned(aux, WORD_SIZE_T);
        end loop;
        -- se cierra del archivo
        file_close(datos);
        wait for TCK*(DELAY+1);
        -- se aborta la simulacion (fin del archivo)
        assert false report
        "Fin de la simulacion" severity failure;
    end process Test_Sequence;
-- Instanciacion del DUV
DUV: fp_add 
        generic map (
                NE => EXP_SIZE_T,
                NF => NF
        )
        port map(
            clk => clk,
            rst => rst,
            add_sub => add_sub,
            x => std_logic_vector(a_file),
            y => std_logic_vector(b_file),
            z => z_duv
        );
-- Instanciacion de la linea de retardo
del: delay_gen
    generic map(WORD_SIZE_T, DELAY)
    port map(clk, '0', std_logic_vector(z_file), z_del_aux);
    z_del <= unsigned(z_del_aux);
-- Verificacion de la condicion
verificacion: process(clk)
        begin
            if rising_edge(clk) then
            assert to_integer(z_del) = to_integer(unsigned(z_duv)) report
            "Error: Salida del DUV no coincide con referencia (salida del duv = " &
            integer'image(to_integer(unsigned(z_duv))) & ", salida del archivo = " &
            integer'image(to_integer(z_del)) & ")" &
            "Errores= " & integer'image(errores+1) & " en la linea " & integer'image(ciclos-2)
            severity warning;
            if to_integer(z_del) /= to_integer(unsigned(z_duv)) then
            errores <= errores + 1;
            end if;
            end if;
        end process;
end architecture pf_testbench_add_arq;