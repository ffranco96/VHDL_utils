LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ALU_vhd_tst IS
END ALU_vhd_tst;
ARCHITECTURE ALU_vhd_tst_arch OF ALU_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL M : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL Res : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL GrEqLr : STD_LOGIC_VECTOR(2 DOWNTO 0);

COMPONENT ALU
	port (A : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator A
	      B : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator B
        M : in std_logic_vector(2 downto 0); -- Mode
        Res: out STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Result
        GrEqLr: out STD_LOGIC_VECTOR(2 DOWNTO 0)  -- Comparation
        );
END COMPONENT;
BEGIN
	i1 : ALU
	PORT MAP (
-- list connections between master ports and signals
	A => A,
    B => B,
    M => M,
    Res=> Res,
    GrEqLr => GrEqLr
    );

always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  

-- Prueba con datos 1
A <= "10100000";
B <= "01000000";

M <= "111";
wait for 10 ns;

-- Prueba con datos 2

A <= "00001010";
B <= "00100011";
wait for 10 ns;

-- Prueba con datos 3
A <= "00001010";
B <= "00001010";
wait for 10 ns;

M <= "101";
wait for 10 ns;

WAIT;                                                        
END PROCESS always;                                          
END ALU_vhd_tst_arch;
