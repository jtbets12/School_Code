library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_32bit is 
   port(A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0); 
	control : in std_logic_vector(4 downto 0);
	zero : out std_logic;
	branchop: in std_logic;
	carryOut : out std_logic;
	overflow : out std_logic;
	o_F : out std_logic_vector(31 downto 0));
end ALU_32bit;

architecture behavorial of ALU_32bit is 

component ALU
   port(A : in std_logic;
	B : in std_logic;
	Ainvert : in std_logic;
	Binvert : in std_logic;
	operation : in std_logic_vector(2 downto 0);
	carry_in : in std_logic;
	less : in std_logic;
	result : out std_logic;
	set : out std_logic;
	carry_out : out std_logic);
end component;

signal Cbit, F : std_logic_vector(31 downto 0);
signal finalMux : std_logic_vector(2 downto 0);
signal less_sig     : std_logic;

begin 

Cbit(0) <= control(3);
finalMux <= control(2 downto 0);

alu2 : ALU 
   port map(A => A(0),
	    B => B(0),
	    Ainvert => control(4), 
	    Binvert => control(3),
	    operation => finalMux,
	    carry_in => Cbit(0),
	    less => less_sig,
	    --set => less_sig(31),
	    carry_out => Cbit(1),
	    result => F(0));

G1 : for i in 1 to 30 generate
   alu1 : ALU
	port map(A => A(i),
		 B => B(i),
		 Ainvert => control(4), 
		 Binvert => control(3),
		 operation => finalMux,
		 carry_in => Cbit(i),
		 less => '0',
		 --set => less_sig(31-i),
		 carry_out => Cbit(i+1),
		 result => F(i));
	    
end generate;

alu3 : ALU
   port map(A => A(31),
    	    B => B(31),
	    Ainvert => control(4), 
	    Binvert => control(3),
	    operation => finalMux,
	    carry_in => Cbit(31),
	    less => '0',
	    set => less_sig,
	    carry_out => carryOut,
	    result => F(31));
		
		
o_F <= F;
overflow <= '0';
zero <= branchop xor (not(F(0) or F(1) or F(2) or F(3) or F(4) or F(5) or F(6) or F(7) or F(8) or F(9) or F(10) or F(11) or F(12) or F(13) or F(14) or F(15) or F(16) or F(17) or F(18) or F(19) or F(20) or F(21) or F(22) or F(23) or F(24) or F(25) or F(26) or F(27) or F(28) or F(29) or F(30) or F(31)));

end behavorial;