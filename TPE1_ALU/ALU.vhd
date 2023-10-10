library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity ALU is
	port (A : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator A @todo extenderlos a 32 bits
	      B : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operator B
        Ctrl : in std_logic_vector(2 downto 0); -- Control
        Res: out STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Result
        Zero: out STD_LOGIC                     -- Zero
        );
end ALU;

architecture behavioural of ALU is
signal lwrThan: std_logic;
signal sRes: std_logic_vector(7 downto 0);
begin

lwrThan <= '1' when A < B else '0';
with Ctrl select
  sRes <= A and B when "000",               -- And
       A or B when "001",                   -- Or
       A + B when "010",                    -- Addition
       A - B when "110",                    -- Substraction
       --lwrThan when "111",                  -- Lower than @todo Extenderlo a  8 bits o la cant que sea
       A sll 16 when "100",                 -- Shift left logical of 16 bits
       (others => '0') when others;

Res <= sRes;
--Zero <= '1' when sRes = (others => '0') else '0'; @todoFalta ver como comparar qe sean todos cero, se puede sino usar un process aunque es algo largo. Usando un for.
end behavioural;