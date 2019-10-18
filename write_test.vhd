--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:25:25 10/08/2019
-- Design Name:   
-- Module Name:   E:/hoshino_Data/SotsuKen/ISE/measurement_part/write_test.vhd
-- Project Name:  measurement_part
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SDRAM_wr
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
 
ENTITY write_test IS
END write_test;
 
ARCHITECTURE behavior OF write_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SDRAM_wr
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         tr_sw : IN  std_logic;
         sdr_req : OUT  std_logic;
         sdr_adr : OUT  std_logic_vector(19 downto 0);
         sdr_data : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal tr_sw : std_logic := '0';

 	--Outputs
   signal sdr_req : std_logic;
   signal sdr_adr : std_logic_vector(19 downto 0);
   signal sdr_data : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SDRAM_wr PORT MAP (
          clk => clk,
          rst => rst,
          tr_sw => tr_sw,
          sdr_req => sdr_req,
          sdr_adr => sdr_adr,
          sdr_data => sdr_data
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
		rst <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '0';
		
      wait for clk_period*10;

      -- insert stimulus here 
		tr_sw <= '1';

      wait;
   end process;

END;
