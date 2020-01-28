library IEEE;
use IEEE.std_logic_1164.all;

entity Control_ALU is 
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
		 
	end Control_ALU;	 	 


architecture dataflow of Control_ALU is

begin

Choice: process(opcode, funct)

begin

if(opcode = "000000") then
	--This is R format
		case funct is
			when"100000" => ALUSrc <= '0'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0';  --add
			when"100001" => ALUSrc <= '0'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --addu
			when"100100" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --and
			when"100111" => ALUSrc <= '0'; ALUControl <= "11000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --nor
			when"100110" => ALUSrc <= '0'; ALUControl <= "00100"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --xor
			when"100101" => ALUSrc <= '0'; ALUControl <= "00001"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --or
			when"101010" => ALUSrc <= '0'; ALUControl <= "01011"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --slt
			when"101011" => ALUSrc <= '0'; ALUControl <= "01011"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --sltu
			when"000000" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0110"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --sll
			when"000010" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0100"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --srl
			when"000011" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0101"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --sra
			when"000100" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "1110"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --sllv
			when"000110" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "1100"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --srlv
			when"000111" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "1101"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --srav
			when"100010" => ALUSrc <= '0'; ALUControl <= "01010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --sub
			when"100011" => ALUSrc <= '0'; ALUControl <= "01010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --subu
			when"001000" => ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "01"; arith_bool <= '0'; --jr
			when others => ALUSrc <= '0'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --nothing
	end case;

else
	--We are in immediate format
	
		case opcode is
			when"001000" =>  ALUSrc <= '1'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --addi
			when"001001" =>  ALUSrc <= '1'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --addiu
			when"001100" =>  ALUSrc <= '1'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --andi
			when"001111" =>  ALUSrc <= '1'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "1110"; loadUI <= '1'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --lui
			when"100011" =>  ALUSrc <= '1'; ALUControl <= "00010"; MemtoReg <= '1'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --lw
			when"001110" =>  ALUSrc <= '1'; ALUControl <= "00100"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --xori
			when"001101" =>  ALUSrc <= '1'; ALUControl <= "00001"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --ori
			when"001010" =>  ALUSrc <= '1'; ALUControl <= "01011"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --slti
			when"001011" =>  ALUSrc <= '1'; ALUControl <= "01011"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '1'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '1'; --sltiu
			when"101011" =>  ALUSrc <= '1'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '1'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --sw
			when"000100" =>  ALUSrc <= '0'; ALUControl <= "01010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "01"; jump <= "00"; arith_bool <= '0'; --beq
			when"000101" =>  ALUSrc <= '0'; ALUControl <= "01010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "11"; jump <= "00"; arith_bool <= '0'; --bne
			when"000010" =>  ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "10"; arith_bool <= '0'; --j
			when"000011" =>  ALUSrc <= '0'; ALUControl <= "00000"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '1'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "11"; arith_bool <= '0'; --jal
			when others => ALUSrc <= '0'; ALUControl <= "00010"; MemtoReg <= '0'; s_DMemWr <= '0'; s_RegWr <= '0'; RegDst <= '0'; ALUShift_ctrl  <= "0000"; loadUI <= '0'; branch <= "00"; jump <= "00"; arith_bool <= '0'; --nothing
	end case;

end if;

end process;

end dataflow;
	