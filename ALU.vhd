library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_2in is
	port (ent : in std_logic_vector (1 downto 0);
	      sal : out std_logic;
          A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          M : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          Res : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          Comp : OUT STD_LOGIC_VECTOR(2 downto 0);
          Zero: OUT STD_LOGIC
          );
end and_2in;

architecture comp_and of and_2in is
signal unsA, unsB, suma, resta: unsigned(7 downto 0);
begin
unsA <= unsigned(A);
unsB <= unsigned(B);

sal <= ent(0) and ent(1);
Zero <= '1' when Res = "00000000" else '0';

suma <= unsA + unsB;
resta <= unsA - unsB;
Comp <= "100" when (unsA > unsB) and (M = "100") else "000";
with M select
  Res <= 
  A and B when "000",
  A or B when "001",
  std_logic_vector(suma) when "010",
  std_logic_vector(resta) when "011",
  A sll 4 when "101",
  (others => '0') when others;

end comp_and;
