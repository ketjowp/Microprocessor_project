----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:01:32 06/10/2019 
-- Design Name: 
-- Module Name:    stack - stack_arch 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

