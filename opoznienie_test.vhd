----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:09:12 05/13/2019 
-- Design Name: 
-- Module Name:    opoznienie_test - behavioral 
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

entity opoznienie_test is
    Port ( clk : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end opoznienie_test;

architecture behavioral of opoznienie_test is

type RAM_ARRAY is array (0 to 31) of std_logic_vector (7 downto 0);

signal pamiec: RAM_array:=(
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00");
	
signal cicle: std_logic_vector;
begin

test: process(data_in)
begin
if cicle="00" then
	pamiec(to_integer(unsigned(RAM_addr))) <= data_in;
	end if;
end process;
	
end behavioral;

