library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Program_Counter_tb is
end Program_Counter_tb;

architecture behavior of Program_Counter_tb is

    -- Component declaration for the Program_Counter
    COMPONENT Program_Counter
    PORT(
        Clk      : IN  STD_LOGIC;
        Reset    : IN  STD_LOGIC;
        PC_Out   : OUT STD_LOGIC_VECTOR(31 downto 0);
        PC_Write : IN  STD_LOGIC;
        PC_In    : IN  STD_LOGIC_VECTOR(31 downto 0)
    );
    END COMPONENT;

    -- Signals for the test bench
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic := '1'; -- Start with Reset high
    signal PC_Out   : std_logic_vector(31 downto 0);
    signal PC_Write : std_logic;
    signal PC_In    : std_logic_vector(31 downto 0);

BEGIN

    -- Instantiate the Program_Counter
    uut: Program_Counter PORT MAP (
        Clk      => Clk,
        Reset    => Reset,
        PC_Out   => PC_Out,
        PC_Write => PC_Write,
        PC_In    => PC_In
    );

    -- Clock process
    ClkProcess: PROCESS
    BEGIN
        WHILE NOW < 1000 ns LOOP
            Clk <= NOT Clk;
            WAIT FOR 10 ns; -- Adjust the clock period as needed
        END LOOP;
        WAIT;
    END PROCESS ClkProcess;

    -- Stimulus process
    StimulusProcess: PROCESS
    BEGIN
        -- Initialize inputs here if needed

        -- Apply Reset
        Reset <= '1';
        WAIT FOR 10 ns;
        Reset <= '0';
        WAIT FOR 10 ns;
        
         -- Test case 1: Write a value to PC_In
        PC_Write <= '0';
        PC_In <= X"8c0b0008"; -- Example input value
        WAIT FOR 10 ns;
        
        -- Test case 2: Let PC_Write be low, check PC_Reg incrementing by 4
        PC_Write <= '0';
        WAIT FOR 10 ns;

        -- Test case 3: Write a value to PC_In (BEQ)
        PC_Write <= '1';
        PC_In <= X"116dfffc"; -- Example input value
        WAIT FOR 10 ns;

        -- Test case 4: Let PC_Write be low, check PC_Reg incrementing by 4
        PC_Write <= '0';
        WAIT FOR 10 ns;

        -- Add more test cases or stimulus here

        WAIT;
    END PROCESS StimulusProcess;

END;