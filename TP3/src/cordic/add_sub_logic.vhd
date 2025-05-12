library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_sub is
    generic (
        N : natural := 18
    );
    port (
        x_in : in signed(N-1 downto 0);
        y_in : in signed(N-1 downto 0);
        z_in : in signed(N-1 downto 0);
        shift : in integer;
        beta_i : in signed(N-1 downto 0);
        rot_0_vec_1 : in std_logic;
        x_out : out signed(N-1 downto 0);
        y_out : out signed(N-1 downto 0);
        z_out : out signed(N-1 downto 0)
    );
end;

architecture behavioral of add_sub is
    signal x_shift : signed(N-1 downto 0);
    signal y_shift : signed(N-1 downto 0);
    signal selec : std_logic;
begin
    x_shift <= shift_right(x_in, shift);
    y_shift <= shift_right(y_in, shift);
    selec <= z_in(N-1) when rot_0_vec_1 = '0' else y_in(N-1);

    x_out <= x_in - y_shift when (selec='0') else x_in + y_shift;
    y_out <= y_in + x_shift when (selec='0') else y_in - x_shift;
    z_out <= z_in - beta_i when (selec='0') else z_in + beta_i;
end;