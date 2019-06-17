--Wojciech Porêbiñski
--stos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity stack is
    Port ( addr_in : in  STD_LOGIC_VECTOR (6 downto 0);
				active_stack: in std_logic;
           addr_out : out  STD_LOGIC_VECTOR (6 downto 0);
			  clk : in std_logic;
			  reset : in std_logic);
end stack;

architecture stack_arch of stack is

begin

pop: process(clk,reset)
begin
	if reset='1' then
		addr_out<=(others =>'0');
	elsif rising_edge(clk) then
		if active_stack='1' then
			addr_out<=addr_in;
		end if;
	end if;
end process;

end stack_arch;

