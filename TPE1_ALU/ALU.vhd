library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity ALU is
	port (A :       IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operator A @todo extenderlos a 32 bits
	      B :       IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operator B
        Control : in std_logic_vector(2 downto 0); -- Control
        Result:   out STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Result
        Zero:     out STD_LOGIC                     -- Zero
        );
end ALU;

architecture behavioural of ALU is
signal lwrThan:   std_ulogic_vector(31 downto 0);
signal sResult:   std_logic_vector(31 downto 0);
signal sZero:     std_ulogic;
begin

lwrThan <= x"00000001" when A < B else x"00000000";
with Control select
  sResult <= A and B when "000",               -- And
      A or B when "001",                   -- Or
      A + B when "010",                    -- Addition
      A - B when "110",                    -- Substraction
      lwrThan when "111",                  -- Lower than @todo Extenderlo a  8 bits o la cant que sea
      A sll 16 when "100",                 -- Shift left logical of 16 bits
      (others => '0') when others;
  sZero <= '1' when sResult = x"00000000" else '0';
Result <= sResult;
Zero <= sZero;
--Zero <= '1' when sRes = (others => '0') else '0'; @todoFalta ver como comparar qe sean todos cero, se puede sino usar un process aunque es algo largo. Usando un for.
end behavioural;