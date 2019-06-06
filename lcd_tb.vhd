--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:10:11 06/02/2019
-- Design Name:   
-- Module Name:   D:/Folderyzpulpitu/Programowanie/VHDL/PUL_projekt/lcd_tb.vhd
-- Project Name:  PUL_projekt
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd16x2_ctrl
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY lcd_tb IS
END lcd_tb;
 
ARCHITECTURE behavior OF lcd_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd16x2_ctrl
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         lcd_e : OUT  std_logic;
         lcd_rs : OUT  std_logic;
         lcd_rw : OUT  std_logic;
         lcd_db : OUT  std_logic_vector(7 downto 4);
         line1_buffer : IN  std_logic_vector(127 downto 0);
         line2_buffer : IN  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal line1_buffer : std_logic_vector(127 downto 0) := (others => '0');
   signal line2_buffer : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal lcd_e : std_logic;
   signal lcd_rs : std_logic;
   signal lcd_rw : std_logic;
   signal lcd_db : std_logic_vector(7 downto 4);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd16x2_ctrl PORT MAP (
          clk => clk,
          rst => rst,
          lcd_e => lcd_e,
          lcd_rs => lcd_rs,
          lcd_rw => lcd_rw,
          lcd_db => lcd_db,
          line1_buffer => line1_buffer,
          line2_buffer => line2_buffer
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
      wait for 100 ns;	
		rst <= '0';
		line1_buffer <= x"32333632343600000000000000000000";
		line2_buffer <= x"00000000000000000000000000000000";

      wait for clk_period*10000000;

      -- insert stimulus here 
		assert false severity failure;
   end process;

END;
