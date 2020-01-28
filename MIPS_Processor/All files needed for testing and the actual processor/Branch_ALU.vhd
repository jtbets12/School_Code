library IEEE;
use IEEE.std_logic_1164.all;


entity Branch_ALU is
	port(ALU_result : in std_logic_vector(31 downto 0);
		 Branch : in std_logic_vector(1 downto 0);
		 zero : out std_logic);
end entity;

architecture dataflow of Branch_ALU is
		
signal bne, beq : std_logic;

begin
	
	bne <= ALU_result(0);
	
	bneGen: for i in 1 to 31 generate
	bne <= (bne OR ALU_result(i));
	end generate;
	
	beq <= (ALU_result(0) NOR '0');
	
	check: for i in 1 to 31 generate
			beq <= (ALU_result(i) NOR beq);
		end generate;

	Death:process(Branch)
		begin
			if(Branch = "01") then
				zero <= beq;
			elsif(Branch = "11") then
				zero <= bne;
			end if;	
	end process;
	
end dataflow;	