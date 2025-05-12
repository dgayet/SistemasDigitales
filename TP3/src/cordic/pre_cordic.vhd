library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pre_cordic is
    generic (
        N : natural := 18
    );
    port (
        x_in : in std_logic_vector(N-1 downto 0);
        y_in : in std_logic_vector(N-1 downto 0);
        z_in : in std_logic_vector(N-1 downto 0);
        rot_0_vec_1 : in std_logic;
        x_out : out std_logic_vector(N-1 downto 0);
        y_out : out std_logic_vector(N-1 downto 0);
        z_out : out std_logic_vector(N-1 downto 0)
    );
end;

architecture behavioral of pre_cordic is
    signal selec : std_logic;
    signal z_sat : std_logic;

begin
    z_sat <= '1' when (z_in(N-1 downto N-2)="01" OR z_in(N-1 downto N-2)="10") else '0'; 
    selec <= z_sat when rot_0_vec_1='0' else x_in(N-1);

    x_out <= x_in when selec='0' else std_logic_vector(not signed(x_in) + 1);
    y_out <= y_in when selec='0' else std_logic_vector(not signed(y_in) + 1);
    z_out <= z_in when selec='0' else ((not z_in(N-1)) & z_in(N-2 downto 0));

end;