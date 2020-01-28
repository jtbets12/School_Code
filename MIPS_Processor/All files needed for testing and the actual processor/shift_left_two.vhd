library IEEE;
use IEEE.std_logic_1164.all;

entity shift_left_two is 

	port(i_A          : in std_logic_vector(31 downto 0);
         o_F          : out std_logic_vector(31 downto 0));

end shift_left_two;

architecture behaviour of shift_left_two is
begin 
o_F(0) <= '0';
o_F(1) <= '0';

G0: for i in 0 to 29 generate
	o_F(i+2) <= i_A(i);

end generate;


end behaviour;