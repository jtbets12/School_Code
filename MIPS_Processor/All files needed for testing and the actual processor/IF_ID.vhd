
library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID is
	 generic(N : integer := 32);
	 port(
		CLK		:in std_logic;
		Flush	:in std_logic;
		Halt	:in std_logic;
		
		PC_next_IN	:in	std_logic_vector(N-1 downto 0);
		PC_next_OUT	:out std_logic_vector(N-1 downto 0);
		
		Instruction_in	:in	std_logic_vector(N-1 downto 0);
		Instruction_out	:out std_logic_vector(N-1 downto 0));
end IF_ID;

architecture structural of IF_ID is
	
	
component N_reg is
	generic(N : integer := 32);
	port (i_WE 	:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		o_Data		:out std_logic_vector(N-1 downto 0));
end component;
	

begin

	PC:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => PC_next_IN,
			o_Data => PC_next_OUT);
	
	Inst:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => Instruction_in,
			o_Data => Instruction_out);
			
end structural;
