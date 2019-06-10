--Wojciech Porêbiñski
--licznik znaków
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity licznik is
	generic (liczba_znakow: std_logic_vector(3 downto 0) :="0111");
    Port ( clk : in  STD_LOGIC;
           irq : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  cnt: out std_logic_vector(3 downto 0);
			  en : out std_logic);
end entity licznik;

architecture sign_counter_arch of licznik is
signal zliczanie : std_logic_vector(3 downto 0);
begin

liczenie: process(clk,reset)
begin
	if reset='1' then
			en<='0';
			zliczanie<="0000";
	else
		if(rising_edge(clk) and irq='1') then --and irq'stable(15 ns)) then
		zliczanie<=zliczanie+"01";
		end if;
	
		if zliczanie=liczba_znakow then
			en<='1';
			zliczanie<="0000";
		else
			en<='0';
		end if;
	end if;
end process;

cnt<=zliczanie;

end sign_counter_arch;

