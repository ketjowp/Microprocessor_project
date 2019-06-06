--Wojciech Porêbiñski
--Mikroprocesor - dekoder rozkazów komponent
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity decoder is
    Port ( full_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
			  --done_ALU : in STD_LOGIC;
           addr_reg_1 : out  STD_LOGIC_VECTOR (4 downto 0);
           addr_reg_2 : out  STD_LOGIC_VECTOR (4 downto 0);
           short_instruction : out  STD_LOGIC_VECTOR (3 downto 0);
			  addr_out : out STD_LOGIC_VECTOR (4 downto 0);
			  activ_ALU : out std_logic:='0';
			  jump: out std_logic_vector(6 downto 0);
			  activ_jump: out std_logic;
			  --done_jump: in std_logic;
			  done: in std_logic;
			  clk : in STD_LOGIC);
end decoder;

architecture decoder_arch of decoder is

signal tmp : std_logic_vector(4 downto 0);

begin
decoding: process(clk)
begin
	if rising_edge(clk) then
			case full_instruction(15 downto 14) is
				when "01" =>
					addr_reg_1 <= full_instruction(13 downto 9);
					addr_reg_2 <= full_instruction(8 downto 4);
					short_instruction <= full_instruction(3 downto 0);
				if done='0' then
					activ_ALU<='1';
				else
					activ_ALU<='0';
				end if;
				
				when "10" =>
					jump <= full_instruction(6 downto 0);
				if done='0' then
					activ_jump<='1';
				else
					activ_jump<='0';
				end if;
				
				when "11"=>
					
				when others => 
			end case;
			addr_out<=full_instruction(13 downto 9);
		end if;
	
	
end process;
end decoder_arch;

