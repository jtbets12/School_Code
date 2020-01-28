-- Jacob Betsworth

library IEEE;
use IEEE.std_logic_1164.all;


entity mux4_1_32 is

	port(i_S		:in std_logic_vector(1 downto 0);
		i_Data0		:in std_logic_vector(31 downto 0);
		i_Data1		:in std_logic_vector(31 downto 0);
		i_Data2		:in std_logic_vector(31 downto 0);
		i_Data3		:in std_logic_vector(31 downto 0);


		o_Data		:out std_logic_vector(31 downto 0));


end mux4_1_32;


architecture mixed of mux4_1_32 is


begin 

with i_S select

	o_Data <= i_Data0 when "00",
			i_Data1 when "01",
			i_Data2 when "10",
			i_Data3 when "11",

			i_Data0 when others;


end mixed;
