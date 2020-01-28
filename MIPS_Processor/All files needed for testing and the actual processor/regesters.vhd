-- Jacob Puetz
--registers 32 file



library IEEE;
use IEEE.std_logic_1164.all;

entity regs is 

	generic(N : integer := 32);

	port (
	i_WE 		:in std_logic;
	i_Data		:in std_logic_vector(N-1 downto 0);
	i_CLK		:in std_logic;
	i_RST		:in std_logic;
	rd		:in std_logic_vector(4 downto 0);
	rs		:in std_logic_vector(4 downto 0);
	rt		:in std_logic_vector(4 downto 0);

	o_Data1		:out std_logic_vector(N-1 downto 0);
	o_Data2		:out std_logic_vector(n-1 downto 0);
	o_reg2      : out std_logic_vector(n-1 downto 0)
);

end regs;

architecture structure of regs is

   component  N_reg 

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_Data       : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Data          : out std_logic_vector(N-1 downto 0));   -- Data value output

 end component;


	component Decoder

	port(i_Data		:in std_logic_vector(4 downto 0);
		o_Data		: out std_logic_vector(N-1 downto 0));

end component;


	component mux32_1

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
		i_Data9			:in std_logic_vector(N-1 downto 0);
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


end component;


	component andg2 

  	port(i_A          : in std_logic;
      	 i_B          : in std_logic;
      	 o_F          : out std_logic);

end component;

	component muxND is
		generic(N : integer := 32);

	port( i_S	:in std_logic;
	i_X		:in std_logic_vector(N-1 downto 0);
	i_Y		:in std_logic_vector(N-1 downto 0);
	o_Z		:out std_logic_vector(N-1 downto 0));

end component;

	signal dec_out		:std_logic_vector(N-1 downto 0);
	signal Reg31_data   :std_logic_vector(N-1 downto 0);
	--creating a 32 sized array of std_logic_vector of N bits

	type A2D is array (31 downto 0) of std_logic_vector(N-1 downto 0);
	signal reg_out : A2D;


	signal WEcombo		:std_logic_vector(N-1 downto 0);

begin
	
	GDec: decoder
		port map (
			i_Data	=>	rd,
			o_Data	=>	dec_out);

	
	reg0: n_reg
		port map(i_CLK => i_CLK,
		i_Data 	=>	i_Data,
		i_WE	=>	'1',
		i_RST	=>	'1',
		o_Data	=>	reg_out(0));



	G0: for i in 1 to N-1 generate

		mixsig_i: andg2
			port map (
			i_A	=>	i_WE,
			i_B	=>	dec_out(i),
			o_F	=>	WEcombo(i));
	

		G1_i: n_reg
			port map(i_CLK => i_CLK,
			i_Data 	=>	i_Data,
			i_WE	=>	WEcombo(i),
			i_RST	=>	i_RST,
			o_Data	=>	reg_out(i));
			

	end generate;
	
	-- reg31Input: muxND
			-- port map(i_S	=> jalControl,
					 -- i_X	=> i_Data,
					 -- i_Y	=> jal_data,
					 -- o_Z	=> Reg31_data);
	
	-- reg31: n_reg
			-- port map(i_CLK => i_CLK,
			-- i_Data 	=>	Reg31_data,
			-- i_WE	=>	jalControl,
			-- i_RST	=>	i_RST,
			-- o_Data	=>	reg_out(31));
	
	

	Gout_1:mux32_1
		port map(i_S	=> rs,
		i_Data0		=> reg_out(0),
		i_Data1		=> reg_out(1),
		i_Data2		=> reg_out(2),
		i_Data3		=> reg_out(3),
		i_Data4		=> reg_out(4),
		i_Data5		=> reg_out(5),
		i_Data6		=> reg_out(6),
		i_Data7		=> reg_out(7),
		i_Data8		=> reg_out(8),
		i_Data9		=> reg_out(9),
		i_Data10	=> reg_out(10),
		i_Data11	=> reg_out(11),
		i_Data12	=> reg_out(12),
		i_Data13	=> reg_out(13),
		i_Data14	=> reg_out(14),
		i_Data15	=> reg_out(15),
		i_Data16	=> reg_out(16),		i_Data17	=> reg_out(17),
		i_Data18	=> reg_out(18),
		i_Data19	=> reg_out(19),
		i_Data20	=> reg_out(20),
		i_Data21	=> reg_out(21),
		i_Data22	=> reg_out(22),
		i_Data23	=> reg_out(23),
		i_Data24	=> reg_out(24),
		i_Data25	=> reg_out(25),
		i_Data26	=> reg_out(26),
		i_Data27	=> reg_out(27),
		i_Data28	=> reg_out(28),
		i_Data29	=> reg_out(29),
		i_Data30	=> reg_out(30),
		i_Data31	=> reg_out(31),


		o_Data	=> o_Data1);

	Gout_2:mux32_1
		port map(i_S	=> rt,
		i_Data0		=> reg_out(0),
		i_Data1		=> reg_out(1),
		i_Data2		=> reg_out(2),
		i_Data3		=> reg_out(3),
		i_Data4		=> reg_out(4),
		i_Data5		=> reg_out(5),
		i_Data6		=> reg_out(6),
		i_Data7		=> reg_out(7),
		i_Data8		=> reg_out(8),
		i_Data9		=> reg_out(9),
		i_Data10	=> reg_out(10),
		i_Data11	=> reg_out(11),
		i_Data12	=> reg_out(12),
		i_Data13	=> reg_out(13),
		i_Data14	=> reg_out(14),
		i_Data15	=> reg_out(15),
		i_Data16	=> reg_out(16),		i_Data17	=> reg_out(17),
		i_Data18	=> reg_out(18),
		i_Data19	=> reg_out(19),
		i_Data20	=> reg_out(20),
		i_Data21	=> reg_out(21),
		i_Data22	=> reg_out(22),
		i_Data23	=> reg_out(23),
		i_Data24	=> reg_out(24),
		i_Data25	=> reg_out(25),
		i_Data26	=> reg_out(26),
		i_Data27	=> reg_out(27),
		i_Data28	=> reg_out(28),
		i_Data29	=> reg_out(29),
		i_Data30	=> reg_out(30),
		i_Data31	=> reg_out(31),


		o_Data	=> o_Data2);
		
		o_reg2 <= reg_out(2);

end structure;
