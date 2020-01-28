library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Hazard_Control is
	port(rs_ID : in std_logic_vector(4 downto 0);
		 rt_ID : in std_logic_vector(4 downto 0);
		 rs_EX : in std_logic_vector(4 downto 0);
		 rt_EX : in std_logic_vector(4 downto 0);
		 regWR_ADDR_EX: in std_logic_vector(4 downto 0);
		 regWR_ADDR_MEM: in std_logic_vector(4 downto 0);
		 regWR_ADDR_WB: in std_logic_vector(4 downto 0);
		 regWR_EX : in std_logic;
		 regWR_MEM : in std_logic;
		 regWR_WB : in std_logic;
		 memtoReg_EX : in std_logic;
		 memtoReg_MEM : in std_logic;
		 memtoReg_WB : in std_logic;		 
		 ld_UI_MEM: in std_logic;
		 branch		: in std_logic;
		 branch_ID	: in std_logic;
		 jump       : in std_logic;
		 jump_ID	: in std_logic;
		 iRST		: in std_logic;
		 
		 --Outputs
		 Reg_A_ID_MUX : out std_logic_vector(1 downto 0);
		 Reg_B_ID_MUX : out std_logic_vector(1 downto 0);
		 Reg_A_EX_MUX : out std_logic_vector(1 downto 0);
		 Reg_B_EX_MUX : out std_logic_vector(1 downto 0);
		 FLUSH_IF_ID  : out std_logic;
		 HALT_IF_ID   : out std_logic;
		 FLUSH_ID_EX  : out std_logic;
		 HALT_ID_EX   : out std_logic;		 
		 FLUSH_EX_MEM  : out std_logic;
		 HALT_EX_MEM   : out std_logic;
		 FLUSH_MEM_WB  : out std_logic;
		 HALT_MEM_WB   : out std_logic);
end Hazard_Control;

architecture dataflow of Hazard_Control is		 
	
	
	
