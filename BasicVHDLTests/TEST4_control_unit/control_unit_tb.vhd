library ieee;
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit_tb is
end control_unit_tb;

architecture control_unit_tb_arq  of control_unit_tb is
	-- Component declaration of the tested unit
	component design --control_unit
    port (  op_code : in STD_LOGIC_VECTOR(5 downto 0);
            control_signals : out STD_LOGIC_VECTOR (9 downto 0));
	end component;

	signal op_code         : STD_LOGIC_VECTOR(5 downto 0);
	signal control_signals       : STD_LOGIC_VECTOR(9 downto 0);
  	  
	constant tper_clk  : time := 50 ns;
	constant tdelay    : time := 120 ns; -- antes 150, sino no enta direccion 0

begin
	  
	-- Unit Under Test port map
	UUT : design --control_unit
    --generic map (
	  -- C_ELF_FILENAME     => "program1",
      --C_MEM_SIZE         => 1024
    --)
	port map (
        op_code             => op_code, --Signal Testbench => Signal Component
        control_signals     => control_signals
	);
	
	process
	begin
    	op_code<="000000";
		wait for 10 ns;
    	op_code<="101011";
		wait for 10 ns;
        op_code<="000100";
		wait for 10 ns;
        op_code<="100011";
		wait for 10 ns;
		op_code<="001111";
		wait for 10 ns;
		op_code<="001000";
		wait for 10 ns;
		op_code<="001100";
		wait for 10 ns;
		op_code<="001101";
		wait for 10 ns;
		wait;
	end process;  	 

end control_unit_tb_arq;

