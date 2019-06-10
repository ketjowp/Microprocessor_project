
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_LCD is
    Port ( lcd_e : out  STD_LOGIC;
           lcd_rs : out  STD_LOGIC;
           lcd_rw : out  STD_LOGIC;
           lcd_db : out  STD_LOGIC_VECTOR (7 downto 4);
			  reset: in std_logic;
			  clk: in std_logic);
end test_LCD;

architecture test_LCD_arch of test_LCD is

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

component pamiec_znakow is
	Port (  RAM_dataout : out  STD_LOGIC_VECTOR (127 downto 0);
           RAM_clk : in  STD_LOGIC);
end component pamiec_znakow;


signal dane: std_logic_vector(127 downto 0);
begin


pamiec:pamiec_znakow port map(RAM_dataout=>dane,RAM_clk=>clk);
ster:lcd16x2_ctrl port map(clk=>clk,rst=>reset,lcd_e=>lcd_e,lcd_rs=>lcd_rs,lcd_rw=>lcd_rw,lcd_db=>lcd_db,line1_buffer=>dane,line2_buffer=>dane);


end test_LCD_arch;

