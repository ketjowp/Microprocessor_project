-- Wojciech Porêbiñski
-- Mikroprocesor - zestawienie komponentów
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Microprocessor is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  RX: in STD_LOGIC;
			  TX: out STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Microprocessor;

architecture Micro_arch of Microprocessor is

component ALU is
    Port ( data1 : in  STD_LOGIC_VECTOR (7 downto 0);
           data2 : in  STD_LOGIC_VECTOR (7 downto 0);
           arit_instruction : in  STD_LOGIC_VECTOR (3 downto 0);
			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  activate :in STD_LOGIC;
           result : out  STD_LOGIC_VECTOR (7 downto 0);
			  ready : out std_logic);
end component ALU;

component data_reg is
    Port ( RAM_datain : in STD_LOGIC_VECTOR (7 downto 0);
           RAM_addr_1 : in STD_LOGIC_VECTOR (4 downto 0);
			  RAM_addr_2 : in STD_LOGIC_VECTOR (4 downto 0);
           RAM_w_en : in  STD_LOGIC;
           RAM_dataout_1 : out  STD_LOGIC_VECTOR (7 downto 0);
			  RAM_dataout_2 : out  STD_LOGIC_VECTOR (7 downto 0);
           RAM_clk : in  STD_LOGIC;
			  reset: in STD_LOGIC);
end component data_reg;

component instr_reg is
    Port ( ROM_addr : in  STD_LOGIC_VECTOR (6 downto 0);
           new_instruction : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in std_logic);
end component instr_reg;

component decoder is
    Port ( full_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
				done: in std_logic;
           addr_reg_1 : out  STD_LOGIC_VECTOR (4 downto 0);
           addr_reg_2 : out  STD_LOGIC_VECTOR (4 downto 0);
           short_instruction : out  STD_LOGIC_VECTOR (3 downto 0);
			  activ_ALU : out std_logic;
			  jump: out std_logic_vector(6 downto 0);
			  activ_jump: out std_logic;
			  control: out std_logic;
			  w_en: out std_logic;
			  trans_en: out std_logic;
			  stack_jump: out std_logic;
			  clk : in STD_LOGIC;
			  reset: in std_logic);
end component decoder;

component multiplekser is
	Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
           control : in  STD_LOGIC;
           multi_out : out  STD_LOGIC_VECTOR (7 downto 0));
end component multiplekser;

component Counter is
    Port ( clk : in  STD_LOGIC;
				reset: in std_logic;
           jump : in  STD_LOGIC_VECTOR (6 downto 0);
			  stack_out: in STD_LOGIC_VECTOR(6 downto 0);
			  activate_jump: in STD_LOGIC;
			  stack_jump: in std_logic;
			  ready_jump : out std_logic;
           instruction_no : out  STD_LOGIC_VECTOR (6 downto 0):="0000000");
end component Counter;


component or_gate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
			  c : in STD_LOGIC;
           d : out  STD_LOGIC);
end component or_gate;

component and_gate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : out  STD_LOGIC);
end component and_gate;



component FIFO is
	Generic (
		constant DATA_WIDTH  : positive := 8;
		constant FIFO_DEPTH	: positive := 256
	);
	Port ( 
		clk		: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		WriteEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		ReadEn	: in  STD_LOGIC);
end component FIFO;

