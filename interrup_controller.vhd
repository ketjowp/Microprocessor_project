--Wojciech Porêbiñski
--kontroler przerwañ
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interrupt_controler is
    Port ( t_irq : in  STD_LOGIC;
           r_irq : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           control : out  STD_LOGIC;
           instr : out  STD_LOGIC_VECTOR (7 downto 0));
end interrupt_controller;

architecture interrupt_arch of interrupt_controler is

begin

control: process(t_irq,r_irq,reset)
begin

	if reset='1' then
		instr<=x"0000";
		control<='0';
	else
		if r_irq='1' then
			instr<=x"0000"; -- instrukcja przy odbieraniu
			control<='1';
		elsif t_irq='1' then
			instr<= --instrukcja dla FIFO przy transmisji
			control<='1';
		end if;
	end if;
end process;
	
end interrupt_arch;