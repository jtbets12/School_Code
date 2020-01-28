

-- Jacob Puetz
-- one complement



library IEEE;
use IEEE.std_logic_1164.all;

entity mux5D is
	generic(N : integer := 5);

	port( i_S	:in std_logic;
	i_X		:in std_logic_vector(N-1 downto 0);
	i_Y		:in std_logic_vector(N-1 downto 0);
	o_Z		:out std_logic_vector(N-1 downto 0));

end mux5D;

architecture structure of mux5D is


begin

G4: for i in 0 to N-1 generate

	o_Z(i) <= (i_Y(i) and i_S) or (i_X(i) and (not i_S));

end generate;


end structure;