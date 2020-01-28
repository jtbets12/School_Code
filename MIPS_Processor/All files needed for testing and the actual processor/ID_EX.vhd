

library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX is
	 generic(N : integer := 32);
	 port(
		CLK		:in std_logic;
		Flush	:in std_logic;
		Halt	:in std_logic;
		
		Reg_A_in	:in	std_logic_vector(N-1 downto 0);
		Reg_A_out	:out std_logic_vector(N-1 downto 0);
		
		Reg_B_in	:in	std_logic_vector(N-1 downto 0);
		Reg_B_out	:out std_logic_vector(N-1 downto 0);
			
		rs_in	:in	std_logic_vector(4 downto 0);
		rs_out	:out std_logic_vector(4 downto 0);
		
		rt_in	:in	std_logic_vector(4 downto 0);
		rt_out	:out std_logic_vector(4 downto 0);
		
		rd_in	:in	std_logic_vector(4 downto 0);
		rd_out	:out std_logic_vector(4 downto 0);		
		
		immediate_in	:in	std_logic_vector(N-1 downto 0);
		immediate_out	:out std_logic_vector(N-1 downto 0);

		alu_branch_in	:in std_logic_vector(1 downto 0);
		alu_branch_out	:out std_logic_vector(1 downto 0);
		
		ALUSrc_in	:in std_logic;
		ALUSrc_out	:out std_logic;
		
		regDst_in	:in std_logic;
		regDst_out	:out std_logic;
		
		alu_control_in	:in	std_logic_vector(14-1 downto 0);
		alu_control_out	:out std_logic_vector(14-1 downto 0);
				
		memWR_in	:in std_logic;
		memWR_out	:out std_logic;
		
		memRE_in	:in	std_logic;
		memRE_out	:out std_logic;
		
		reg_WR_in	:in std_logic;
		reg_WR_out	:out std_logic;
		
		FW_in	:in	std_logic;
		FW_out	:out std_logic;
		
		jump_in : in std_logic;
		jump_out :out std_logic;
		
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
		memtoReg_out	:out std_logic;
		
		UpI_in  : in std_logic_vector(N-1 downto 0);
		UpI_out : out std_logic_vector(N-1 downto 0);
		
		ldUI_in	:in std_logic;
		ldUI_out:out std_logic		
		);
end ID_EX;

architecture structural of ID_EX is
	
	
component N_reg is
	generic(N : integer := 32);
	port (i_WE 	:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		o_Data		:out std_logic_vector(N-1 downto 0));
end component;

component Two_reg is
	generic(N : integer := 2);
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

component Fourteen_reg is
	generic(N : integer := 14);
	port (i_WE 	:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		o_Data		:out std_logic_vector(N-1 downto 0));
end component;

component Sixteen_reg is
	generic(N : integer := 16);
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

begin

	Reg_A:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => Reg_A_in,
			o_Data => Reg_A_out);
	
	Reg_B:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => Reg_B_in,
			o_Data => Reg_B_out);
			
	rs:Five_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => rs_in,
			o_Data => rs_out);
			
	rt:Five_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => rt_in,
			o_Data => rt_out);		

	rd:Five_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => rd_in,
			o_Data => rd_out);			
			
	immediate:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => immediate_in,
			o_Data => immediate_out);
	
	regDst:dff_user
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_D => regDst_in,
				o_Q => regDst_out);
				
	jumpCONTROL:dff_user
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_D => jump_in,
				o_Q => jump_out);			
				
	alu_branch:Two_reg
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_data => alu_branch_in,
				o_Data => alu_branch_out);
				
	alu_contol:Fourteen_reg	
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_Data => alu_control_in,
				o_Data => alu_control_out);
				
	aluSrc:dff_user	
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_D => ALUSrc_in,
				o_Q => ALUSrc_out);
			
	ldUI:dff_user
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_D => ldUI_in,
				o_Q => ldUI_out);	
				
	memWR:dff_user
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_D => memWR_in,
				o_Q => memWR_out);
			
	memRE:dff_user
		port map(
				i_CLK =>  CLK,
				i_RST => Flush,
				i_WE => HALT,
				i_D => memRE_in,
				o_Q => memRE_out);		

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

	UpI_Reg:N_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => UpI_in,
			o_Data => UpI_out);
			
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

	funct:Six_reg
		port map(
			i_CLK =>  CLK,
			i_RST => Flush,
			i_WE => HALT,
			i_data => funct_in,
			o_Data => funct_out);				
			
end structural;