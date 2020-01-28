library IEEE;
use IEEE.std_logic_1164.all;

entity nBit_MUX_STR is
	generic(N : integer := 32);
  port(ia  : in std_logic_vector(N-1 downto 0);
       ib  : in std_logic_vector(N-1 downto 0);
       s  : in std_logic;
       o  : out std_logic_vector(N-1 downto 0));

end nBit_MUX_STR;

architecture dataflow of nBit_MUX_STR is 

begin
   o <= ia when (s = '1') else
	  ib when (s = '0') else 
	  "00000000000000000000000000000000";
end dataflow;