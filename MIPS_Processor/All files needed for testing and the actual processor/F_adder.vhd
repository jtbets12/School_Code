-- Jacob Puetz
-- one complement



library IEEE;
use IEEE.std_logic_1164.all;

entity F_adder is

	port( i_X 	:in std_logic;
	i_Y 		:in std_logic;
	i_C 		:in std_logic;
	o_S		:out std_logic;
	o_C		:out std_logic);

end F_adder;

architecture structure of F_adder is

	component andg2
		port(i_A 	: in std_logic;
		i_B		: in std_logic;
		o_F		: out std_logic);
	end component;

	component org2
		port(i_A 	: in std_logic;
		i_B		: in std_logic;
		o_F		: out std_logic);
	end component;

	component xorg2
		port(i_A 	: in std_logic;
		i_B		: in std_logic;
		o_F		: out std_logic);
	end component;

	signal S, C_1, C_2          : std_logic;

	begin
	G0:xorg2
		port map (i_A	=> i_X,
		i_B	=>i_Y,
		o_F	=>S);

	G1:xorg2
		port map(i_A	=> i_C,
		i_B	=>S,
		o_F	=>o_S);
	
	G2:andg2
		port map(i_A	=> i_C,
		i_B	=>S,
		o_F	=>C_1);

	G3:andg2
		port map (i_A	=> i_X,
		i_B	=>i_Y,
		o_F	=>C_2);

	G4:org2
		port map (i_A 	=> C_1,
		i_B	=>C_2,
		o_F	=>o_C);


end structure;


   
