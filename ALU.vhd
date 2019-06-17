--Wojciech Porêbiñski
--Mikroprocesor - ALU komponent
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity ALU is
    Port ( data1 : in  STD_LOGIC_VECTOR (7 downto 0);
           data2 : in  STD_LOGIC_VECTOR (7 downto 0);
           arit_instruction : in  STD_LOGIC_VECTOR (3 downto 0);
			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  activate :in STD_LOGIC;
           result : out  STD_LOGIC_VECTOR (7 downto 0);
			  ready : out std_logic);
end ALU;

architecture ALU_arch of ALU is 
signal bufor_multi: std_logic_vector(15 downto 0);

begin 

arithm: process (clk, reset)
	begin
		if reset='1' then
			result <=(others=>'0');
			bufor_multi<=(others =>'0');
		elsif rising_edge(clk) then
			
			ready <='0';
			if activate='1' then
			case arit_instruction is
				when "0000" => result <= (others =>'0');
				when "0001" => result <= data1;
				when "0010" => result <= data1+data2;
				when "0011" => result <= data1-data2;
				
				when "0100" => 
					bufor_multi<=data1*data2;
					result <= bufor_multi(15 downto 8);
				when "0101" =>
					bufor_multi<=data1*data2;
					result <= bufor_multi(7 downto 0);
					
				when "0110" => result <= data1 or data2;
				when "0111" => result <= data1 and data2;
				when "1000" => result <= data1 xor data2;
				when "1001" => result <= data1 nand data2;
				when "1010" => result <= data1(6 downto 0) & data1(7); --rol
				when "1011" => result <= data1(0) & data1(7 downto 1); --ror
				when "1100" => result <= not data1;
				when "1101" => result <= (data1 + "01");
				when "1110" => result <= (data1 - "01");
				when "1111" => result <= data2;
				when others => result <=(others =>'0'); 
			end case;
			ready <='1';
			end if;
		end if;
	end process;

end ALU_arch;

