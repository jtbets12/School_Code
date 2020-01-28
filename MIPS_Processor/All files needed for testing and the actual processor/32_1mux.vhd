-- Jacob Puetz
--N bit register file



library IEEE;
use IEEE.std_logic_1164.all;


entity mux32_1 is
	generic(N : integer := 32);

	port(i_S		:in std_logic_vector(4 downto 0);
		i_Data0		:in std_logic_vector(N-1 downto 0);
		i_Data1		:in std_logic_vector(N-1 downto 0);
		i_Data2		:in std_logic_vector(N-1 downto 0);
		i_Data3		:in std_logic_vector(N-1 downto 0);
		i_Data4		:in std_logic_vector(N-1 downto 0);
		i_Data5		:in std_logic_vector(N-1 downto 0);
		i_Data6		:in std_logic_vector(N-1 downto 0);
		i_Data7		:in std_logic_vector(N-1 downto 0);
		i_Data8		:in std_logic_vector(N-1 downto 0);
		i_Data9		:in std_logic_vector(N-1 downto 0);
		i_Data10		:in std_logic_vector(N-1 downto 0);
		i_Data11		:in std_logic_vector(N-1 downto 0);
		i_Data12		:in std_logic_vector(N-1 downto 0);
		i_Data13		:in std_logic_vector(N-1 downto 0);
		i_Data14		:in std_logic_vector(N-1 downto 0);
		i_Data15		:in std_logic_vector(N-1 downto 0);
		i_Data16		:in std_logic_vector(N-1 downto 0);		i_Data17		:in std_logic_vector(N-1 downto 0);
		i_Data18		:in std_logic_vector(N-1 downto 0);
		i_Data19		:in std_logic_vector(N-1 downto 0);
		i_Data20		:in std_logic_vector(N-1 downto 0);
		i_Data21		:in std_logic_vector(N-1 downto 0);
		i_Data22		:in std_logic_vector(N-1 downto 0);
		i_Data23		:in std_logic_vector(N-1 downto 0);
		i_Data24		:in std_logic_vector(N-1 downto 0);
		i_Data25		:in std_logic_vector(N-1 downto 0);
		i_Data26		:in std_logic_vector(N-1 downto 0);
		i_Data27		:in std_logic_vector(N-1 downto 0);
		i_Data28		:in std_logic_vector(N-1 downto 0);
		i_Data29		:in std_logic_vector(N-1 downto 0);
		i_Data30		:in std_logic_vector(N-1 downto 0);
		i_Data31		:in std_logic_vector(N-1 downto 0);


		o_Data		: out std_logic_vector(N-1 downto 0));


end mux32_1;


architecture mixed of mux32_1 is


begin 

with i_S select

	o_Data <= i_Data0 when "00000",
			i_Data1 when "00001",
			i_Data2 when "00010",
			i_Data3 when "00011",
			i_Data4 when "00100",
			i_Data5 when "00101",
			i_Data6 when "00110",
			i_Data7 when "00111",
			i_Data8 when "01000",
			i_Data9 when "01001",
			i_Data10 when "01010",
			i_Data11 when "01011",
			i_Data12 when "01100",
			i_Data13 when "01101",
			i_Data14 when "01110",
			i_Data15 when "01111",
			i_Data16 when "10000",
			i_Data17 when "10001",
			i_Data18 when "10010",
			i_Data19 when "10011",
			i_Data20 when "10100",
			i_Data21 when "10101",
			i_Data22 when "10110",
			i_Data23 when "10111",
			i_Data24 when "11000",
			i_Data25 when "11001",
			i_Data26 when "11010",
			i_Data27 when "11011",
			i_Data28 when "11100",
			i_Data29 when "11101",
			i_Data30 when "11110",
			i_Data31 when "11111",
			i_Data0 when others;


end mixed;


