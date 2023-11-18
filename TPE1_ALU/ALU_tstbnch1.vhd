LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ALU_vhd_tst IS
END ALU_vhd_tst;
ARCHITECTURE behavioural OF ALU_vhd_tst IS
-- constants                                                 
-- signals                                                   
        SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL B : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Control : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Zero : STD_LOGIC;

        COMPONENT ALU
	port (A : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator A
	B : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator B
        Control : in std_logic_vector(2 downto 0); -- Mode
        Result: out STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Result
        Zero: out STD_LOGIC                     -- Zero
        );
        END COMPONENT;
BEGIN
        i1 : ALU
	PORT MAP (
-- list connections between master ports and signals
	A => A,
        B => B,
        Control => Control,
        Result=> Result,
        Zero=>Zero
        );

        always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
        BEGIN                                                         
        -- code executes for every event on sensitivity list  

        -- Prueba con datos
        A <= x"10100000";
        B <= x"01000001";

        Control <= "000";
        wait for 10 ns;

        Control <= "001";
        wait for 10 ns;

        Control <= "010";
        wait for 10 ns;

        Control <= "110";
        wait for 10 ns;

        Control <= "111";
        wait for 10 ns;

        A <= x"00000111";
        B <= x"00001001";
        wait for 10 ns;

        Control <= "100";
        wait for 10 ns;

        WAIT;                                                        
        END PROCESS always;                                          
END behavioural;
