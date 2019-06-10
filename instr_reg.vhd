--Wojciech Por�bi�ski
--Mikroprocesor - pami�� rozkaz�w
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_reg is
    Port ( ROM_addr : in  STD_LOGIC_VECTOR (6 downto 0);
           new_instruction : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in std_logic);
end instr_reg;

architecture instr_reg_arch of instr_reg is

type ROM_array is array (0 to 127) of std_logic_vector(15 downto 0); 


signal ROM: ROM_array:=
	("0100000111100101","0100000000010010","0100000000110010","1000000000001000",x"0000","0100000000110010",x"0000",x"0000",
	"0100000001000011","0100000000100010","0100000000100010","1111000000000000",x"0000","0111111000001100",x"0000",x"0000",
	--dane do test�w tego, co wystawia procesor
	--("0100000100000001",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	--x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	--dane do testu stosu
	--("1000000000000111",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000","0100000000010010",
	--"1010000000001011","0100000000010010","1000000001111111","0100000000010010","0100000000010010",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000","1000000001111111");--ostatnia instrukcja - p�tla niesko�czona

	

begin
	instr: process(clk)
	begin 
		if rising_edge(clk) then
			new_instruction<=ROM(to_integer(unsigned(ROM_addr)));
		end if;
	end process;
end instr_reg_arch;

