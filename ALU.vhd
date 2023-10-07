library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port (A : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	      B : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          m : in std_logic_vector(2 downto 0);
          sal: out STD_LOGIC_VECTOR(2 DOWNTO 0)
          );
end ALU;

architecture behavioural of ALU is
begin

with M select
  sal <= 
  A and B when "000",
  A or B when "001",
  A + B when "010",
  A - B when "011",
  (others => '0') when others;

end behavioural;