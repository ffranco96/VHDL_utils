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

--DECLARACION DE COMPONENTES--

-- component registers --@todo uncomment
--     port  (clk : in STD_LOGIC;
--            reset : in STD_LOGIC;
--            wr : in STD_LOGIC;
--            reg1_dr : in STD_LOGIC_VECTOR (4 downto 0);
--            reg2_dr : in STD_LOGIC_VECTOR (4 downto 0);
--            reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
--            data_wr : in STD_LOGIC_VECTOR (31 downto 0);
--            data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
--            data2_rd : out STD_LOGIC_VECTOR (31 downto 0));
           
-- end component;

component control_unit 
	port ( op_code : in STD_LOGIC_VECTOR(5 downto 0);
		   control_signals : out STD_LOGIC_VECTOR (9 downto 0));
end component;
---------------------------------------------------------------------------------------------------------------
--SIGNALS DECLARATION--
---------------------------------------------------------------------------------------------------------------
signal sI_Addr: std_logic_vector(31 downto 0);
--signal ID_Instruction: std_logic_vector(25 downto 0);

    --ETAPA IF--
	--if_pc (notas franco)

--IF STAGE--

--if_pc (notas franco)

--IF/ID SEGMENTATION REG--
signal IF_ID_inst_op_code: std_logic_vector(5 downto 0);

--ID STAGE--

--ID/EX SEGMENTATION REG--
signal ID_EX_control_signals: std_logic_vector (9 downto 0);

--EX STAGE--

--MEM STAGE--
	
--WB STAGE--    
        
begin 	
---------------------------------------------------------------------------------------------------------------
-- ETAPA IF
---------------------------------------------------------------------------------------------------------------
moveThroughInstMemory: 
	process(clk)
	begin
	if Reset = '1' then
    	sI_Addr <= x"00000000";--@todo fix the problem that reads twice the first space of memory
    elsif sI_Addr = x"00000400" then 
		sI_Addr <= x"00000000";
	elsif falling_edge(clk) then
		sI_Addr <= std_logic_vector(unsigned(sI_Addr) + 4);
	end if;
end process moveThroughInstMemory; 

I_Addr <= sI_Addr;
I_RdStb <= '1'; -- I will always read from this memory. It will never be written.
I_WrStb <= '0';
---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION IF/ID
--------------------------------------------------------------------------------------------------------------- 
IF_ID_inst_op_code <= I_DataIn(31 downto 26); 
---------------------------------------------------------------------------------------------------------------
-- ETAPA ID
---------------------------------------------------------------------------------------------------------------
-- Records bank instantiation @todo uncomment
-- 	Port map (
-- 			clk => clk, 
-- 			reset => reset, 
-- 			wr => RegWrite, 
-- 			reg1_dr => ID_Instruction(25 downto 21), 
-- 			reg2_dr => ID_Instruction( 20 downto 16), 
-- 			reg_wr => WB_reg_wr, 
-- 			data_wr => WB_data_wr , 
-- 			data1_rd => ID_data1_rd ,
-- 			data2_rd => ID_data2_rd );  

 --notas franco: decodificador
 
 -- Control unit instantiaton
 Cont_unit_inst: control_unit	
 	port map ( 	op_code => IF_ID_inst_op_code, -- @todo later must be modified to a CONT_UNITY_op_code, signal that will be asigned with IF_ID_inst_op_code
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


end processor_arq;