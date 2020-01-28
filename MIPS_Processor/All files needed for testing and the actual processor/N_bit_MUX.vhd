

-- Jacob Puetz
-- one complement



library IEEE;
use IEEE.std_logic_1164.all;

entity muxN is
	generic(N : integer := 32);

	port( i_S	:in std_logic;
	i_X		:in std_logic_vector(N-1 downto 0);
	i_Y		:in std_logic_vector(N-1 downto 0);
	o_Z		:out std_logic_vector(N-1 downto 0));

end muxN;

architecture structure of muxN is


   component  xorg 

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;

  component  invg 

  port(i_A          : in std_logic;
       o_F          : out std_logic);
 end component;


   component  org2

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;
	
  component andg2

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

  end component;


	signal noti_S          : std_logic;
	signal and1          : std_logic_vector(N-1 downto 0);
	signal and2          : std_logic_vector(N-1 downto 0);
begin

G4: for i in 0 to N-1 generate

	G1_i:andg2 
  	port map(i_A       => i_S,
     		i_B         => i_Y(i),
     	 	o_F         => and1(i));



	G0_i:invg
	   port map( i_A  =>  i_S,
		o_F	=> noti_S );



	G2_i:andg2 
  	port map(i_A       => noti_S,
     	  	i_B         => i_X(i),
     	 	o_F         => and2(i));



	G3_i:org2
	Port map(i_A => and1(i),
		i_B 	=> and2(i),
		 o_F 	=> o_Z(i));

end generate;


end structure;