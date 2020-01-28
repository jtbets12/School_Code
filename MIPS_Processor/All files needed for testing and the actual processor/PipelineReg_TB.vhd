library IEEE;
use IEEE.std_logic_1164.all;

entity PipelineReg_TB is
	  generic(gCLK_HPER   : time := 50 ns);
end PipelineReg_TB;

architecture behavioral of PipelineReg_TB is

		component IF_ID is
		 generic(N : integer := 32);
		 port(
			CLK		:in std_logic;
			Flush	:in std_logic;
			Halt	:in std_logic;
			
			PC_next_IN	:in	std_logic_vector(N-1 downto 0);
			PC_next_OUT	:out std_logic_vector(N-1 downto 0);
			
			Instruction_in	:in	std_logic_vector(N-1 downto 0);
			Instruction_out	:out std_logic_vector(N-1 downto 0));
	end component;
	
	component ID_EX is
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
			
			memtoReg_in	:in	std_logic;
			memtoReg_out:out std_logic;
			
			JaL_Addr_in		:in	std_logic_vector(N-1 downto 0);
			JaL_Addr_out	:out std_logic_vector(N-1 downto 0);
			
			JaL_in	:in std_logic;
			JaL_out :out std_logic;	
			
			jump_in  : in std_logic;
			jump_out : out std_logic;
			
			v0_in   : in std_logic_vector(N-1 downto 0);
			v0_out  : out std_logic_vector(N-1 downto 0);
			
			opcode_in  : in std_logic_vector(5 downto 0);
			opcode_out : out std_logic_vector(5 downto 0);
			
			funct_in   : in std_logic_vector(5 downto 0);
			funct_out   : out std_logic_vector(5 downto 0);			
			
			UpI_in  : in std_logic_vector(N-1 downto 0);
			UpI_out : out std_logic_vector(N-1 downto 0);
			
			ldUI_in	:in std_logic;
			ldUI_out:out std_logic		
			);
	end component;
	
	component EX_MEM is
		 generic(N : integer := 32);
		 port(
			CLK		:in std_logic;
			Flush	:in std_logic;
			Halt	:in std_logic;
			
			ALU_Result_in	:in	std_logic_vector(N-1 downto 0);
			ALU_Result_out	:out std_logic_vector(N-1 downto 0);
			
			Source_B_in	:in	std_logic_vector(N-1 downto 0);
			Source_B_out:out std_logic_vector(N-1 downto 0);
			
			regWR_ADDR_in	:in	std_logic_vector(4 downto 0);
			regWR_ADDR_out  :out std_logic_vector(4 downto 0);		

			memWR_in	:in std_logic;
			memWR_out	:out std_logic;
			
			memRE_in	:in	std_logic;
			memRE_out	:out std_logic;

			reg_WR_in	:in std_logic;
			reg_WR_out	:out std_logic;
			
			FW_in	:in	std_logic;
			FW_out	:out std_logic;
			
			ldUI_in	:in std_logic;
			ldUI_out:out std_logic;	
			
			v0_in   : in std_logic_vector(N-1 downto 0);
			v0_out  : out std_logic_vector(N-1 downto 0);
			
			JaL_Addr_in	:in	std_logic_vector(N-1 downto 0);
			JaL_Addr_out	:out std_logic_vector(N-1 downto 0);
			
			JaL_in	:in std_logic;
			JaL_out :out std_logic;	
			
			opcode_in  : in std_logic_vector(5 downto 0);
			opcode_out : out std_logic_vector(5 downto 0);
			
			funct_in   : in std_logic_vector(5 downto 0);
			funct_out   : out std_logic_vector(5 downto 0);
			
			UpI_in  : in std_logic_vector(N-1 downto 0);
			UpI_out : out std_logic_vector(N-1 downto 0);
			
			memtoReg_in	:in	std_logic;
			memtoReg_out:out std_logic);		
	end component;
	
	component MEM_WB is
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
			
			v0_in   : in std_logic_vector(N-1 downto 0);
			v0_out  : out std_logic_vector(N-1 downto 0);
			
			JaL_Addr_in	    :in	std_logic_vector(N-1 downto 0);
			JaL_Addr_out	:out std_logic_vector(N-1 downto 0);
			
			JaL_in	:in std_logic;
			JaL_out :out std_logic;	
			
			opcode_in  : in std_logic_vector(5 downto 0);
			opcode_out : out std_logic_vector(5 downto 0);
			
			funct_in   : in std_logic_vector(5 downto 0);
			funct_out   : out std_logic_vector(5 downto 0);
			
			FW_in	:in	std_logic;
			FW_out	:out std_logic;
			
			memtoReg_in	:in	std_logic;
			memtoReg_out:out std_logic);		
	end component;
	
	signal 	memWR_EX, memWR_MEM				  					:std_logic;
	signal  memRE_EX, memRE_MEM									:std_logic;
	signal  alu_control_EX										:std_logic_vector(13 downto 0);
	signal  alu_branch_EX										:std_logic_vector(1 downto 0);
	signal  ALUSrc_EX											:std_logic;
	signal  regDST_EX											:std_logic;
	signal  reg_WR_EX, reg_WR_MEM, reg_WR_WB 	            	:std_logic;
	signal  memtoReg_EX, memtoReg_MEM, memtoReg_WB 				:std_logic;
	signal  UpI_MEM, UpI_EX												:std_logic_vector(31 downto 0);
	signal  ldUI_EX, ldUI_MEM									:std_logic;
	signal  clk_tb, flush1_tb, flush2_tb, flush3_tb, flush4_tb  :std_logic;
	signal  halt1_tb, halt2_tb, halt3_tb, halt4_tb              :std_logic;
	signal  PC_in_tb, PC_out_tb									:std_logic_vector(31 downto 0);
	signal  Instruction_in_tb, Instruction_out_tb				:std_logic_vector(31 downto 0);
	signal  Reg_A_EX											:std_logic_vector(31 downto 0);
	signal  ALU_Result_MEM, ALU_Result_WB						:std_logic_vector(31 downto 0);
	signal  Reg_B_EX											:std_logic_vector(31 downto 0);
	signal  rs_EX, rt_EX, rd_EX									:std_logic_vector(4 downto 0);
	signal  immediate_EX										:std_logic_vector(31 downto 0);
	signal  memData_MEM, memData_WB								:std_logic_vector(31 downto 0);
	signal  regWR_ADDR_MEM, regWR_ADDR_WB						:std_logic_vector(4 downto 0);
	signal  FW_EX, FW_MEM, FW_WB								:std_logic;
	signal JaL_Addr_MEM, JaL_Addr_WB, JaL_Addr_EX				:std_logic_vector(31 downto 0);
	signal JaL_MEM, JaL_EX, JaL_WB								:std_logic;
	signal opcode_MEM, opcode_EX, opcode_WB						:std_logic_vector(5 downto 0);
	signal funct_EX, funct_MEM, funct_WB						:std_logic_vector(5 downto 0);
	signal v0_EX, v0_MEM, v0_WB									:std_logic_vector(31 downto 0);
	signal jump_EX												:std_logic;
	

	begin 
	
		First: IF_ID
			port map(CLK		=> clk_tb,
					 Flush		=> flush1_tb,
					 Halt		=> halt1_tb,
			
					 PC_next_IN	=> PC_in_tb,
					 PC_next_OUT =>	PC_out_tb,
			
					 Instruction_in	=>Instruction_in_tb, 
					 Instruction_out =>Instruction_out_tb);	

		Second: ID_EX
			port map(CLK		=> clk_tb,
					 Flush		=> flush2_tb,
					 Halt		=> halt2_tb,
			
					 Reg_A_in	=> Instruction_out_tb(31 downto 0),
					 Reg_A_out  => Reg_A_EX,
			
					 Reg_B_in   => PC_out_tb(31 downto 0),
					 Reg_B_out  => Reg_B_EX,
					 
					 rs_in      => Instruction_out_tb(25 downto 21),
					 rs_out     => rs_EX,
					 
					 rt_in      => Instruction_out_tb(20 downto 16),
					 rt_out     => rt_EX,
					 
					 rd_in      => Instruction_out_tb(15 downto 11),
					 rd_out     => rd_EX,
					 
					 immediate_in => Instruction_out_tb(31 downto 0),
					 immediate_out=> immediate_EX,
					 
					 alu_branch_in => Instruction_out_tb(1 downto 0),
					 alu_branch_out=> alu_branch_EX,
					 
					 ALUSrc_in     => Instruction_out_tb(1),
					 ALUSrc_out    => ALUSrc_EX,
					 
					 regDst_in     => Instruction_out_tb(2),
					 regDst_out    => regDST_EX,
					 
					 alu_control_in  => Instruction_out_tb(13 downto 0),
					 alu_control_out => alu_control_EX,
					 
					 memWR_in       => Instruction_out_tb(3),
					 memWR_out      => memWR_EX,
					 
					 memRE_in       => Instruction_out_tb(4),
					 memRE_out      => memRE_EX,
					 
					 reg_WR_in      => Instruction_out_tb(5),
					 reg_WR_out     => reg_WR_EX,
					 
					 FW_in          => Instruction_out_tb(6),
					 FW_out         => FW_EX,
					 
					 memtoReg_in    => Instruction_out_tb(7),
					 memtoReg_out   => memtoReg_EX,
					 
					 opcode_in		=> Instruction_out_tb(5 downto 0),
					 opcode_out		=> opcode_EX,
					 
					 funct_in		=> Instruction_out_tb(5 downto 0),
					 funct_out		=> funct_EX,
					 
					 jump_in		=> Instruction_out_tb(0),
					 jump_out		=> jump_EX,
					 
					 v0_in			=> Instruction_out_tb,
					 v0_out			=> v0_EX,
						
					 JaL_Addr_in	=> Instruction_out_tb,
					 JaL_Addr_out 	=> JaL_Addr_EX,
					 
					 JaL_in			=> Instruction_out_tb(0),
					 JaL_out        => JaL_EX,
					 
					 UpI_in			=> Instruction_out_tb,
					 UpI_out		=> UpI_EX,
					 
					 ldUI_in        => Instruction_out_tb(8),
					 ldUI_out       => ldUI_EX);

		Third: EX_MEM
			port map(CLK		=> clk_tb,
					 Flush		=> flush3_tb,
					 Halt		=> halt3_tb,
			
					 ALU_Result_in	=> Reg_A_EX,
					 ALU_Result_out  =>	ALU_Result_MEM,
			
					 Source_B_in   => Reg_B_EX,
					 Source_B_out  => memData_MEM,
					 
					 regWR_ADDR_in  => rd_EX,
					 regWR_ADDR_out => regWR_ADDR_MEM,
					 
					 memWR_in       => memWR_EX,
					 memWR_out      => memWR_MEM,
					 
					 memRE_in       => memRE_EX,
					 memRE_out      => memRE_MEM,
					 
					 reg_WR_in      => reg_WR_EX,
					 reg_WR_out     => reg_WR_MEM,
					 
					 UpI_in         => Reg_A_EX,
					 UpI_out		=> UpI_MEM,
					 
					 opcode_in		=> opcode_EX,
					 opcode_out		=> opcode_MEM,
					 
					 funct_in		=> funct_EX,
					 funct_out		=> funct_MEM,
					 
					 JaL_Addr_in	=> JaL_Addr_EX,
					 JaL_Addr_out	=> JaL_Addr_MEM,
					 
					 JaL_in			=> JaL_EX,
					 JaL_out        => JaL_MEM,
					 
					 v0_in			=> v0_EX,
					 v0_out			=> v0_MEM,
					 
					 FW_in          => FW_EX,
					 FW_out         => FW_MEM,
					 
					 ldUI_in	    => ldUI_EX,
					 ldUI_out       => ldUI_MEM,
					 
					 memtoReg_in    => memtoReg_EX,
					 memtoReg_out   => memtoReg_MEM);

		Fourth: MEM_WB
			port map(CLK		=> clk_tb,
					 Flush		=> flush4_tb,
					 Halt		=> halt4_tb,
			
					 ALU_Result_in	=> ALU_Result_MEM,
					 ALU_Result_out  =>	ALU_Result_WB,
			
					 memData_in   => memData_MEM,
					 memData_out  => memData_WB,
					 
					 regWR_ADDR_in  => regWR_ADDR_MEM,
					 regWR_ADDR_out => regWR_ADDR_WB,
					 
					 reg_WR_in      => reg_WR_MEM,
					 reg_WR_out     => reg_WR_WB,
					 
					 opcode_in		=> opcode_MEM,
					 opcode_out		=> opcode_WB,
					 
					 funct_in		=> funct_MEM,
					 funct_out		=> funct_WB,
					 
					 JaL_Addr_in	=> JaL_Addr_MEM,
					 JaL_Addr_out	=> JaL_Addr_WB,
					 
					 JaL_in			=> JaL_MEM,
					 JaL_out		=> JaL_WB,
					 
					 v0_in			=> v0_MEM,
					 v0_out			=> v0_WB,
					 
					 FW_in          => FW_MEM,
					 FW_out         => FW_WB,
					 
					 memtoReg_in    => memtoReg_MEM,
					 memtoReg_out   => memtoReg_WB);	

	  P_CLK: process
	  begin
		clk_tb <= '0';
		wait for gCLK_HPER;
		clk_tb <= '1';
		wait for gCLK_HPER;
	  end process;			
	  
	test: process
		begin
		
		
		--Initial put
		Instruction_in_tb <= x"11111111";
		PC_in_tb          <= x"12345678";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		
		--2
		Instruction_in_tb <= x"22222222";
		PC_in_tb          <= x"23456789";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--3
		Instruction_in_tb <= x"33333333";
		PC_in_tb          <= x"34567890";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;

		--4
		Instruction_in_tb <= x"44444444";
		PC_in_tb          <= x"45678901";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;

		--5
		Instruction_in_tb <= x"55555555";
		PC_in_tb          <= x"56789012";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;

		--6
		Instruction_in_tb <= x"66666666";
		PC_in_tb          <= x"67890123";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;

		--7
		Instruction_in_tb <= x"77777777";
		PC_in_tb          <= x"78901234";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;

		--8, testing IF/ID stall
		Instruction_in_tb <= x"88888888";
		PC_in_tb          <= x"11111111";
		halt1_tb		  <= '0';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--9, testing IF/ID flush
		Instruction_in_tb <= x"99999999";
		PC_in_tb          <= x"22222222";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '1';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--10, testing ID/EX stall
		Instruction_in_tb <= x"AAAAAAAA";
		PC_in_tb          <= x"33333333";
		halt1_tb		  <= '1';
		halt2_tb		  <= '0';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--11, testing ID/EX flush
		Instruction_in_tb <= x"BBBBBBBB";
		PC_in_tb          <= x"44444444";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '1';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--12, testing EX/MEM stall
		Instruction_in_tb <= x"CCCCCCCC";
		PC_in_tb          <= x"55555555";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '0';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--13, testing EX/MEM flush
		Instruction_in_tb <= x"DDDDDDDD";
		PC_in_tb          <= x"66666666";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '1';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--14, testing MEM/WB stall
		Instruction_in_tb <= x"EEEEEEEE";
		PC_in_tb          <= x"77777777";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '0';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '0';
		wait for 100 ns;
		
		--15, testing MEM/WB flush
		Instruction_in_tb <= x"FFFFFFFF";
		PC_in_tb          <= x"88888888";
		halt1_tb		  <= '1';
		halt2_tb		  <= '1';
		halt3_tb		  <= '1';
		halt4_tb		  <= '1';
		flush1_tb		  <= '0';
		flush2_tb		  <= '0';
		flush3_tb		  <= '0';
		flush4_tb		  <= '1';
		wait for 100 ns;
		
	end process;
	
end behavioral;	
		
		
	
					 