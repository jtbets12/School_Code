library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg is
	  generic(gCLK_HPER   : time := 50 ns);
end tb_reg;


architecture behavioral of tb_reg is

	component regs is 

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

	end component;
	
	signal rt_tb, rs_tb, rd_tb : std_logic_vector(4 downto 0);
	signal we_tb, clk_tb, rst_tb : std_logic;
	signal iD_tb, oD1_tb, oD2_tb, oR2_tb : std_logic_vector(31 downto 0);

begin
	
	tb_reg: regs
		port map(i_WE => we_tb,
				 i_Data => iD_tb,
				 i_CLK => clk_tb,
				 i_RST => rst_tb,
				 rd => rd_tb,
			   	 rs => rs_tb,
				 rt => rt_tb,


				 o_Data1 => oD1_tb,
				 o_Data2 => oD2_tb,
				 o_reg2 => oR2_tb);
				 
  P_CLK: process
  begin
    clk_tb <= '0';
    wait for gCLK_HPER;
    clk_tb <= '1';
    wait for gCLK_HPER;
  end process;			


	 
test: process

	begin
	
		we_tb <= '1';
		iD_tb <= x"0000000A";
		rst_tb <= '1';
		rd_tb <= "00010";
		rs_tb <= "00101";
		rt_tb <= "00111";
		wait for 100 ns;

		we_tb <= '1';
		iD_tb <= x"0000000A";
		rst_tb <= '0';
		rd_tb <= "00010";
		rs_tb <= "00101";
		rt_tb <= "00111";
		wait for 100 ns;

		we_tb <= '1';
		iD_tb <= x"0000000A";
		rst_tb <= '0';
		rd_tb <= "00011";
		rs_tb <= "00011";
		rt_tb <= "00111";
		wait for 100 ns;



	end process;

end behavioral;