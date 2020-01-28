

-- Jacob Puetz
-- one complement



library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
	port( i_S	:in std_logic;
	i_A		:in std_logic;
	i_B		:in std_logic;
	o_F		:out std_logic);

end mux;

architecture structure of mux is


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
	signal and1          : std_logic;
	signal and2          : std_logic;
begin


	G1:andg2 
  	port map(i_A       => i_S,
     		i_B         => i_B,
     	 	o_F         => and1);



	G0:invg
	   port map( i_A  =>  i_S,
		o_F	=> noti_S );



	G2:andg2 
  	port map(i_A       => noti_S,
     	  	i_B         => i_A,
     	 	o_F         => and2);



	G3:org2
	Port map(i_A => and1,
		i_B 	=> and2,
		 o_F 	=> o_F);




end structure;