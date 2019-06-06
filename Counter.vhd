--Wojciech Porêbiñski 236246
-- licznik rozkazów

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Counter is
    Port ( clk : in  STD_LOGIC;
           jump : in  STD_LOGIC_VECTOR (6 downto 0);
			  activate_jump: in STD_LOGIC;
			  ready_jump : out std_logic;
           instruction_no : out  STD_LOGIC_VECTOR (6 downto 0):="0000000");
end Counter;

architecture Counter_arch of Counter is

signal cicle : std_logic_vector(1 downto 0):="00";
signal instr : STD_LOGIC_VECTOR (6 downto 0):="0000000";

begin
cicle_counter: process(clk)
	begin
		if rising_edge(clk) then 
			cicle<=cicle+"01";
		end if;
end process;

instruction_counter: process(clk)
begin
	if rising_edge(clk) then
		ready_jump<='0';
		if activate_jump='1' then
			instr<=jump;
			ready_jump<='1'; 
		elsif cicle="11" and instr/="1111111" then
			instr<=instr+"01";
			ready_jump<='1';
		end if;
	end if;	
end process;
	
instruction_no<=instr;
end Counter_arch;

