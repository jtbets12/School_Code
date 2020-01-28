-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  --signal reg1_addr, reg2_addr															: std_logic_vector(4 downto 0);
  
  --PC signals
  signal nextPcValue, PC_out_IF_ID														: std_logic_vector(N-1 downto 0);
  
  --Instruction signals
  signal Inst_IF_ID																		: std_logic_vector(N-1 downto 0);  
  
  --immediate signals
  signal immediate_ID, immediate_EX														: std_logic_vector(31 downto 0);
  signal sign_ext_c_ID																	: std_logic;
	
  --regWR_ADDR signals 
  signal regWR_ADDR_EX, regWR_ADDR_MEM, regWR_ADDR_WB													: std_logic_vector(4 downto 0);
  signal rs_EX, rt_EX, rd_EX															: std_logic_vector(4 downto 0);
  
  --regWR signals
  signal reg_WR_ID, reg_WR_EX, reg_WR_MEM												: std_logic;
  
  --memRE signals
  signal memRE_ID, memRE_EX, memRE_MEM													: std_logic;
  signal memData_WB																		:std_logic_vector(31 downto 0);
  
  --memWR signals
  signal memWR_ID, memWR_EX																: std_logic;
  
  --ALU Result signals
  signal ALU_Result_EX, ALU_Result_MEM, ALU_Result_WB, regularRegWrite_DATA				: std_logic_vector(N-1 downto 0);
	
  --RegA signals
  signal Reg_A_ID, Reg_A_EX   															: std_logic_vector(N-1 downto 0);
  
  --RegB/SourceB signals
  signal Reg_B_ID, Reg_B_EX, Source_B_ID, Source_B_EX									: std_logic_vector(N-1 downto 0);
  
  --ldUI signals
  signal ldUI_ID, ldUI_EX, ldUI_MEM														: std_logic;
  signal UpI_ID, UpI_EX, UpI_MEM														: std_logic_vector(N-1 downto 0);
  
  --Control misc signals
  signal ALU_control_ID, ALU_control_EX									  				: std_logic_vector(13 downto 0);
  signal ALUSrc_ID, ALUSrc_EX															: std_logic;
  signal regDST_ID, regDST_EX															: std_logic;
  
  --memtoReg signals
  signal memtoReg_ID, memtoReg_EX, memtoReg_MEM, memtoReg_WB							: std_logic;	
  
  --Branch signals
  signal branch_MUX_result, immediate_sl2, branchMovement								: std_logic_vector(N-1 downto 0);
  signal alu_branch_ID, alu_branch_EX													: std_logic_vector(1 downto 0); 
  signal brCO, zero_ID, brMuxCtrl														: std_logic;
  signal IF_ID_FLUSH, IF_ID_HALT																	: std_logic;
  
  --Jump signals
  signal jump_ID																		: std_logic_vector(1 downto 0);
  signal PC_in_IF_ID,  j_addr, jump_func												: std_logic_vector(N-1 downto 0);
  signal jumpMuxCtrl, jalInputControl, Cout_jal											: std_logic;
  
  --Halt dependent signals
  signal opcode_EX, opcode_MEM, opcode_WB, funct_EX, funct_MEM, funct_WB				: std_logic_vector(5 downto 0);
  signal v0_EX, v0_ID, v0_MEM															: std_logic_vector(N-1 downto 0);
  
  --FW signals
  signal FW_ID, FW_EX, FW_MEM, FW_WB													: std_logic;
  
  --JaL signals
   signal JaL_Addr_ID_EX,  JaL_Addr_EX_MEM, JaL_Addr_MEM_WB								: std_logic_vector(N-1 downto 0);
   signal JaL_ID_EX,  JaL_EX_MEM, JaL_MEM_WB											: std_logic;
  
 --Extra signals
 signal overflow, zero, carry, trash_o, carry_ID 										: std_logic;
 signal jump_EX_hazard  																: std_logic;

 
 
  
  
  
	
  component Control_ALU is 
	port(opcode : in std_logic_vector(5 downto 0);
		 funct : in std_logic_vector(5 downto 0);
		 ALUSrc : out std_logic;
		 ALUControl : out std_logic_vector(4 downto 0);
		 MemtoReg : out std_logic;
		 s_DMemWr : out std_logic;
		 s_RegWr : out std_logic;
		 ALUShift_ctrl : out std_logic_vector(3 downto 0);
		 RegDst : out std_logic;
		 loadUI : out std_logic;
		 branch : out std_logic_vector(1 downto 0);
		 jump : out std_logic_vector(1 downto 0);
		 arith_bool : out std_logic);
		 
	end component;
	
	component invg is

	port(i_A          : in std_logic;
       o_F          : out std_logic);

	end component;
  
  component ALU_SHIFT is
	port(A_in : in std_logic_vector(31 downto 0);
	     B_in : in std_logic_vector(31 downto 0);
	     Ov_Fl : out std_logic;
	     zero : out std_logic;
	     output : out std_logic_vector(31 downto 0);
	     Control : in std_logic_vector(13 downto 0);
	     carry_out : out std_logic;
		 branch : in std_logic_vector(1 downto 0));
	end component;

	component regs is 
		generic(N : integer := 32);
		port (
		i_WE 		:in std_logic;
		i_Data		:in std_logic_vector(N-1 downto 0);
		i_CLK		:in std_logic;
		i_RST		:in std_logic;
		rd		:in std_logic_vector(4 downto 0);
		rs		:in std_logic_vector(4 downto 0);
		rt		:in std_logic_vector(4 downto 0);

		o_Data1		:out std_logic_vector(N-1 downto 0);
		o_Data2		:out std_logic_vector(n-1 downto 0);
		o_reg2      :out std_logic_vector(n-1 downto 0));
	end component;

	component muxND is
		generic(N : integer := 32);

		port( i_S	:in std_logic;
		i_X		:in std_logic_vector(N-1 downto 0);
		i_Y		:in std_logic_vector(N-1 downto 0);
		o_Z		:out std_logic_vector(N-1 downto 0));

	end component;


	component F_adder10D is

		generic(N : integer := 32);

		port( i_X 	:in std_logic_vector(N-1 downto 0);
			i_Y 		:in std_logic_vector(N-1 downto 0);
			i_C 		:in std_logic;
			o_S		:out std_logic_vector(N-1 downto 0);
			o_C		:out std_logic);

	end component;

	component mux5D is
		generic(N : integer := 5);

		port( i_S	:in std_logic;
		i_X		:in std_logic_vector(N-1 downto 0);
		i_Y		:in std_logic_vector(N-1 downto 0);
		o_Z		:out std_logic_vector(N-1 downto 0));

	end component;


	component sign_ext is
		port(
			sign_ext_c :in std_logic;
			i_Sign	:in std_logic_vector(15 downto 0);
			o_Sign	:out std_logic_vector(31 downto 0));
	end component;

	component pc_reg is

		  port(i_CLK        : in std_logic;     -- Clock input
			   i_RST        : in std_logic;     -- Reset input
			   i_WE         : in std_logic;     -- Write enable input
			   i_Data       : in std_logic_vector(N-1 downto 0);     -- Data value input
			   o_Data          : out std_logic_vector(N-1 downto 0));   -- Data value output

	 end component;

	component andg2 is

	  port(i_A          : in std_logic;
		   i_B          : in std_logic;
		   o_F          : out std_logic);

	end component;

	component shift_left_two is 

		port(i_A          : in std_logic_vector(31 downto 0);
			 o_F          : out std_logic_vector(31 downto 0));

	end component;

	component org2 is

	  port(i_A          : in std_logic;
		   i_B          : in std_logic;
		   o_F          : out std_logic);

	end component;

	component xorg2 is

	  port(i_A          : in std_logic;
		   i_B          : in std_logic;
		   o_F          : out std_logic);

	end component;
	
	--Added to be used to find zero flag
	component ALU_32bit is 
   		port(A : in std_logic_vector(31 downto 0);
		     B : in std_logic_vector(31 downto 0); 
		     control : in std_logic_vector(4 downto 0);
		     zero : out std_logic;
			 branchOp : in std_logic;
		     carryOut : out std_logic;
		     overflow : out std_logic;
		     o_F : out std_logic_vector(31 downto 0));
	end component;

