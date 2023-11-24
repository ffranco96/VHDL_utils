library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity ALU_Testbench is
end ALU_Testbench;

architecture behavior of ALU_Testbench is

    component ALU
        port (
            A : in std_logic_vector(31 downto 0);
            B : in std_logic_vector(31 downto 0);
            Control : in std_logic_vector(2 downto 0);
            Result : out std_logic_vector(31 downto 0);
            Zero : out std_logic
        );
    end component;

    signal A, B : std_logic_vector(31 downto 0);
    signal Control : std_logic_vector(2 downto 0);
    signal Result : std_logic_vector(31 downto 0);
    signal Zero : std_logic;

begin

    UUT : ALU port map (
        A => A,
        B => B,
        Control => Control,
        Result => Result,
        Zero => Zero
    );

    process
    begin
        -- Test Case 1: AND operation
        A <= x"8c090000";  
        B <= x"8c0a0004";  
        Control <= "000";  -- AND operation
        wait for 10 ns;

        -- Test Case 2: OR operation
        A <= x"8c0b0008";  
        B <= x"8c0c000c";  
        Control <= "001";  -- OR operation
        wait for 10 ns;
        
        -- Test Case 3: add operation
        A <= x"01a98822";  
        B <= x"01ca9022";  
        Control <= "010";  -- add operation
        wait for 10 ns;
        
        -- Test Case 4: sub operation
        A <= x"3c090001";  
        B <= x"216b0002";  
        Control <= "010";  -- sub operation
        wait for 10 ns;
        
        -- Test Case 5: lower than operation
        A <= x"3c090001";  
        B <= x"216b0002";  
        Control <= "111";  -- lower than operation
        wait for 10 ns;
        
        -- Test Case 6: shift left operation
        A <= x"3c090001";  
        B <= x"216b0002";  
        Control <= "100";  -- shift left operation
        wait for 10 ns;
        
        -- Test Case 7: zero 
        A <= x"00000000";  
        B <= x"00000000";  
        Control <= "110";  -- zero
        
        wait for 10 ns;

        

        wait;
    end process;

end behavior;