component FIFO_new is
  generic (
    DATA_WIDTH : positive := 8;
    FIFO_DEPTH : positive := 32
    );
  port (
    reset : in std_logic;
    clk      : in std_logic;
    WriteEn   : in  std_logic;
    DataIn : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    ReadEn   : in  std_logic;
    DataOut : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component FIFO_new;

component UART_new is

port (
	data_in: in std_logic_vector(7 downto 0); -- wejscie danych do peryferium z procesora
	r_irq :out std_logic; -- odebrany bajt
	t_irq :out std_logic;	-- wys³any bajt
	clk :in std_logic;
	reset :in std_logic;
	TX : out std_logic;
	RX : in std_logic
);

end component UART_new;

component stack is
    Port ( addr_in : in  STD_LOGIC_VECTOR (6 downto 0);
				active_stack: in std_logic;
           addr_out : out  STD_LOGIC_VECTOR (6 downto 0);
			  clk: in std_logic;
			  reset: in std_logic);
end component stack;
	
	
signal result : std_logic_vector(7 downto 0);
signal data_1 : std_logic_vector(7 downto 0);
signal data_2 : std_logic_vector(7 downto 0);
signal RAM_datain : std_logic_vector(7 downto 0);
signal ALU_instruction : std_logic_vector(3 downto 0);
signal instruction : std_logic_vector(15 downto 0);
signal instr_addr_1 : std_logic_vector(4 downto 0);
signal instr_addr_2 : std_logic_vector(4 downto 0);
signal ALU_done : std_logic;
signal jump_done : std_logic;
signal done : std_logic;
signal activ : std_logic;
signal activ_jump : std_logic;
signal select_instruction : std_logic_vector(6 downto 0);
signal jump : std_logic_vector(6 downto 0);
signal UART_tosend : std_logic_vector(7 downto 0);
signal t_done : std_logic;
signal control : std_logic;
signal w_en : std_logic;
signal dec_trans_en : std_logic;
signal trans_en : std_logic;
signal active_stack : std_logic; --stos
signal stack_out : std_logic_vector(6 downto 0); -- stos



begin

--problemem jest fakt, ¿e przy transmisji przez UART aku zaraz wystawia now¹ wartoœæ i jest ona wysy³ana.
--jest to z³e, ale bez tej wysy³ki mo¿e nie byæ inicjalizacji - trzeba to rozwi¹zaæ
--mo¿liwe - t_irq trwa ca³y czas w stanie t_wait

ALU_comp : ALU port map(data1=>data_1,data2=>data_2, arit_instruction=>ALU_instruction, clk=>clk, reset=>reset, result=>result, ready=>ALU_done, activate=> activ);
Decoder_comp : decoder port map(full_instruction => instruction, addr_reg_1=>instr_addr_1, addr_reg_2=>instr_addr_2, short_instruction=>ALU_instruction, clk=>clk, reset=>reset, activ_ALU=> activ, jump=>jump, activ_jump=>activ_jump, done=>done,control=>control, w_en=>w_en, trans_en=>dec_trans_en, stack_jump=>active_stack); --stos
Data : data_reg port map(RAM_datain=>RAM_datain, RAM_addr_1=>instr_addr_1, RAM_addr_2=>instr_addr_2, RAM_w_en=>done, RAM_dataout_1=>data_1, RAM_dataout_2=>data_2, ram_clk=>clk,reset=>reset);
Instruction_Set : instr_reg port map(new_instruction=>instruction,ROM_addr=>select_instruction, clk=>clk);
Multi1 : multiplekser port map(a=>result, b=>data_in, control=>control, multi_out=>RAM_datain);
Instruction_Counter : Counter port map(clk=>clk, reset=>reset, instruction_no=> select_instruction, jump=>jump, ready_jump=>jump_done, activate_jump=>activ_jump, stack_out=>stack_out, stack_jump=>active_stack);--stos
gate1 : or_gate port map(a=> ALU_done, b=> jump_done, c=> w_en, d => done);
Acumulator: FIFO_new port map(clk=>clk,reset=>reset,DataIn=>result,DataOut=>UART_tosend,WriteEn=>ALU_done,ReadEn=>trans_en);
UART_bus: UART_new port map(clk=>clk, reset=>reset, data_in=>UART_tosend, RX=>RX, TX=>TX,t_irq=>t_done); -- przerwania trzeba dodaæ
gate2: and_gate port map(a=>t_done,b=>dec_trans_en,c=>trans_en);
stos: stack port map(addr_in=>select_instruction,active_stack=>active_stack, addr_out=>stack_out, clk=>clk, reset=> reset); --stos
data_out<=result;
end Micro_arch;