begin
	
	
	
	
	--Reg_A_ID_MUX	 
	Reg_A_ID_MUX <= "01" when ((((rs_ID(4) XNOR regWR_ADDR_MEM(4))AND(rs_ID(3) XNOR regWR_ADDR_MEM(3))AND(rs_ID(2) XNOR regWR_ADDR_MEM(2))AND(rs_ID(1) XNOR regWR_ADDR_MEM(1))AND(rs_ID(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND(NOT(ld_UI_MEM))AND(NOT(memtoReg_MEM))))='1') else --ALU_RESULT_MEM
					"10" when ((((rs_ID(4) XNOR regWR_ADDR_MEM(4))AND(rs_ID(3) XNOR regWR_ADDR_MEM(3))AND(rs_ID(2) XNOR regWR_ADDR_MEM(2))AND(rs_ID(1) XNOR regWR_ADDR_MEM(1))AND(rs_ID(0) XNOR regWR_ADDR_MEM(0)))AND(regWR_MEM)AND((ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else	--UP_I_MEM
					"11" when ((((rs_ID(4) XNOR regWR_ADDR_WB(4))AND(rs_ID(3) XNOR regWR_ADDR_WB(3))AND(rs_ID(2) XNOR regWR_ADDR_WB(2))AND(rs_ID(1) XNOR regWR_ADDR_WB(1))AND(rs_ID(0) XNOR regWR_ADDR_WB(0)))AND(regWR_WB))='1') else --RegWR_data
					"00"; --Normal

	--Reg_B_ID_MUX
	Reg_B_ID_MUX <= "01" when(((rt_ID(4)XNOR regWR_ADDR_MEM(4))AND(rt_ID(3) XNOR regWR_ADDR_MEM(3))AND(rt_ID(2) XNOR regWR_ADDR_MEM(2))AND(rt_ID(1) XNOR regWR_ADDR_MEM(1))AND(rt_ID(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND(NOT(ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else --ALU_RESULT_MEM
				 "10" when(((rt_ID(4)XNOR regWR_ADDR_MEM(4))AND(rt_ID(3) XNOR regWR_ADDR_MEM(3))AND(rt_ID(2) XNOR regWR_ADDR_MEM(2))AND(rt_ID(1) XNOR regWR_ADDR_MEM(1))AND(rt_ID(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND((ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else	--UP_I_MEM
				 "11" when((((rt_ID(4)XNOR regWR_ADDR_WB(4))AND(rt_ID(3) XNOR regWR_ADDR_WB(3))AND(rt_ID(2) XNOR regWR_ADDR_WB(2))AND(rt_ID(1) XNOR regWR_ADDR_WB(1))AND(rt_ID(0) XNOR regWR_ADDR_WB(0)))AND(regWR_WB))='1') else --RegWR_data
				 "00"; --Normal

	--Reg_A_EX_MUX
	Reg_A_EX_MUX <= "01" when(((rs_EX(4) XNOR regWR_ADDR_MEM(4))AND(rs_EX(3) XNOR regWR_ADDR_MEM(3))AND(rs_EX(2) XNOR regWR_ADDR_MEM(2))AND(rs_EX(1) XNOR regWR_ADDR_MEM(1))AND(rs_EX(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND(NOT(ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else --ALU_RESULT_MEM
				 "10" when(((rs_EX(4) XNOR regWR_ADDR_MEM(4))AND(rs_EX(3) XNOR regWR_ADDR_MEM(3))AND(rs_EX(2) XNOR regWR_ADDR_MEM(2))AND(rs_EX(1) XNOR regWR_ADDR_MEM(1))AND(rs_EX(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND((ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else	--UP_I_MEM
				 "11" when(((rs_EX(4) XNOR regWR_ADDR_WB(4))AND(rs_EX(3) XNOR regWR_ADDR_WB(3))AND(rs_EX(2) XNOR regWR_ADDR_WB(2))AND(rs_EX(1) XNOR regWR_ADDR_WB(1))AND(rs_EX(0) XNOR regWR_ADDR_WB(0))AND(regWR_WB)AND(memtoReg_WB))='1') else --RegWR_data
				 "00"; --Normal

	--Reg_B_EX_MUX
	Reg_B_EX_MUX <= "01" when(((rt_EX(4) XNOR regWR_ADDR_MEM(4))AND(rt_EX(3) XNOR regWR_ADDR_MEM(3))AND(rt_EX(2) XNOR regWR_ADDR_MEM(2))AND(rt_EX(1) XNOR regWR_ADDR_MEM(1))AND(rt_EX(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND(NOT(ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else --ALU_RESULT_MEM
				 "10" when(((rt_EX(4) XNOR regWR_ADDR_MEM(4))AND(rt_EX(3) XNOR regWR_ADDR_MEM(3))AND(rt_EX(2) XNOR regWR_ADDR_MEM(2))AND(rt_EX(1) XNOR regWR_ADDR_MEM(1))AND(rt_EX(0) XNOR regWR_ADDR_MEM(0))AND(regWR_MEM)AND((ld_UI_MEM))AND(NOT(memtoReg_MEM)))='1') else	--UP_I_MEM
				 "11" when(((rt_EX(4) XNOR regWR_ADDR_WB(4))AND(rt_EX(3) XNOR regWR_ADDR_WB(3))AND(rt_EX(2) XNOR regWR_ADDR_WB(2))AND(rt_EX(1) XNOR regWR_ADDR_WB(1))AND(rt_EX(0) XNOR regWR_ADDR_WB(0))AND(regWR_WB)AND(memtoReg_WB))='1') else --RegWR_data
				 "00"; --Normal
				 		 
	HALT_IF_ID <= '0' when (((branch) AND (NOT branch_ID)) = '1') else
				  '0' when (((jump) AND (NOT jump_ID)) = '1') else
				  '0' when (((rs_ID(4) XNOR regWR_ADDR_EX(4))AND(rs_ID(3) XNOR regWR_ADDR_EX(3))AND(rs_ID(2) XNOR regWR_ADDR_EX(2))AND(rs_ID(1) XNOR regWR_ADDR_EX(1))AND(rs_ID(0) XNOR regWR_ADDR_EX(0))AND(regWR_EX)AND(branch)) = '1') else
				  '0' when (((rt_ID(4) XNOR regWR_ADDR_EX(4))AND(rt_ID(3) XNOR regWR_ADDR_EX(3))AND(rt_ID(2) XNOR regWR_ADDR_EX(2))AND(rt_ID(1) XNOR regWR_ADDR_EX(1))AND(rt_ID(0) XNOR regWR_ADDR_EX(0))AND(regWR_EX)AND(branch)) = '1') else
				  '0' when (((rs_ID(4) XNOR regWR_ADDR_EX(4))AND(rs_ID(3) XNOR regWR_ADDR_EX(3))AND(rs_ID(2) XNOR regWR_ADDR_EX(2))AND(rs_ID(1) XNOR regWR_ADDR_EX(1))AND(rs_ID(0) XNOR regWR_ADDR_EX(0))AND(memtoReg_EX)AND(branch)) = '1') else
				  '0' when (((rt_ID(4) XNOR regWR_ADDR_EX(4))AND(rt_ID(3) XNOR regWR_ADDR_EX(3))AND(rt_ID(2) XNOR regWR_ADDR_EX(2))AND(rt_ID(1) XNOR regWR_ADDR_EX(1))AND(rt_ID(0) XNOR regWR_ADDR_EX(0))AND(memtoReg_EX)AND(branch)) = '1') else
				  '0' when (((memtoReg_MEM) AND(NOT memtoReg_WB)) = '1') else
				  '1';
				  
	FLUSH_IF_ID <= '1' when iRST = '1' else
				   '1' when branch_ID = '1' else
				   '1' when jump_ID = '1' else
				   '0';
				   
	HALT_ID_EX <= '0' when (memtoReg_MEM AND(NOT memtoReg_WB)) = '1' else
				  '1';
				  
	FLUSH_ID_EX <= '1' when iRST = '1' else
				   '0';
				   
	HALT_EX_MEM <= '0' when (memtoReg_MEM AND(NOT memtoReg_WB)) = '1' else
				   '1';

	FLUSH_EX_MEM <= '1' when iRST = '1' else
					'1' when (memtoReg_MEM AND memtoReg_WB) = '1' else
					'0';
					
	HALT_MEM_WB <= '1';

	FLUSH_MEM_WB <= '1' when iRST = '1' else
					'0';

	
end dataflow;	