--Wojciech Porêbiñski
--multiplekser
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplekser is
		Generic (
		constant DATA_WIDTH  : positive := 8
	);
    Port ( a : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           b : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           control : in  STD_LOGIC;
           multi_out : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0));
end multiplekser;

architecture multi_arch of multiplekser is

begin
	multi: process(a,b,control)
	begin 
		if(control='1') then
			multi_out<=a;
		else
			multi_out<=b;
		end if;
	end process;

end multi_arch;

