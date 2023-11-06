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

--DECLARACION DE SENIALES--
signal sI_Addr: std_logic_vector(31 downto 0);
    --ETAPA IF--
	--if_pc (notas franco)

    --ETAPA ID--
	--id_pc (notas franco)

    --ETAPA EX--

    --ETAPA MEM--
     
    --ETAPA WB--    
        
begin 	
---------------------------------------------------------------------------------------------------------------
-- ETAPA IF
---------------------------------------------------------------------------------------------------------------
moveThroughInstMemory: 
	process(clk)
	begin
	if Reset = '1' then
    	sI_Addr <= x"00000000";
    elsif sI_Addr = x"00000400" then 
		sI_Addr <= x"00000000";
	elsif falling_edge(clk) then
		sI_Addr <= std_logic_vector(unsigned(sI_Addr) + 4);-- + 4 quizas??
	end if;
end process moveThroughInstMemory; 
 
I_Addr <= sI_Addr;
I_RdStb <= '1';
I_WrStb <= '0';

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION IF/ID
--------------------------------------------------------------------------------------------------------------- 
 
 
 
---------------------------------------------------------------------------------------------------------------
-- ETAPA ID
---------------------------------------------------------------------------------------------------------------
-- Instanciacion del banco de registros
-- Registers_inst:  registers --@todo uncomment
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