LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY and_2in_vhd_tst IS
END and_2in_vhd_tst;
ARCHITECTURE and_2in_arch OF and_2in_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ent : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL sal : STD_LOGIC;
SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL M : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL Res : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Comp : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL Zero : STD_LOGIC;

COMPONENT and_2in
	port (ent : in std_logic_vector (1 downto 0);
	      sal : out std_logic;
          A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          M : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          Res : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          Comp : OUT STD_LOGIC_VECTOR(2 downto 0);
          Zero: OUT STD_LOGIC
          );
END COMPONENT;
BEGIN
	i1 : and_2in
	PORT MAP (
-- list connections between master ports and signals
	ent => ent,
	sal => sal,
    A => A,
    B => B,
    M => M,
    Res=> Res,
    Comp => Comp,
    Zero => Zero
	);

always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
--ent <= "00";
--wait for 10 ns;

--ent <= "01";
--wait for 10 ns;

--ent <= "10";
--wait for 10 ns;

--ent <= "11";
--wait for 10 ns;
        -- code executes for every event on sensitivity list  
A <= "10000000";
B <= "01000000";
M <= "000";

wait for 10 ns;

M <= "001";
wait for 10 ns;

M <= "010";
wait for 10 ns;

M <= "011";
wait for 10 ns;

M <= "100";
wait for 10 ns;

M <= "101";
wait for 10 ns;

WAIT;                                                        
END PROCESS always;                                          
END and_2in_arch;
