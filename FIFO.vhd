library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
entity FIFO is
	Generic (
		constant DATA_WIDTH  : positive := 8;
		constant FIFO_DEPTH	: positive := 256
	);
	Port ( 
		clk		: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
	);
end FIFO;
 
architecture FIFO_arch of FIFO is
 
begin
 
	-- Memory Pointer Process
	fifo_proc : process (clk)
		type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		variable memory : FIFO_Memory;
		
		variable Head : natural range 0 to FIFO_DEPTH - 1;
		variable Tail : natural range 0 to FIFO_DEPTH - 1;
		variable Looped : boolean;
	begin
		if rising_edge(clk) then
			if reset = '1' then
				Head := 0;
				Tail := 0;
				
				Looped := false;
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = FIFO_DEPTH - 1) then
							Tail := 0;
							
							Looped := false;
						else
							Tail := Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) := DataIn;
						
						-- Increment Head pointer as needed
						if (Head = FIFO_DEPTH - 1) then
							Head := 0;
							
							Looped := true;
						else
							Head := Head + 1;
						end if;
					end if;
				end if;

			end if;
		end if;
	end process;
		
end FIFO_arch;