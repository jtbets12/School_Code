library IEEE;
use IEEE.std_logic_1164.all;

entity shift32 is
	port(n_i : in std_logic_vector(31 downto 0);
	     LorA : in std_logic;
	     s1 : in std_logic;
	     s2 : in std_logic;
             s4 : in std_logic;
	     s8 : in std_logic;
	     s16: in std_logic;
	     LeftorRight : in std_logic;
	     n_o: out std_logic_vector(31 downto 0));
end shift32;

architecture structural of shift32 is


	component MUX_STR is
		port(ia	:in std_logic;
		     ib	:in std_logic;
		     s	:in std_logic;
		     o	:out std_logic);
	end component;

	component nBit_MUX_STR is
	generic(N : integer := 32);
	port(ia	:in std_logic_vector(N-1 downto 0);
	     ib	:in std_logic_vector(N-1 downto 0);
	     s	:in std_logic;
	     o	:out std_logic_vector(N-1 downto 0));

	end component;


signal numLogSteal, numArithSteal,numShiftLeft, SLeft1, SLeft2, SLeft4, SLeft8, SL1, SL2, SL4, SL8, SA1, SA2, SA4, SA8 : std_logic_vector(47 downto 0);
signal n_oL, n_oA, routA, n_oLeft, n_oRight : std_logic_vector(31 downto 0);

begin

FillSteal: for i in 0 to 31 generate

	numLogSteal(i) <= n_i(i);
	numArithSteal(i) <= n_i(i);
	numShiftLeft(i+16) <= n_i(i);

end generate;

FillExtra: for i in 32 to 47 generate

	numLogSteal(i) <= '0';
	numArithSteal(i) <= '1';
	SL1(i) <= '0';
	SL2(i) <= '0';
	SL4(i) <= '0';
	SL8(i) <= '0';
	SA1(i) <= '1';
	SA2(i) <= '1';
	SA4(i) <= '1';
	SA8(i) <= '1';
	numShiftLeft(i-32) <= '0';
	SLeft1(i-32) <= '0';
	SLeft2(i-32) <= '0';
	SLeft4(i-32) <= '0';
	SLeft8(i-32) <= '0';
end generate;

ShiftLog: for i in 0 to 31 generate

	MUX1: MUX_STR
		port map(ia => n_i(i),
			 ib => numLogSteal(i+1),
			 s => s1,
			 o => SL1(i));

	MUX2: MUX_STR
		port map(ia => SL1(i),
			 ib => SL1(i+2),
			 s => s2,
			 o => SL2(i));

	MUX3: MUX_STR
		port map(ia => SL2(i),
			 ib => SL2(i+4),
			 s => s4,
			 o => SL4(i));

	MUX4: MUX_STR
		port map(ia => SL4(i),
			 ib => SL4(i+8),
			 s => s8,
			 o => SL8(i));

	MUX5: MUX_STR
		port map(ia => SL8(i),
			 ib => SL8(i+16),
			 s => s16,
			 o => n_oL(i));

 end generate;


ShiftArith: for i in 0 to 31 generate

	MUX11: MUX_STR
		port map(ia => n_i(i),
			 ib => numArithSteal(i+1),
			 s => s1,
			 o => SA1(i));

	MUX12: MUX_STR
		port map(ia => SA1(i),
			 ib => SA1(i+2),
			 s => s2,
			 o => SA2(i));

	MUX13: MUX_STR
		port map(ia => SA2(i),
			 ib => SA2(i+4),
			 s => s4,
			 o => SA4(i));

	MUX14: MUX_STR
		port map(ia => SA4(i),
			 ib => SA4(i+8),
			 s => s8,
			 o => SA8(i));

	MUX15: MUX_STR
		port map(ia => SA8(i),
			 ib => SA8(i+16),
			 s => s16,
			 o => n_oA(i));


 end generate;

ShiftLeft: for i in 0 to 31 generate

	MUX6: MUX_STR
		port map(ia => n_i(i),
			 ib => numShiftLeft(i+15),
			 s => s1,
			 o => SLeft1(i+16));

	MUX7: MUX_STR
		port map(ia => SLeft1(i+16),
			 ib => SLeft1(i+14),
			 s => s2,
			 o => SLeft2(i+16));

	MUX8: MUX_STR
		port map(ia => SLeft2(i+16),
			 ib => SLeft2(i+12),
			 s => s4,
			 o => SLeft4(i+16));

	MUX9: MUX_STR
		port map(ia => SLeft4(i+16),
			 ib => SLeft4(i+8),
			 s => s8,
			 o => SLeft8(i+16));

	MUX10: MUX_STR
		port map(ia => SLeft8(i+16),
			 ib => SLeft8(i),
			 s => s16,
			 o => n_oLeft(i));


 end generate;

	MUXSign: nBit_MUX_STR
		port map(ia => n_oA,
			 ib => n_oL, 
			 s => n_i(31),
			 o => routA);

	MUXRight: nBit_MUX_STR
		port map(ia => routA,
			 ib => n_oL, 
			 s => LorA,
			 o => n_oRight);

	MUXoutput: nBit_MUX_STR
		port map(ia => n_oLeft,
			 ib => n_oRight, 
			 s => LeftorRight,
			 o => n_o);

end structural;