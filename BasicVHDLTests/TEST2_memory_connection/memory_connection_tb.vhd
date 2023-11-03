library ieee;
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

	-- Add your library and packages declaration here ...

entity memory_connection_tb is
end memory_connection_tb;

architecture memory_connection_tb_arq  of memory_connection_tb is
	-- Component declaration of the tested unit

	component memory
	generic (
	   C_ELF_FILENAME     : string;
      C_MEM_SIZE         : integer
   );
	port (
		Clk                : in std_logic;			 
		Addr               : in std_logic_vector(31 downto 0);
		RdStb              : in std_logic;
		WrStb              : in std_logic;
		DataIn             : in std_logic_vector(31 downto 0);
		DataOut            : out std_logic_vector(31 downto 0)
	);
   end component;

	signal t_Clk         : std_logic;
	-- Memory
	signal t_Addr      : std_logic_vector(31 downto 0);
	signal t_RdStb     : std_logic;
	signal t_WrStb     : std_logic;
	signal t_DataOut   : std_logic_vector(31 downto 0);
	signal t_DataIn    : std_logic_vector(31 downto 0);
	
	constant tper_clk  : time := 50 ns;
	constant tdelay    : time := 120 ns; -- antes 150, sino no enta direccion 0

begin

	Instruction_Mem_inst : memory
	generic map (
	   C_ELF_FILENAME     => "program1",
      C_MEM_SIZE         => 1024
   	)
	port map (
		Clk                => t_Clk,			 
		Addr               => t_Addr,
		RdStb              => t_RdStb,
		WrStb              => t_WrStb,
		DataIn             => t_DataOut,
		DataOut            => t_DataIn
	);
	
	process	
	begin		
	    t_Clk <= '0';
		wait for tper_clk/2;
		t_Clk <= '1';
		wait for tper_clk/2; 		
	end process;
	
	process
	begin
		wait for tper_clk/2;
		t_RdStb <= '1';
		t_WrStb <= '0';
		
        wait for 10 ns;
		t_Addr <= x"00000004";
        wait for 10 ns;
		t_Addr <= x"00000008";
        wait;
	end process;  	

end memory_connection_tb_arq;
