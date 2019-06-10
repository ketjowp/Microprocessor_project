--Wojciech Porêbiñski
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LCD_sign_memory is
	Port ( RAM_datain : in  STD_LOGIC_VECTOR (7 downto 0);
           RAM_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           RAM_w_en : in  STD_LOGIC;
			  RAM_r_en : in STD_logic;
           RAM_dataout : out  STD_LOGIC_VECTOR (127 downto 0);
           RAM_clk : in  STD_LOGIC);
end LCD_sign_memory;

architecture LCD_mem_arch of LCD_sign_memory is

type RAM_ARRAY is array (0 to 15) of std_logic_vector (7 downto 0);

signal RAM: RAM_ARRAY:=(
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00");

begin
	reg: process(RAM_clk)
		begin
		if(rising_edge(RAM_clk)) then
			if(RAM_w_en='1') then
					RAM(to_integer(unsigned(RAM_addr))) <= RAM_datain;
			end if;
		end if;
	end process;
	
	reading: process(RAM_clk)
		begin
		if rising_edge(RAM_clk) then
			if RAM_r_en='1' then
				RAM_dataout<=RAM(0)&RAM(1)&RAM(2)&RAM(3)&RAM(4)&RAM(5)&RAM(6)&RAM(7)&RAM(8)&RAM(9)&RAM(10)&RAM(11)&RAM(12)&RAM(13)&RAM(14)&RAM(15);
			end if;
		end if;
	end process;

end LCD_mem_arch;

