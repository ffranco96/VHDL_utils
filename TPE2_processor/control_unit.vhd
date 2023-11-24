library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This control unit uses its output signals in the following order:
-- control_signals[9]: RegDst
-- control_signals[8]: ALUSrc
-- control_signals[7]: MemtoReg
-- control_signals[6]: Reg-Write
-- control_signals[5]: Mem-Read
-- control_signals[4]: Mem-Write
-- control_signals[3]: Branch
-- control_signals[2]: ALUOp2
-- control_signals[1]: ALUOp1
-- control_signals[0]: ALUOp0

entity control_unit is 
    port ( op_code : in STD_LOGIC_VECTOR(5 downto 0);
           control_signals : out STD_LOGIC_VECTOR (9 downto 0);
           clk : in std_logic
        );
end control_unit;

architecture control_unit_arq of control_unit is 
        signal s_control_signals : std_logic_vector(9 downto 0);
    begin
    s_control_signals <=  "1001000010" when op_code = "00000000" else -- r type @todo check if for R type will be present this or other 
                        "0100010000" when op_code = x"2b" else -- sw
                        "0000001001" when op_code = x"4" else -- beq
                        "0111100000" when op_code = x"23" else -- lw
                        "0101000110" when op_code = x"F" else -- lui
                        "0101000000" when op_code = x"8" else -- addi
                        "0101000100" when op_code = x"C" else -- andi
                        "0101000101" when op_code = x"D" else  -- ori
                        "0000000000";                         --nop
    control_signals <= s_control_signals when rising_edge(clk) else
                    control_signals;
end control_unit_arq;
