-- Quartus Prime VHDL Template
-- sign extender

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sign_ext is
	port(
		sign_ext_c :in std_logic;
		i_Sign	:in std_logic_vector(15 downto 0);
		o_Sign	:out std_logic_vector(31 downto 0));
end sign_ext;

architecture structure of sign_ext is

component muxND is
	generic(N : integer := 32);

	port( i_S	:in std_logic;
	i_X		:in std_logic_vector(N-1 downto 0);
	i_Y		:in std_logic_vector(N-1 downto 0);
	o_Z		:out std_logic_vector(N-1 downto 0));

end component;

	signal sign,unsign :std_logic_vector(31 downto 0);

begin

sign <= std_logic_vector(resize(signed(i_Sign), o_Sign'length));
unsign <= std_logic_vector(resize(unsigned(i_Sign), o_Sign'length));

G0:muxND
	port map(
		i_S => sign_ext_c,
		i_X => sign,
		i_Y => unsign,
		o_Z	=> o_Sign);
		


end structure;
