-- Jacob Puetz



library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is

	port( A 		:in std_logic;
	B 				:in std_logic;
	carry_in 		:in std_logic;
	Ainvert 		:in std_logic;
	Binvert 		:in std_logic;
	less			:in std_logic;
	operation		:in std_logic_vector(2 downto 0);
	set				:out std_logic;
	Result			:out std_logic;
	carry_out		:out std_logic);

end ALU;

architecture structure of ALU is
	
	component F_adder
		port( i_X 	:in std_logic;
			i_Y 	:in std_logic;
			i_C 	:in std_logic;
			o_S		:out std_logic;
			o_C		:out std_logic);
	end component;
	
	
	component andg2
		port(i_A     : in std_logic;
		i_B          : in std_logic;
		o_F          : out std_logic);
	end component;
	
	component mux8_1
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
	end component;
	
	component org2
		port(i_A     : in std_logic;
		i_B          : in std_logic;
		o_F          : out std_logic);
	end component;
	
	component invg
		port(i_A     : in std_logic;
		o_F          : out std_logic);
	end component;
	
	component mux
		port( i_S	:in std_logic;
		i_A		:in std_logic;
		i_B		:in std_logic;
		o_F		:out std_logic);
	end component;
	
	component xorg2
		port(i_A          : in std_logic;
			 i_B          : in std_logic;
			 o_F          : out std_logic);
		
	end component;
	
	signal F_A, F_B, invA, invB						: std_logic;	
	signal and_out, or_out, sum_out, xor_out		: std_logic;
	
	begin
	
	G0: invg
		port map(i_A	=> A,
		o_F		=> invA);
		
	G1: invg
		port map(i_A	=> B,
		o_F		=> invB);
		
	-- A invert on switch
	G2: mux
		port map(i_S	=> Ainvert,
			i_A			=> A,
			i_B			=> invA,
			o_F			=> F_A);
	
	
	-- B invert on switch
	G3: mux
		port map(i_S	=> Binvert,
			i_A			=> B,
			i_B			=> invB,
			o_F			=> F_B);
	
	-- and ALU calulation
	G4: andg2
		port map(i_A 	=> F_A,
		i_B          	=> F_B,
		o_F          	=> and_out);
	
	-- or ALU calculation
	G5: org2
		port map(i_A 	=> F_A,
		i_B          	=> F_B,
		o_F          	=> or_out);
		
	-- adder ALU calulation
	G6: F_adder
		port map( i_X 	=> F_A,
			i_Y 		=> F_B,
			i_C 		=> carry_in,
			o_S			=> sum_out,
			o_C			=> carry_out);
	-- xor calculation
	G7:xorg2
		port map(i_A	=> F_A,
			i_B			=> F_B,
			o_F			=> xor_out);
			
	G8: mux8_1
		port map(i_S	=> operation,
		i_Data0			=> and_out,
		i_Data1			=> or_out,
		i_Data2			=> sum_out,
		i_Data3			=> less,
		i_Data4			=> xor_out,
		i_Data5			=> and_out,
		i_Data6 		=> and_out,
		i_Data7 		=> and_out,

		o_Data			=> Result);
		
		set <= sum_out;
	
end structure;