--Wojciech Porêbiñski
-- Testbench ca³ego modu³u
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY third_tb IS
END third_tb;
 
ARCHITECTURE behavior OF third_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_module
    PORT(
         data_in : IN  std_logic_vector(7 downto 0);
         data_out_proc : OUT  std_logic_vector(7 downto 0);
			lcd_e : OUT  std_logic;
				lcd_rs : OUT  std_logic;
				lcd_rw : OUT  std_logic;
				lcd_db : OUT  std_logic_vector(7 downto 4);
         reset : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal reset : std_logic := '1';
   signal clk : std_logic := '0';

 	--Outputs
   signal data_out_proc : std_logic_vector(7 downto 0);
	signal lcd_e: std_logic;
	signal lcd_rs: std_logic;
	signal lcd_rw: std_logic;
	signal lcd_db: std_logic_vector(7 downto 4);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_module PORT MAP (
          data_in => data_in,
          data_out_proc => data_out_proc,
			 lcd_e=>lcd_e,
			 lcd_rs=>lcd_rs,
			 lcd_rw=>lcd_rw,
			 lcd_db=>lcd_db,
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
      wait for 15 ns;	
		reset<='0';
      wait for clk_period*10000;

      -- insert stimulus here 

      wait;
   end process;

END;
