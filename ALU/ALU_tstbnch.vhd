LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ALU_vhd_tst IS
END ALU_vhd_tst;
ARCHITECTURE ALU_vhd_tst_arch OF ALU_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL M : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL sal : STD_LOGIC_VECTOR(2 DOWNTO 0);

COMPONENT ALU
	port (A : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	      B : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          m : in std_logic_vector(2 downto 0);
          sal: out STD_LOGIC_VECTOR(2 DOWNTO 0)
          );
END COMPONENT;
BEGIN
	i1 : ALU
	PORT MAP (
-- list connections between master ports and signals
	A => A,
    B => B,
    M => M,
    sal=> sal
    );

always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
A <= "010";
B <= "011";
M <= "001";

wait for 10 ns;

A <= "010";
B <= "011";
wait for 10 ns;

A <= "100";
B <= "001";
wait for 10 ns;

A <= "001";
B <= "001";
wait for 10 ns;

WAIT;                                                        
END PROCESS always;                                          
END ALU_vhd_tst_arch;
