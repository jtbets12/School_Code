library IEEE;
use IEEE.std_logic_1164.all;

entity MUX_STR is

   port(ia	:in std_logic;
	ib	:in std_logic;
	s	:in std_logic;
	o	:out std_logic);

end MUX_STR;

architecture structure of MUX_STR is

  component invg is

  	port(i_A          : in std_logic;
       	     o_F          : out std_logic);

  end component;

  component org2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);

  end component;

  component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);

  end component;

  signal s_N, s_1, s_2 : std_logic;


begin
 
  inv_s:invg
	port map(i_A => s,
		 o_F => s_N);

  andg_1: andg2
	port map(i_A => ib,
		 i_B => s,
		 o_F => s_1);

  andg_2: andg2
	port map(i_A => ia,
		 i_B => s_N,
		 o_F => s_2);

  org_End: org2
	port map(i_A => s_1,
	         i_B => s_2,
		 o_F => o);

end structure;
