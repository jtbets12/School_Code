library IEEE;
use IEEE.std_logic_1164.all;

entity Fourteen_reg is 

	generic(N : integer := 14);

	port (i_WE 	:in std_logic;
	i_Data		:in std_logic_vector(N-1 downto 0);
	i_CLK		:in std_logic;
	i_RST		:in std_logic;
	o_Data		:out std_logic_vector(N-1 downto 0));

end Fourteen_reg;

architecture structure of Fourteen_reg is

   component  dff_user 

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

 end component;



begin	


	G0: for i in 0 to N-1 generate

		G1_i: dff_user
			port map(i_CLK => i_CLK,
			i_D 	=>	i_Data(i),
			i_WE	=>	i_WE,
			i_RST	=>	i_RST,
			o_Q	=>	o_Data(i));
			



	end generate;


end structure;