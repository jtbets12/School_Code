-- Jacob Puetz
-- PC module in proccessor


library IEEE;
use IEEE.std_logic_1164.all;

entity PC is
		generic(N : integer := 32);
	port(
		addr_i		: in std_logic_vector(N-1 downto 0);
		clk			: in std_logic;
		addr_o		: out std_logic_vector(N-1 downto 0);
		rst : in std_logic);

end PC;


 
architecture structure of PC is
 

	component pc_reg is

	  port(i_CLK        : in std_logic;     -- Clock input
		   i_RST        : in std_logic;     -- Reset input
		   i_WE         : in std_logic;     -- Write enable input
		   i_Data       : in std_logic_vector(N-1 downto 0);     -- Data value input
		   o_Data          : out std_logic_vector(N-1 downto 0));   -- Data value output

 end component;
 
 signal reset		: std_logic_vector(N-1 downto 0);
 
begin 

AHHH: process(rst, addr_i)
begin
	case rst is
		when '1' => reset <= x"00400000";
		when others => reset <= addr_i;
	end case;
end process;	
	
 	reg: pc_reg
		port map(i_CLK => clk,
		i_Data 	=>	reset,
		i_WE	=>	'1',
		i_RST	=>	'0',
		o_Data	=>	addr_o);
		
		
		
end structure;