--Wojciech Porêbiñski
--ca³y mikrokontroler - komunikacja z wyœwietlaczem LCD
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity LCD_control is
    Port ( 	RX : IN std_logic;
				TX : OUT std_logic;
				lcd_e : OUT  std_logic;
				lcd_rs : OUT  std_logic;
				lcd_rw : OUT  std_logic;
				lcd_db : OUT  std_logic_vector(7 downto 4);
				reset: in std_logic;
				clk: in std_logic
	 );
end LCD_control;

architecture LCD_arch of LCD_control is

--component top_module is
    --Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           --data_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  --data_out_proc: out STD_LOGIC_VECTOR(7 downto 0);
			  --r_irq: out std_logic;
           --reset : in  STD_LOGIC;
           --clk : in  STD_LOGIC);
--end component top_module;

component UART_periph is
port (
	--data_in: in std_logic_vector(7 downto 0); -- wejscie danych do peryferium z procesora
	data_out: out std_logic_vector(7 downto 0);
	r_irq :out std_logic; -- odebrany bajt
	--t_irq :out std_logic;	-- wys³any bajt
	clk :in std_logic;
	reset :in std_logic;
	TX : out std_logic;
	RX : in std_logic
);
end component UART_periph;

component licznik is
	generic(liczba_znakow: std_logic_vector(3 downto 0) :="0110");
    Port ( clk : in  STD_LOGIC;
           irq : in  STD_LOGIC;
			  reset: in STD_LOGIC;
			  cnt : out std_logic_vector(3 downto 0);
			  en : out std_logic);
end component licznik;

component LCD_sign_memory is
	Port ( RAM_datain : in  STD_LOGIC_VECTOR (7 downto 0);
           RAM_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           RAM_w_en : in  STD_LOGIC;
			  RAM_r_en : in STD_logic;
           RAM_dataout : out  STD_LOGIC_VECTOR (127 downto 0);
           RAM_clk : in  STD_LOGIC);
end component LCD_sign_memory;

component lcd16x2_ctrl is
  generic (
    CLK_PERIOD_NS : positive := 20);    -- 50MHz
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    lcd_e        : out std_logic;
    lcd_rs       : out std_logic;
    lcd_rw       : out std_logic;
    lcd_db       : out std_logic_vector(7 downto 4);
    line1_buffer : in  std_logic_vector(127 downto 0);  -- 16x8bit
    line2_buffer : in  std_logic_vector(127 downto 0)); 
end component lcd16x2_ctrl;

signal one_sign : std_logic_vector(7 downto 0);
signal received : std_logic;
signal LCD_enable : std_logic;
signal address : std_logic_vector(3 downto 0);
signal whole_line : std_logic_vector(127 downto 0);




begin

UART: UART_periph port map(RX=>RX,TX=>TX,clk=>clk,reset=>reset,data_out=>one_sign,r_irq=>received);
licz: licznik port map(clk=>clk,reset=>reset,irq=>received, cnt=>address, en=>LCD_enable);
pamiec: LCD_sign_memory port map(RAM_clk=>clk,RAM_datain=>one_sign,RAM_w_en=>received,RAM_r_en=>LCD_enable,RAM_dataout=>whole_line,RAM_addr=>address);
sterowanie: lcd16x2_ctrl port map(clk=>clk,rst=>reset,lcd_e=>lcd_e,lcd_rs=>lcd_rs,lcd_rw=>lcd_rw,lcd_db=>lcd_db,line1_buffer=>whole_line,line2_buffer=>(others =>'0')); 

end LCD_arch;

