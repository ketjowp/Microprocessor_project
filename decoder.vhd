--Wojciech Porêbiñski
--Mikroprocesor - dekoder rozkazów i uk³ad sterowaania komponent
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity decoder is
    Port ( full_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
				done: in std_logic;
           addr_reg_1 : out  STD_LOGIC_VECTOR (4 downto 0);
           addr_reg_2 : out  STD_LOGIC_VECTOR (4 downto 0);
           short_instruction : out  STD_LOGIC_VECTOR (3 downto 0);
			  --addr_out : out STD_LOGIC_VECTOR (4 downto 0);
			  activ_ALU : out std_logic:='0';
			  jump: out std_logic_vector(6 downto 0);
			  activ_jump: out std_logic;
			  control: out std_logic;
			  w_en: out std_logic;
			  trans_en: out std_logic;
			  stack_jump: out std_logic; --stos
			  clk : in STD_LOGIC;
			  reset: in std_logic);
end decoder;

architecture decoder_arch of decoder is


begin
decoding: process(clk,reset)
begin
	if reset='1' then
		addr_reg_1<="00000";
		addr_reg_2<="00000";
		short_instruction<="0000";
		activ_ALU<='0';
		activ_jump<='0';
		jump<="0000000";
		control<='0';
		w_en<='0';
		trans_en<='0';
		stack_jump<='0'; -- stos
		
	elsif rising_edge(clk) then
			w_en<='0';
			case full_instruction(15 downto 14) is
				when "00" =>--
					control<='0';
					if full_instruction(13 downto 12) ="11" then
						w_en<='1';
						addr_reg_1<=full_instruction(11 downto 7);
					end if;
					
				when "01" =>
					control<='1';
					addr_reg_1 <= full_instruction(13 downto 9);
					addr_reg_2 <= full_instruction(8 downto 4);
					short_instruction <= full_instruction(3 downto 0);
				if done='0' then
					activ_ALU<='1';
				else
					activ_ALU<='0';
				end if;
				
				when "10" =>
					if(full_instruction(13)='0') then
						jump <= full_instruction(6 downto 0);
						if done='0' then
							activ_jump<='1';
						else
							activ_jump<='0';
						end if;
					else	
						jump<= full_instruction(6 downto 0); --stos
						if done='0' then
							stack_jump<='1';
						else
							stack_jump<='0';
						end if;
					end if;
				
				when "11"=>
					if full_instruction(13 downto 12)="00" then
						trans_en<='0';
					elsif full_instruction(13 downto 12)="11" then
						trans_en<='1';
					end if;
					
				when others => 
			end case;
			--addr_out<=full_instruction(13 downto 9);
		end if;
	
	
end process;
end decoder_arch;

