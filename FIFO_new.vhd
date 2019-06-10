library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity FIFO_new is
  generic (
    DATA_WIDTH : positive := 8;
    FIFO_DEPTH : positive := 32
    );
  port (
    reset : in std_logic;
    clk      : in std_logic;
    WriteEn   : in  std_logic;
    DataIn : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    ReadEn   : in  std_logic;
    DataOut : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end FIFO_new;
 
architecture FIFO_newarch of FIFO_new is
 
  type t_FIFO_DATA is array (0 to FIFO_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal r_FIFO_DATA : t_FIFO_DATA := (others => (others => '0'));
 
  signal r_WR_INDEX   : integer range 0 to FIFO_DEPTH-1 := 0;
  signal r_RD_INDEX   : integer range 0 to FIFO_DEPTH-1 := 0;
 
  -- # Words in FIFO, has extra range to allow for assert conditions
  signal r_FIFO_COUNT : integer range -1 to FIFO_DEPTH+1 := 0;
  
  signal a: std_logic;

begin
 
  p_CONTROL : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        r_FIFO_COUNT <= 0;
        r_WR_INDEX   <= 0;
        r_RD_INDEX   <= 0;
		  a <= '0';
      else
			if WriteEn='1' then
				a<='1';
			else
				a<='0';
			end if;
			
        -- Keeps track of the total number of words in the FIFO
        if (WriteEn = '1' and a='1' and ReadEn = '0') then --
          r_FIFO_COUNT <= r_FIFO_COUNT + 1;
        elsif (WriteEn = '0' and ReadEn = '1') then
          r_FIFO_COUNT <= r_FIFO_COUNT - 1;
        end if;
 
        -- Keeps track of the write index (and controls roll-over)
        if WriteEn = '1' and a='1' then  --
          if r_WR_INDEX = FIFO_DEPTH-1 then
            r_WR_INDEX <= 0;
          else
            r_WR_INDEX <= r_WR_INDEX + 1;
          end if;
        end if;
 
        -- Keeps track of the read index (and controls roll-over)        
        if (ReadEn = '1') then
          if r_RD_INDEX = FIFO_DEPTH-1 then 
            --r_RD_INDEX <= 0; -- jak na razie zabronione przekrêcenie - nie mo¿e byæ, bo rzuca znowu dane (zera)
          else
				r_FIFO_DATA(r_RD_INDEX)<=(others =>'0');
            r_RD_INDEX <= r_RD_INDEX + 1;
          end if;
        end if;
 
        -- Registers the input data when there is a write
        if WriteEn = '1' and a='1' then --usuniêto stable 15 ns
          r_FIFO_DATA(r_WR_INDEX) <= DataIn;
        end if;
         
      end if; 
    end if;
  end process p_CONTROL;
  
  DataOut <= r_FIFO_DATA(r_RD_INDEX);

   
end FIFO_newarch;