library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_SHIFT is
	port(A_in : in std_logic_vector(31 downto 0);
	     B_in : in std_logic_vector(31 downto 0);
	     Ov_Fl : out std_logic;
	     zero : out std_logic;
	     output : out std_logic_vector(31 downto 0);
	     Control : in std_logic_vector(13 downto 0);
	     carry_out : out std_logic;
	     branch : in std_logic_vector(1 downto 0));
end ALU_SHIFT;


architecture structural of ALU_SHIFT is

	component shift32 is
		port(n_i : in std_logic_vector(31 downto 0);
	    	     LorA : in std_logic;
	     	     s1 : in std_logic;
	     	     s2 : in std_logic;
       	             s4 : in std_logic;
		     s8 : in std_logic;
	 	     s16: in std_logic;
	 	     LeftorRight : in std_logic;
	    	     n_o: out std_logic_vector(31 downto 0));
	end component;

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

	component nBit_MUX_STR is
		generic(N : integer := 32);
		port(ia	:in std_logic_vector(N-1 downto 0);
	     	     ib	:in std_logic_vector(N-1 downto 0);
	     	     s	:in std_logic;
	       	     o	:out std_logic_vector(N-1 downto 0));
	end component;

	
	component MUX_STR is
		port(ia	:in std_logic;
		     ib	:in std_logic;
		     s	:in std_logic;
		     o	:out std_logic);
	end component;

signal shift_result, ALU_result, shift_in : std_logic_vector(31 downto 0);
signal stand_in :std_logic;
signal shiftAmount : std_logic_vector(4 downto 0);

-- Control bits 4 to 0 go to the control of the ALU
-- Control bits 5 to 9 go to the shift_select to determine how many bits are being shifted
-- Control bit 10 goes to controlling the Log or Arith where 0 is log and 1 is arith
-- Control bit 11 goes to determining between left and right shift where 0 is a right shift and 1 is a left shift
-- Control bit 12 chooses between shift or ALU results with 0 being the ALU_result and 1 being the shift-result

begin 
	placeHolderName: for i in 0 to 4 generate
	shiftOrShiftVariable: MUX_STR
		port map(ia => Control(i+5),
				 ib => A_in(i),
				 s => Control(13),
				 o => shiftAmount(i));
	end generate;	
	
	Shifting: shift32
		port map(n_i => B_in,
			 LorA => Control(10),
			 s1 => shiftAmount(0),
			 s2 => shiftAmount(1),
			 s4 => shiftAmount(2),
			 s8 => shiftAmount(3),
			 s16 => shiftAmount(4),
			 LeftorRight => Control(11),
		  	 n_o => shift_result);


	ALUing: ALU_32bit
		port map(A => A_in,
			 B => B_in,
		     control => Control(4 downto 0),
			 zero => zero,
			 branchOp => branch(1),
		     carryOut => carry_out,
			 overflow => Ov_Fl,
			 o_F => ALU_result);
				 
	ShiftOrALU: nBit_MUX_STR
		port map(ia => shift_result,
				 ib => ALU_result,
				 s => Control(12),
				 o => output);



end structural;