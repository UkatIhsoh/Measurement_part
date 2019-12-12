--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:59:04 12/06/2019
-- Design Name:   
-- Module Name:   E:/hoshino_Data/SotsuKen/ISE/measurement_part_git/mc_test.vhd
-- Project Name:  measurement_part
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: master_counter
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

library work;
use work.data_types.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mc_test IS
END mc_test;
 
ARCHITECTURE behavior OF mc_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT master_counter
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         d_fin : IN  std_logic;
         d_type : IN  std_logic_vector(3 downto 0);
         rd_comp : OUT  std_logic;
         data : IN  std_logic_vector(31 downto 0);
         output_rf : OUT  std_logic;
         output_dds : OUT  std_logic;
         output_ad : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal d_fin : std_logic := '0';
   signal d_type : std_logic_vector(3 downto 0) := (others => '0');
   signal data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal rd_comp : std_logic;
   signal output_rf : std_logic;
   signal output_dds : std_logic;
   signal output_ad : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: master_counter PORT MAP (
          clk => clk,
          rst => rst,
          d_fin => d_fin,
          d_type => d_type,
          rd_comp => rd_comp,
          data => data,
          output_rf => output_rf,
          output_dds => output_dds,
          output_ad => output_ad
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
      -- hold reset state for 100 n s.
			rst <= '1';
      wait for 100 ns;	
			rst <= '0';
      wait for clk_period*10;
			data <= X"00000001";
			d_type <= first;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
			data <= X"00000002";
			d_type <= second;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
			data <= X"00000004";
			d_type <= third;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
			data <= X"00000007";
			d_type <= fourth;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
			data <= X"00000009";
			d_type <= fifth;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
			data <= X"0000000A";
			d_type <= sixth;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
			data <= X"0000000D";
			d_type <= seventh;
			d_fin <= '1';
		wait for clk_period;
			d_fin <= '0';
		wait for clk_period;
--			data <= X"0000000000000002";
--			d_type <= first;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;
--			data <= X"0000000000000004";
--			d_type <= second;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;
--			data <= X"0000000000000008";
--			d_type <= third;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;
--			data <= X"000000000000000F";
--			d_type <= fourth;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;
--			data <= X"0000000000000012";
--			d_type <= fifth;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;
--			data <= X"0000000000000014";
--			d_type <= sixth;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;
--			data <= X"000000000000001A";
--			d_type <= seventh;
--			d_fin <= '1';
--		wait for clk_period;
--			d_fin <= '0';
--		wait for clk_period;

      wait;
   end process;

END;
