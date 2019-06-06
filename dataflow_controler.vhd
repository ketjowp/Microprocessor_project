--Wojciech Porêbiñski
--sterownik
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dataflow_controler is
    Port ( data_multi : out  STD_LOGIC;
           ALU_in : in  STD_LOGIC;
			  contr_clk : in STD_LOGIC;
			  result : in STD_LOGIC_VECTOR(7 downto 0));
end dataflow_controler;

architecture contr_arch of dataflow_controler is
begin

	control: process(contr_clk)
	begin
		if rising_edge(contr_clk) then
			if ALU_in='1' then
				data_multi<='1';
			else
				data_multi<='0';
			end if;
		end if;
	end process;
end contr_arch;

