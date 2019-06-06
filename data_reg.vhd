--Wojciech Porêbiñski
--Mikroprocesor - pamiêæ danych (rejestry)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_reg is
    Port ( RAM_datain : in  STD_LOGIC_VECTOR (7 downto 0);
           RAM_addr_1 : in  STD_LOGIC_VECTOR (4 downto 0);
			  RAM_addr_2 : in  STD_LOGIC_VECTOR (4 downto 0);
           RAM_w_en : in  STD_LOGIC;
           RAM_dataout_1 : out  STD_LOGIC_VECTOR (7 downto 0);
			  RAM_dataout_2 : out  STD_LOGIC_VECTOR (7 downto 0);
           RAM_clk : in  STD_LOGIC);
end data_reg;

architecture data_reg_arch of data_reg is

type RAM_ARRAY is array (0 to 31) of std_logic_vector (7 downto 0);

signal RAM: RAM_array:=(
	x"30",x"01",x"02",x"03",x"04",x"00",x"00",x"00",
	x"08",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00");


begin
	reg: process(RAM_clk)
		begin
		if(rising_edge(RAM_clk)) then
			if(RAM_w_en='1') then
					RAM(to_integer(unsigned(RAM_addr_1))) <= RAM_datain;
			end if;
		end if;
	end process;
	
	RAM_dataout_1<=RAM(to_integer(unsigned(RAM_addr_1)));
	RAM_dataout_2<=RAM(to_integer(unsigned(RAM_addr_2)));
end data_reg_arch;

