-- Jacob Puetz
-- one complement



library IEEE;
use IEEE.std_logic_1164.all;

entity F_adderND is

	generic(N : integer := 32);

	port( i_X 	:in std_logic_vector(N-1 downto 0);
	i_Y 		:in std_logic_vector(N-1 downto 0);
	i_C 		:in std_logic;
	o_S		:out std_logic_vector(N-1 downto 0);
	o_C		:out std_logic);

end F_adderND;


architecture structure of F_adderND is

	signal S, C_1, C_2          : std_logic_vector(N-1 downto 0);
	-- carry last bit
	signal CL		:std_logic_vector(N downto 0);

begin
	-- start with CL carry last set
	CL(0) <= i_C;
	
	G5: for i in 0 to N-1 generate


		o_S(i) <=    ((i_X(i) xor i_Y(i)) xor CL(i));
		CL(i+1) <=   ((i_X(i) and i_Y(i)) or (i_X(i) and i_Y(i)));

	end generate;

	o_C <= CL(N);

end structure;