--PIPELINE REGISTERS

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
			
			v0_in   : in std_logic_vector(N-1 downto 0);
			v0_out  : out std_logic_vector(N-1 downto 0);
			
			opcode_in  : in std_logic_vector(5 downto 0);
			opcode_out : out std_logic_vector(5 downto 0);
			
			funct_in   : in std_logic_vector(5 downto 0);
			funct_out   : out std_logic_vector(5 downto 0);
			
			UpI_in  : in std_logic_vector(N-1 downto 0);
			UpI_out : out std_logic_vector(N-1 downto 0);
			
			JaL_Addr_in	:in	std_logic_vector(N-1 downto 0);
			JaL_Addr_out	:out std_logic_vector(N-1 downto 0);
			
			JaL_in	:in std_logic;
			JaL_out :out std_logic;	
			
			ldUI_in	:in std_logic;
			ldUI_out:out std_logic;	
			
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
	end component;



		

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;
	  		
	

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => Inst_IF_ID);
  


  s_Halt <='1' when (opcode_WB = "000000") and (funct_WB = "001100") and (v0_ID = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 
  
	
  
  
	PC_sim:pc_reg
		port map(
		   i_CLK        => iCLK,
		   i_RST        => iRST,
		   i_WE         => '1',
		   i_Data       => nextPcValue, --Mapped to Jump MUX
		   o_Data       => s_NextInstAddr);

  PC_addr_add: F_adder10D
	port map(
		i_X 	=> s_NextInstAddr,
		i_Y 	=> "00000000000000000000000000000100",
		i_C 	=> '0',
		o_S		=> PC_in_IF_ID,
		o_C		=> carry);
		

		
	First: IF_ID
		port map(CLK		=> iCLK,
				 Flush		=> iRST,
				 Halt		=> '1',
		
				 PC_next_IN	=> PC_in_IF_ID,
				 PC_next_OUT =>	PC_out_IF_ID,
		
				 Instruction_in	=>Inst_IF_ID, 
				 Instruction_out =>s_Inst);		
	
	-- gets the shamt/shift ammout into the controller
	ALU_control_ID(9 downto 5)	<= s_Inst(10 downto 6);
	
		
	control:Control_ALU 
		port map(opcode 		=> s_Inst(31 downto 26),
			 funct 				=> s_Inst(5 downto 0),
			 ALUSrc 			=> ALUSrc_ID,
			 ALUControl 		=> ALU_control_ID(4 downto 0), -- direct alu control(add,sub,and,or, ect.)
			 MemtoReg 			=> memtoReg_ID,
			 s_DMemWr 			=> memWR_ID,
			 s_RegWr 			=> reg_WR_ID,
			 ALUShift_ctrl 		=> ALU_control_ID(13 downto 10), --controls if shifting then how and direction.
			 RegDst 			=> regDST_ID,
			 loadUI				=> ldUI_ID,
			 branch 			=> alu_branch_ID,
		     jump 				=> jump_ID,
			 arith_bool			=> sign_ext_c_ID);
			 
	RegDataJALControl:muxND
	port map(
		i_S				=> JaL_MEM_WB,
		i_X				=> regularRegWrite_DATA,
		i_Y				=> JaL_Addr_MEM_WB,
		o_Z				=> s_RegWrData);
		
	regWR_ADDR_MUX:mux5D
		port map(
			i_S		=> JaL_MEM_WB,
			i_X		=> regWR_ADDR_WB,
			i_Y		=> "11111",
			o_Z		=> s_RegWrAddr);	

		
	  Reg:regs
		  port map( i_WE 		=>s_RegWr,
			i_Data				=>s_RegWrData,
			i_CLK				=>iCLK,
			i_RST				=>iRST,
			rd					=>s_RegWrAddr,
			rs					=>s_Inst(25 downto 21),
			rt					=>s_Inst(20 downto 16),
			

			o_Data1				=> Reg_A_ID,
			o_Data2				=> Reg_B_ID,
			o_reg2				=> v0_ID);	
			
	sign_extention_ID:sign_ext
	port map(
		sign_ext_c => sign_ext_c_ID,
		i_Sign	=> s_Inst(15 downto 0),
		o_Sign	=> immediate_ID);
	
	ALUSrcMUX_ID:muxND
	port map(
		i_S				=> ALUSrc_ID,
		i_X				=> Reg_B_ID,
		i_Y				=> immediate_ID,
		o_Z				=> Source_B_ID);
		
	--Being used to find zero flag
	ALU:ALU_32bit
	port map(A 		=> Reg_A_ID,
	     B 			=> Source_B_ID,
	     zero 			=> zero_ID,
	     overflow 		=> overflow,
	     control 		=> ALU_control_ID(4 downto 0),
	     carryOut 		=> carry_ID,
		 branchop 		=> alu_branch_ID(1));

			--Branch portion	
	BranchCon: andg2
		port map(i_A => alu_branch_ID(0),
				 i_B => zero_ID,
				 o_F => brMuxCtrl);
				 
	BranchShift: shift_left_two
		port map(i_A  => immediate_ID,
				 o_F  => immediate_sl2);
				 
	BranchADDALU: F_adder10D
		port map( i_X  => PC_out_IF_ID,
				  i_Y  => immediate_sl2,
				  i_C  => '0',
				  o_S  => branchMovement,
				  o_C  => brCO);
				 
	BranchMUX: muxND
		port map(i_S	=> brMuxCtrl,
				 i_X	=> PC_in_IF_ID,
				 i_Y	=> branchMovement,
				 o_Z	=> branch_MUX_result);
				 
	--This and gate is for allowing jal instructions since when both JU_MP bits are 1 it is a jal command
	jalControl: andg2
    port map(i_A  => jump_ID(0),
			 i_B  => jump_ID(1),
		     o_F  => jalInputControl);
			 
	Jump_Shift_Part1: for i in 25 downto 0 generate
		j_addr(i+2) <= s_Inst(i);
	end generate;
	Jump_Shift_Part2: for i in 1 downto 0 generate
		j_addr(i) <= '0';
	end generate;
	Jump_addr_creation: for i in 31 downto 28 generate
		j_addr(i) <= PC_out_IF_ID(i);
	end generate;
	
	
	jumpPermission: org2 
		  port map(i_A    => jump_ID(0),
				   i_B    => jump_ID(1),
				   o_F    => jumpMuxCtrl);
	
	
	whichJump: muxND
	port map(i_S	=> jump_ID(1),
			 i_X	=> Reg_A_ID,
			 i_Y	=> j_addr,
			 o_Z	=> jump_func);
	
	
	
	jumpMUX: muxND
	port map(i_S	=> jumpMuxCtrl,
			 i_X	=> branch_MUX_result,
			 i_Y	=> jump_func,
			 o_Z	=> nextPcValue);			

	UpperI: for i in 31 downto 16 generate
	UpI_ID(i) <= s_Inst(i-16);
		end generate;

	Lower0: for i in 15 downto 0 generate
	upI_ID(i) <= '0';
		end generate;	
		
	
			 
	Second: ID_EX
			port map(CLK		=> iCLK,
					 Flush		=> iRST,
					 Halt		=> '1',
			
					 Reg_A_in	=> Reg_A_ID,
					 Reg_A_out  => Reg_A_EX,
			
					 Reg_B_in   => Reg_B_ID,
					 Reg_B_out  => Reg_B_EX,
					 
					 rs_in      => s_Inst(25 downto 21),
					 rs_out     => rs_EX,
					 
					 rt_in      => s_Inst(20 downto 16),
					 rt_out     => rt_EX,
					 
					 rd_in      => s_Inst(15 downto 11),
					 rd_out     => rd_EX,
					 
					 immediate_in => immediate_ID,
					 immediate_out=> immediate_EX,
					 
					 alu_branch_in => alu_branch_ID,
					 alu_branch_out=> alu_branch_EX,
					 
					 ALUSrc_in     => ALUSrc_ID,
					 ALUSrc_out    => ALUSrc_EX,
					 
					 regDst_in     => regDST_ID,
					 regDst_out    => regDST_EX,
					 
					 alu_control_in  => ALU_control_ID,
					 alu_control_out => ALU_control_EX,
					 
					 memWR_in       => memWR_ID,
					 memWR_out      => memWR_EX,
					 
					 memRE_in       => memRE_ID,
					 memRE_out      => memRE_EX,
					 
					 reg_WR_in      => reg_WR_ID,
					 reg_WR_out     => reg_WR_EX,
					 
					 FW_in          => FW_ID,
					 FW_out         => FW_EX,
					 
					 memtoReg_in    => memtoReg_ID,
					 memtoReg_out   => memtoReg_EX,
					 
					 UpI_in			=> UpI_ID,
					 UpI_out		=> UpI_EX,
					 
					 v0_in			=> v0_ID,
					 v0_out			=> v0_EX,
					 
					 jump_in		=> jumpMuxCtrl,
					 jump_out		=> jump_EX_hazard,
					 
					 JaL_Addr_in	=> PC_out_IF_ID,
					 JaL_Addr_out	=> JaL_Addr_ID_EX,
					
					 JaL_in			=> jalInputControl,
					 JaL_out 		=> JaL_ID_EX,
					 
					 opcode_in		=> s_Inst(31 downto 26),
					 opcode_out		=> opcode_EX,
					 
					 funct_in		=> s_Inst(5 downto 0),
					 funct_out		=> funct_EX,
					 
					 ldUI_in        => ldUI_ID,
					 ldUI_out       => ldUI_EX);		 
  
	regDSTMUX:mux5D
		port map(
			i_S		=>regDST_EX,
			i_X		=>rd_EX,
			i_Y		=>rt_EX,
			o_Z		=>regWR_ADDR_EX);
			

  --reg1_addr <= s_Inst(25 downto 21); -- register 1 output location
  --reg2_addr <= s_Inst(20 downto 16); -- register 2 output location
  
  --s_DMemData <= Reg_out_B;

  
  ALUSrcMUX:muxND
	port map(
		i_S				=> ALUSrc_EX,
		i_X				=> Reg_B_EX,
		i_Y				=> immediate_EX,
		o_Z				=> Source_B_EX);
  
  
  ALU_EX:ALU_SHIFT
	port map(A_in 		=> Reg_A_EX,
	     B_in 			=> Source_B_EX,
	     Ov_Fl 			=> overflow,
	     zero 			=> zero,
	     output 		=> ALU_Result_EX,
	     Control 		=> ALU_control_EX,
	     carry_out 		=> carry,
		 branch 		=> alu_branch_EX);
		 
	--s_DMemAddr <= ALU_OUT;
	oALUOut <= ALU_Result_EX;
	
	Third: EX_MEM
			port map(CLK		=> iCLK,
					 Flush		=> iRST,
					 Halt		=> '1',
			
					 ALU_Result_in	=> ALU_Result_EX,
					 ALU_Result_out  =>	s_DMemAddr,
			
					 Source_B_in   => Reg_B_EX,
					 Source_B_out  => s_DMemData,
					 
					 regWR_ADDR_in  => regWR_ADDR_EX,
					 regWR_ADDR_out => regWR_ADDR_MEM,
					 
					 memWR_in       => memWR_EX,
					 memWR_out      => s_DMemWr,
					 
					 memRE_in       => memRE_EX,
					 memRE_out      => memRE_MEM,
					 
					 reg_WR_in      => reg_WR_EX,
					 reg_WR_out     => reg_WR_MEM,
					 
					 FW_in          => FW_EX,
					 FW_out         => FW_MEM,
					 
					 ldUI_in		=> ldUI_EX,
					 ldUI_out		=> ldUI_MEM,
					 
					 UpI_in			=> UpI_EX,
					 UpI_out		=> UpI_MEM,
					 
					 v0_in			=> v0_EX,
					 v0_out			=> v0_MEM,
					 
					 JaL_Addr_in	=> JaL_Addr_ID_EX,
					 JaL_Addr_out	=> JaL_Addr_EX_MEM,
					
					 JaL_in			=> JaL_ID_EX,
					 JaL_out 		=> JaL_EX_MEM,
					 
					 opcode_in		=> opcode_EX,
					 opcode_out		=> opcode_MEM,
					 
					 funct_in		=> funct_EX,
					 funct_out		=> funct_MEM,
					 
					 memtoReg_in    => memtoReg_EX,
					 memtoReg_out   => memtoReg_MEM);
					 
					 
	DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
			port map(clk  => iCLK,
				addr => s_DMemAddr(11 downto 2),
				data => s_DMemData,
				we   => s_DMemWr,
				q    => s_DMemOut);				 
			
		
	LoadUIException: muxND
	port map(i_S => ldUI_MEM,
	i_X			 => s_DMemAddr,
	i_Y			 => UpI_MEM,
	o_Z			 => ALU_Result_MEM);		
			
		 
	Fourth: MEM_WB
			port map(CLK		=> iCLK,
					 Flush		=> iRST,
					 Halt		=> '1',
			
					 ALU_Result_in	=> ALU_Result_MEM,
					 ALU_Result_out  =>	ALU_Result_WB,
			
					 memData_in   => s_DMemOut,
					 memData_out  => memData_WB,
					 
					 regWR_ADDR_in  => regWR_ADDR_MEM,
					 regWR_ADDR_out => regWR_ADDR_WB,
					 
					 reg_WR_in      => reg_WR_MEM,
					 reg_WR_out     => s_RegWr,
					 
					 FW_in          => FW_MEM,
					 FW_out         => FW_WB,
					 
					 v0_in			=> v0_MEM,
					 v0_out			=> v0,
					 
					 JaL_Addr_in	=> JaL_Addr_EX_MEM,
					 JaL_Addr_out	=> JaL_Addr_MEM_WB,
					
					 JaL_in			=> JaL_EX_MEM,
					 JaL_out 		=> JaL_MEM_WB,
					 
					 opcode_in		=> opcode_MEM,
					 opcode_out		=> opcode_WB,
					 
					 funct_in		=> funct_MEM,
					 funct_out		=> funct_WB,
					 
					 memtoReg_in    => memtoReg_MEM,
					 memtoReg_out   => memtoReg_WB);	
					 
		 
  mem_read: muxND
	port map(i_S	=> memtoReg_WB,
	i_X				=> ALU_Result_WB,
	i_Y				=> memData_WB,
	o_Z				=> regularRegWrite_DATA);
	
	
		

  

end structure;
