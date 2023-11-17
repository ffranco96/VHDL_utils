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
---------------------------------------------------------------------------------------------------------------
--SIGNALS DECLARATION--
---------------------------------------------------------------------------------------------------------------
signal sI_Addr: std_logic_vector(31 downto 0);

--IF STAGE--

--if_pc (notas franco)

--IF/ID SEGMENTATION REG--
signal IF_ID_instr : std_logic_vector(31 downto 0);
signal IF_ID_instr_op_code: std_logic_vector(5 downto 0); -- @todo quizas se pueda borrar 

--ID STAGE--

--ID/EX SEGMENTATION REG--
signal ID_EX_control_signals: std_logic_vector (9 downto 0);
signal ID_EX_instr : std_logic_vector(31 downto 0);

--EX STAGE--

--EX/MEM SEGMENTATION REG--
signal EX_MEM_control_signals: std_logic_vector (9 downto 0);
signal EX_MEM_instr : std_logic_vector(31 downto 0);
--MEM STAGE--

--MEM/WB SEGMENTATION REG--
signal MEM_WB_control_signals: std_logic_vector (9 downto 0);
signal MEM_WB_instr : std_logic_vector(31 downto 0);
--WB STAGE--    

begin 	
---------------------------------------------------------------------------------------------------------------
-- ETAPA IF
---------------------------------------------------------------------------------------------------------------
moveThroughInstMemory: 
	process(Clk)
	begin
	if reset = '1' then
    	sI_Addr <= x"00000000";
    elsif sI_Addr = x"00000400" then 
		sI_Addr <= x"00000000";
	elsif rising_edge(Clk) then
		sI_Addr <= std_logic_vector(unsigned(sI_Addr) + 4);-- + 4 quizas??
	end if;
end process moveThroughInstMemory; 

I_Addr <= sI_Addr;
I_RdStb <= '1';
I_WrStb <= '0';
---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION IF/ID
--------------------------------------------------------------------------------------------------------------- 
IF_ID_instr_op_code <= I_DataIn(31 downto 26);
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
 	port map ( 	op_code => IF_ID_instr_op_code,
	 			control_signals => ID_EX_control_signals );  

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION ID/EX
---------------------------------------------------------------------------------------------------------------
-- proceso sensible al clock que tenga "todos los registros de segmentacion", en realidad los regs que correspnodan a id/ex (es uno solo creo)
 
---------------------------------------------------------------------------------------------------------------
-- ETAPA EX
---------------------------------------------------------------------------------------------------------------
  -- notas franco: instanciar ALU sumador, para direccion de branch, sumador para branch

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION EX/MEM
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- ETAPA MEM
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION MEM/WB
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- ETAPA WB
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

		end if;

end process moveControlSignalsThroughStages; 

end processor_arq;