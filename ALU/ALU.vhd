library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port (A : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator A
	      B : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator B
        M : in std_logic_vector(2 downto 0); -- Mode
        Res: out STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Result
        GrEqLr: out STD_LOGIC_VECTOR(2 DOWNTO 0)  -- Comparation
        );
end ALU;

architecture behavioural of ALU is

signal sSubs, sAdd, sAdd4: unsigned(7 downto 0);
constant uFour : unsigned(7 downto 0) := "00000100";

begin
sAdd <= unsigned(A) + unsigned(B);
sSubs <= unsigned(A) - unsigned(B);
sAdd4 <= unsigned(A) + uFour;
with M select
  Res <= A and B when "000",                -- And
       A or B when "001",                   -- Or
       A xor B when "010",                  -- Xor
       std_logic_vector(sAdd) when "011",   -- Addition
       std_logic_vector(sSubs) when "100",  -- Substraction
       std_logic_vector(sAdd4) when "101",  -- Addition of 4
       A sll 2 when "110",                  -- Shift left of 2 bits on A
       (others => '0') when others;

GrEqLr <= (others => '0') when M /= "111" else
  "100" when unsigned(A) > unsigned(B) else
  "010" when unsigned(A) = unsigned(B) else
  "001"; -- A lower than B
end behavioural;