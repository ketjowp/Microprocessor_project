--Wojciech Porêbiñski
--Modu³ nadrzêdny - po³¹czenie Mikroprocesora z uk³adem sterowania LCD za pomoc¹ UART

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_module is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  data_out_proc: out STD_LOGIC_VECTOR(7 downto 0);
			  lcd_e : OUT  std_logic;
				lcd_rs : OUT  std_logic;
				lcd_rw : OUT  std_logic;
				lcd_db : OUT  std_logic_vector(7 downto 4);
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end top_module;

architecture top_arch of top_module is
 
component Microprocessor is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  RX: in STD_LOGIC;
			  TX: out STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component Microprocessor;

component LCD_control is
    Port ( 	RX : IN std_logic;
				TX : OUT std_logic;
				lcd_e : OUT  std_logic;
				lcd_rs : OUT  std_logic;
				lcd_rw : OUT  std_logic;
				lcd_db : OUT  std_logic_vector(7 downto 4);
				reset: in std_logic;
				clk: in std_logic
	 );
end component LCD_control;

signal proc_out: std_logic;
signal proc_in: std_logic;

begin

proc:Microprocessor port map(clk=>clk,reset=>reset,TX=>proc_out, RX=>proc_in, data_out=>data_out_proc,data_in=>data_in);
controler:LCD_control port map(clk=>clk,reset=>reset,RX=>proc_out,TX=>proc_in, lcd_e=>lcd_e,lcd_rs=>lcd_rs,lcd_rw=>lcd_rw,lcd_db=>lcd_db);


end top_arch;

