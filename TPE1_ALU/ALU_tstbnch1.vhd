LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ALU_vhd_tst IS
END ALU_vhd_tst;
ARCHITECTURE ALU_vhd_tst_arch OF ALU_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Ctrl : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL Res : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Zero : STD_LOGIC;

COMPONENT ALU
	port (A : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator A
	      B : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator B
        Ctrl : in std_logic_vector(2 downto 0); -- Mode
        Res: out STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Result
        Zero: out STD_LOGIC                     -- Zero
        );
END COMPONENT;
BEGIN
	i1 : ALU
	PORT MAP (
-- list connections between master ports and signals
	A => A,
    B => B,
    Ctrl => Ctrl,
    Res=> Res,
    Zero=>Zero
    );

always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  

-- Prueba con datos
A <= "10100000";
B <= "01000001";

Ctrl <= "000";
wait for 10 ns;

Ctrl <= "001";
wait for 10 ns;

Ctrl <= "010";
wait for 10 ns;

Ctrl <= "110";
wait for 10 ns;

Ctrl <= "111";
wait for 10 ns;

A <= "00000111";
B <= "00001001";
wait for 10 ns;

Ctrl <= "100";
wait for 10 ns;

WAIT;                                                        
END PROCESS always;                                          
END ALU_vhd_tst_arch;
