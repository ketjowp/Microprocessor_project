--Wojciech Porêbiñski 236246
-- licznik rozkazów - komponent steruj¹cy kolejnoœci¹ wykonywania rozkazów

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Counter is
    Port ( clk : in  STD_LOGIC;
				reset: in STD_LOGIC;
           jump : in  STD_LOGIC_VECTOR (6 downto 0);
			  stack_out: in STD_LOGIC_VECTOR(6 downto 0);
			  activate_jump: in STD_LOGIC;
			  stack_jump: in std_logic;
			  ready_jump : out std_logic;
           instruction_no : out  STD_LOGIC_VECTOR (6 downto 0):="0000000");
end Counter;

architecture Counter_arch of Counter is

signal cicle : std_logic_vector(1 downto 0):="00";
signal instr : STD_LOGIC_VECTOR (6 downto 0):="0000000";
signal flag : std_logic;


begin
cicle_counter: process(clk,reset)
	begin
	if reset='1' then
		cicle<="00";
	elsif rising_edge(clk) then 
			cicle<=cicle+"01";
	end if;
end process;

instruction_counter: process(clk,reset)
begin
	if reset='1' then
		instr<="0000000";
		ready_jump<='0';
		flag<='0';
		
	elsif rising_edge(clk) then
		ready_jump<='0';
		if flag='1' then
				instr<=stack_out+"01";
				flag<='0';
				ready_jump<='1';
		else
			if activate_jump='1' then
				instr<=jump;
				ready_jump<='1';
			elsif stack_jump='1' then --stos
				instr<=jump;
				flag<='1';
				ready_jump<='1';
			elsif cicle="11" then --and instr/="1111111" then - ¿eby siê nie przekrêca³o i wykonywa³o instrukcji w kó³ko
				instr<=instr+"01";
				ready_jump<='1';
			end if;
		end if;
	end if;

end process;
	
instruction_no<=instr;

end Counter_arch;

