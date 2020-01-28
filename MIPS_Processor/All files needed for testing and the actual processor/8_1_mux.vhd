-- Jacob Puetz



library IEEE;
use IEEE.std_logic_1164.all;

entity mux8_1 is
	port (i_S		:in std_logic_vector(2 downto 0);
		i_Data0		:in std_logic;
		i_Data1		:in std_logic;
		i_Data2		:in std_logic;
		i_Data3		:in std_logic;
		i_Data4		:in std_logic;
		i_Data5		:in std_logic;
		i_Data6		:in std_logic;
		i_Data7		:in std_logic;
		
		o_Data		: out std_logic);
end mux8_1;

architecture structral of mux8_1 is
	component mux4_1
		port(i_S		:in std_logic_vector(1 downto 0);
		i_Data0		:in std_logic;
		i_Data1		:in std_logic;
		i_Data2		:in std_logic;
		i_Data3		:in std_logic;

		o_Data		: out std_logic);
	end component;
	
	component mux
		port( i_S	:in std_logic;
		i_A		:in std_logic;
		i_B		:in std_logic;
		o_F		:out std_logic);
	end component;
	
	signal first, second	: std_logic;
	
	begin
		G0:mux4_1
			port map(i_S	=> i_S(1 downto 0),
			i_Data0			=> i_Data0,
			i_Data1			=> i_Data1,
			i_Data2			=> i_Data2,
			i_Data3			=> i_Data3,
			
			o_Data			=> first);
				
		G1:mux4_1
			port map(i_S	=> i_S(1 downto 0),
			i_Data0			=> i_Data4,
			i_Data1			=> i_Data5,
			i_Data2			=> i_Data6,
			i_Data3			=> i_Data7,
			
			o_Data			=> second);
			
		G2:mux
			port map(  i_S	=> i_S(2),
			i_A				=> first,
			i_B				=> second,
			o_F				=> o_Data);
			
end structral;
	
	