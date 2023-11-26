library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Program_Counter is
    Port (
        Clk : in  STD_LOGIC;
        Reset : in  STD_LOGIC;
        PC_Out : out STD_LOGIC_VECTOR(31 downto 0);
        PC_Write : in STD_LOGIC;
        PC_In : in STD_LOGIC_VECTOR(31 downto 0)
    );
end Program_Counter;

architecture behavioral of Program_Counter is
    signal PC_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    process(Clk, Reset)
    begin
        if (Reset = '1') then
            PC_reg <= (others => '0');
        elsif rising_edge(Clk) then
            if (PC_Write = '1') then
                PC_reg <= PC_In;
            else
                PC_reg <= PC_reg + 4;  -- Incrementa en 4 para la siguiente instrucción
            end if;
        end if;
    end process;

    PC_Out <= PC_reg;
end behavioral;