--ALU testbench
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_first_tb IS
END ALU_first_tb;
 
ARCHITECTURE behavior OF ALU_first_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         data1 : IN  std_logic_vector(7 downto 0);
         data2 : IN  std_logic_vector(7 downto 0);
         instruction : IN  std_logic_vector(3 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         result : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data1 : std_logic_vector(7 downto 0) := (others => '0');
   signal data2 : std_logic_vector(7 downto 0) := (others => '0');
   signal instruction : std_logic_vector(3 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal result : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          data1 => data1,
          data2 => data2,
          instruction => instruction,
          clk => clk,
          reset => reset,
          result => result
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
	reset <='1';
	data1<="10000010";
	data2<="10000001";
	instruction<="0000";
	wait for 10 ns;
	instruction<="0001";
	wait for 10 ns;
	instruction<="0010";
	wait for 10 ns;
	instruction<="0011";
	wait for 10 ns;
	instruction<="0100";
	wait for 10 ns;
	instruction<="0101";
	wait for 10 ns;
	instruction<="0110";
	wait for 10 ns;
	instruction<="0111";
	wait for 10 ns;
	instruction<="1000";
	wait for 10 ns;
	instruction<="1001";
	wait for 10 ns;
	instruction<="1010";
	wait for 10 ns;
	instruction<="1011";
	wait for 10 ns;
	instruction<="1100";
	wait for 10 ns; 




	assert false severity failure;

      wait;
   end process;

END;
