--drugi testbench (sprawdzenie sprzê¿enia zwrotnego i ALU)
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY second_tb IS
END second_tb;
 
ARCHITECTURE behavior OF second_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Microprocessor
    PORT(
         data_in : IN  std_logic_vector(7 downto 0);
         data_out : OUT  std_logic_vector(7 downto 0);
			RX: in STD_LOGIC;
			TX: out STD_LOGIC;
         clk : IN  std_logic;
         reset : IN  std_logic  
        );
    END COMPONENT;
    

   --Inputs
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal instr : std_logic_vector(6 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
	signal RX : std_logic :='0';

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
	signal TX : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Microprocessor PORT MAP (
          data_in => data_in,
          data_out => data_out,
          clk => clk,
          reset => reset,
			 TX=>TX,
			 RX=>RX
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
		reset<='1';
		wait for clk_period;
		reset<='0';
		--instr<="0000000";
      wait for clk_period*4;
		--instr<="0000001";
		wait for clk_period*4;
		--instr<="0000010";
		wait for clk_period*1000;
		
      assert false severity failure; 
   end process;

END;
