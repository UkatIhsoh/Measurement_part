--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:02:15 10/18/2019
-- Design Name:   
-- Module Name:   E:/hoshino_Data/SotsuKen/ISE/measurement_part/timekeeper_test.vhd
-- Project Name:  measurement_part
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: timekeeper
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
 
ENTITY timekeeper_test IS
END timekeeper_test;
 
ARCHITECTURE behavior OF timekeeper_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timekeeper
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         cnt_start : IN  std_logic;
         data : IN  std_logic_vector(63 downto 0);
         output : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal cnt_start : std_logic := '0';
   signal data : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timekeeper PORT MAP (
          clk => clk,
          rst => rst,
          cnt_start => cnt_start,
          data => data,
          output => output
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
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		
      wait for clk_period*10;

      data <= X"0000000000000005";
		cnt_start <= '1';
		
		wait for clk_period*10;
		
		cnt_start <= '0';
		
		wait for clk_period;
		
		data <= X"0000000000000003";
		cnt_start <= '1';

      wait;
   end process;

END;
