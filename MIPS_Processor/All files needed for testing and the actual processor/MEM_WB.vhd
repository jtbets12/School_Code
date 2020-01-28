

library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WB is
	 generic(N : integer := 32);
	 port(
		CLK		:in std_logic;
		Flush	:in std_logic;
		Halt	:in std_logic;
		
		ALU_Result_in	:in	std_logic_vector(N-1 downto 0);
		ALU_Result_out	:out std_logic_vector(N-1 downto 0);
		
		memData_in	:in	std_logic_vector(N-1 downto 0);
		memData_out	:out std_logic_vector(N-1 downto 0);
		
		regWR_ADDR_in	:in	std_logic_vector(4 downto 0);
		regWR_ADDR_out  :out std_logic_vector(4 downto 0);		

		reg_WR_in	:in std_logic;
		reg_WR_out	:out std_logic;
		
		FW_in	:in	std_logic;
		FW_out	:out std_logic;
		
		JaL_Addr_in	:in	std_logic_vector(N-1 downto 0);
		JaL_Addr_out	:out std_logic_vector(N-1 downto 0);
		
		JaL_in	:in std_logic;
		JaL_out :out std_logic;			
		
		v0_in   : in std_logic_vector(N-1 downto 0);
		v0_out  : out std_logic_vector(N-1 downto 0);
		
		opcode_in  : in std_logic_vector(5 downto 0);
		opcode_out : out std_logic_vector(5 downto 0);
		
		funct_in   : in std_logic_vector(5 downto 0);
		funct_out   : out std_logic_vector(5 downto 0);
		
		memtoReg_in	:in	std_logic;
		memtoReg_out:out std_logic);		
end MEM_WB;

architecture structural of MEM_WB is
	
	
component N_reg is
	generic(N : integer := 32);
	port (i_WE 	:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		o_Data		:out std_logic_vector(N-1 downto 0));
end component;
	
component Five_reg is
	generic(N : integer := 5);
	port (i_WE 	:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		o_Data		:out std_logic_vector(N-1 downto 0));
end component;	

component Six_reg is
	generic(N : integer := 6);
	port (i_WE 	:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		o_Data		:out std_logic_vector(N-1 downto 0));
end component;
	
component  dff_user 

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end component;	

signal trueHalt : std_logic;


begin

	ALU_Result:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => ALU_Result_in,
			o_Data => ALU_Result_out);
			
	regWR_ADDR:Five_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => regWR_ADDR_in,
			o_Data => regWR_ADDR_out);				
	
	memData:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => memData_in,
			o_Data => memData_out);
			
	reg_WR:dff_user
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_D => reg_WR_in,
			o_Q => reg_WR_out);
			
	FW:dff_user
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_D => FW_in,
			o_Q => FW_out);
			
	memtoReg:dff_user
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_D => memtoReg_in,
			o_Q => memtoReg_out);

	v0:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_Data => v0_in,
			o_Data => v0_out);

	opcode:Six_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => opcode_in,
			o_Data => opcode_out);
			
	JaL_Addr:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => JaL_Addr_in,
			o_Data => JaL_Addr_out);
			
	JaL:dff_user
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_D => JaL_in,
			o_Q => JaL_out);		

	funct:Six_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => funct_in,
			o_Data => funct_out);	
			
end structural;