
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY lcd_tb_new IS
END lcd_tb_new;
 
ARCHITECTURE behavior OF lcd_tb_new IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_LCD
    PORT(
         lcd_e : OUT  std_logic;
         lcd_rs : OUT  std_logic;
         lcd_rw : OUT  std_logic;
         lcd_db : OUT  std_logic_vector(7 downto 4);
         reset : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal lcd_e : std_logic;
   signal lcd_rs : std_logic;
   signal lcd_rw : std_logic;
   signal lcd_db : std_logic_vector(7 downto 4);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: test_LCD PORT MAP (
          lcd_e => lcd_e,
          lcd_rs => lcd_rs,
          lcd_rw => lcd_rw,
          lcd_db => lcd_db,
          reset => reset,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset<='1';
      wait for 100 ns;	
		reset<='0';
		
      wait for clk_period*100000;

      -- insert stimulus here 

      wait;
   end process;

END;
