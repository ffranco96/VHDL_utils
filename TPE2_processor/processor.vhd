library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
);
end processor;

architecture processor_arq of processor is 

---------------------------------------------------------------------------------------------------------------
-- COMPONENTS DECLARATION --
---------------------------------------------------------------------------------------------------------------

component registers
    port  (clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            wr : in STD_LOGIC;
            reg1_dr : in STD_LOGIC_VECTOR (4 downto 0);
            reg2_dr : in STD_LOGIC_VECTOR (4 downto 0);
            reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
            data_wr : in STD_LOGIC_VECTOR (31 downto 0);
            data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
            data2_rd : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component control_unit 
	port ( op_code : in STD_LOGIC_VECTOR(5 downto 0);
		   control_signals : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component ALU 
	port (A :       IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operator A @todo extenderlos a 32 bits
	      B :       IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operator B
        Control : in std_logic_vector(2 downto 0); -- Control
        Result:   out STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Result
        Zero:     out STD_LOGIC                     -- Zero
        );
end component;
---------------------------------------------------------------------------------------------------------------
--SIGNALS DECLARATION--
---------------------------------------------------------------------------------------------------------------
signal sI_Addr: std_logic_vector(31 downto 0);

--IF STAGE--

--if_pc (notas cris)

--IF/ID SEGMENTATION REG--
signal IF_ID_instr : std_logic_vector(31 downto 0);
signal IF_ID_pc4 : std_logic_vector(31 downto 0);

--ID STAGE--

--ID/EX SEGMENTATION REG--
signal ID_EX_control_signals: std_logic_vector (9 downto 0);
signal ID_EX_instr : std_logic_vector(31 downto 0);
signal ID_EX_extended_imm : std_logic_vector(31 downto 0); -- immediate 16 bytes of I-type instructions
signal ID_EX_read_data_1 : std_logic_vector(31 downto 0); -- @todo assign here Read data 1 from registers bank, and assign to input A of ALU
signal ID_EX_read_data_2 : std_logic_vector(31 downto 0);
signal ID_EX_pc4 : std_logic_vector(31 downto 0); -- PC + 4 

--EX STAGE--
signal EX_Mux_input_B_ALU : std_logic_vector(31 downto 0);
signal ALU_Control_Res: std_logic_vector(2 downto 0);
signal Alu_TYPE_R: std_logic_vector(2 downto 0);

--EX/MEM SEGMENTATION REG--
signal EX_MEM_control_signals: std_logic_vector (9 downto 0);
signal EX_MEM_instr : std_logic_vector(31 downto 0);
signal EX_MEM_ALU_Res : std_logic_vector(31 downto 0); --@todo assign alu res here 
signal EX_MEM_ALU_Zero : std_Logic;
signal EX_MEM_pc4_extend : std_logic_vector(31 downto 0); --PC + 4 + (extend shift left 2)

--MEM STAGE--

--MEM/WB SEGMENTATION REG--
signal MEM_WB_control_signals: std_logic_vector (9 downto 0);
signal MEM_WB_instr : std_logic_vector(31 downto 0);
--WB STAGE--    

begin 	
---------------------------------------------------------------------------------------------------------------
--BODY--
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- ETAPA IF
---------------------------------------------------------------------------------------------------------------
moveThroughInstMemory: -- @todo can be done as a flip flop
	process(Clk)
	begin
	if reset = '1' then
    	sI_Addr <= x"00000000";
    elsif sI_Addr = x"00000400" then 
		sI_Addr <= x"00000000";
	elsif rising_edge(Clk) then
		sI_Addr <= std_logic_vector(unsigned(sI_Addr) + 4);
	end if;
end process moveThroughInstMemory; 

I_Addr <= sI_Addr;
I_RdStb <= '1';
I_WrStb <= '0';

D_Addr <= EX_MEM_ALU_Res - 1; -- @todo resolver. ASi anda, pero ese menos esta mal.
D_RdStb <= EX_MEM_control_signals(5);-- MemRead
D_WrStb <= EX_MEM_control_signals(4); -- MemWrite
---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION IF/ID
--------------------------------------------------------------------------------------------------------------- 
IF_ID_instr <= I_DataIn;
---------------------------------------------------------------------------------------------------------------
-- ETAPA ID
---------------------------------------------------------------------------------------------------------------
-- Registers bank instantiation
Registers_bank : registers
	Port map (
			clk => Clk, 
			reset => Reset, 
			wr => ID_EX_control_signals(6), 
			reg1_dr => IF_ID_instr(25 downto 21), -- Reg 1 to read
			reg2_dr => IF_ID_instr( 20 downto 16), -- Reg 2 to read
			reg_wr => "00000", -- @todo				-- ??
			data_wr => x"00000000" , -- @todo		-- Data write
			data1_rd => open ,	--@todo			-- Read data 1
			data2_rd => open ); --@todo 			-- Read data 2

 -- Control unit instantiaton
 Cont_unit_inst: control_unit	
 	port map ( 	op_code => IF_ID_instr(31 downto 26),
	 			control_signals => ID_EX_control_signals );  

-- Sign extension
ID_EX_extended_imm <= x"0000" & ID_EX_instr(15 downto 0);
---------------------------------------------------------------------------------------------------------------
-- ID/EX SEGMENTATION REG
---------------------------------------------------------------------------------------------------------------
-- proceso sensible al clock que tenga "todos los registros de segmentacion", en realidad los regs que correspnodan a id/ex (es uno solo creo)
 
---------------------------------------------------------------------------------------------------------------
-- EX STAGE
---------------------------------------------------------------------------------------------------------------
ID_EX_read_data_1 <= x"00000001";--@todo temporary just for test



-- @todo: instanciar ALU sumador,--@todo temporary just for test
EX_MEM_pc4_extend <= ID_EX_extended_imm sll 2 + ID_EX_pc4;

EX_Mux_input_B_ALU <= ID_EX_extended_imm when ID_EX_control_signals(8)='1' else
 		               ID_EX_read_data_2 when ID_EX_control_signals(8) = '0' else  --@todo Assign read data 2 from registers here :
					   x"00000000";

-- Señal que recibe Instrucciones (5 down to 0) para Alu_control  
Alu_TYPE_R <= "010" when ID_EX_instr(5 downto 0) = "100000" else                    -- Type_R func add
                "110" when ID_EX_instr(5 downto 0) = "100010" else                  -- Type_R func substraction
                "000" when ID_EX_instr(5 downto 0) = "100100" else                  -- Type_R func and
                "111" when ID_EX_instr(5 downto 0) = "101010" else                  -- Type_R func slt
                "001" when ID_EX_instr(5 downto 0) = "100101";                      -- Type_R func or

-- Alu control, recibe de Control_unit :control_signals					   
ALU_Control_Res <= "010" when ID_EX_control_signals(2 downto 0) = "000" else                    -- lw, sw : op alu add
					Alu_TYPE_R	when ID_EX_control_signals(2 downto 0) = "010" else             -- R-type
                    "110" when ID_EX_control_signals(2 downto 0) = "001" else                   -- Beq :    op alu substraction
					"000" when ID_EX_control_signals(2 downto 0) = "100" else                   -- Andi :   op alu and
					"100" when ID_EX_control_signals(2 downto 0) = "101" else                   -- LUI :    op alu shift left
					"001" when ID_EX_control_signals(2 downto 0) = "110";                       -- Ori :    op alu or

--ALU instantiation
Alu_inst: ALU	
    port map (A <= ID_EX_read_data_1(31 downto 0),          -- Operator A 
	                B <= EX_Mux_input_B_ALU(31 DOWNTO 0),   -- Operator B
                    Control <= ALU_Control_Res(2 downto 0), -- Control
                    Result => EX_MEM_ALU_Res(31 downto 0),  -- Result
                    Zero=> EX_MEM_ALU_Zero );                -- Zero

--------------------------------------------------------------------------------------------------------------
-- EX/MEM SEGMENTATION REG
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- MEM STAGE
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- MEM/WB SEGMENTATION REG
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- WB STAGE
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Segmentation Regs / Pipeline : data will be spread through this regs following Clk signal
---------------------------------------------------------------------------------------------------------------
moveControlSignalsThroughStages: 
	process(Clk)
	begin
		if falling_edge(Clk) then
			-- Spread signlas from control unit of segmentation registers
			EX_MEM_control_signals <= ID_EX_control_signals;

			MEM_WB_control_signals <= EX_MEM_control_signals;
			-- Spread signals of instructions

			ID_EX_instr <= IF_ID_instr;

			EX_MEM_instr <= ID_EX_instr;

			MEM_WB_instr <= EX_MEM_instr;
			
			-- ETAPA EX:
			-- @todo: instanciar ALU sumador, para direccion de branch, sumador para branch
			EX_MEM_ALU_Res <= ID_EX_read_data_1 + EX_Mux_input_B_ALU  ;
			

		end if;

end process moveControlSignalsThroughStages; 

end processor_arq;