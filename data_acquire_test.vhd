--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:52:17 03/31/2020
-- Design Name:   
-- Module Name:   E:/hoshino_Data/SotsuKen/ISE/measurement_part_git/data_acquire_test.vhd
-- Project Name:  measurement_part
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DDS_data
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

use IEEE.NUMERIC_STD.ALL;

library work;
use work.data_types.all;
 
ENTITY data_acquire_test IS
END data_acquire_test;
 
ARCHITECTURE behavior OF data_acquire_test IS  
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DDS_data
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         msr_fin : IN  std_logic;
         d_fin : IN  std_logic;
         d_type : IN  std_logic_vector(3 downto 0);
         rd_comp : OUT  std_logic;
         data : IN  std_logic_vector(39 downto 0);
         wr_en_a : OUT  std_logic;
         full_a : IN  std_logic;
         data_out : OUT  std_logic_vector(39 downto 0);
         first_data : OUT  std_logic_vector(39 downto 0);
         data_end : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal msr_fin : std_logic := '0';
   signal d_fin : std_logic := '0';
   signal d_type : std_logic_vector(3 downto 0) := (others => '0');
   signal data : std_logic_vector(39 downto 0) := (others => '0');
   signal full_a : std_logic := '0';

 	--Outputs
   signal rd_comp : std_logic;
   signal wr_en_a : std_logic;
   signal data_out : std_logic_vector(39 downto 0);
   signal first_data : std_logic_vector(39 downto 0);
   signal data_end : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DDS_data PORT MAP (
          clk => clk,
          rst => rst,
          msr_fin => msr_fin,
          d_fin => d_fin,
          d_type => d_type,
          rd_comp => rd_comp,
          data => data,
          wr_en_a => wr_en_a,
          full_a => full_a,
          data_out => data_out,
          first_data => first_data,
          data_end => data_end
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
		rst <= '1'; 
		wait for 100 ns;
		rst <= '0'; 
      -- insert stimulus here 
		full_a <= '0';
		d_type <= dds_A;
		d_fin <= '1';
		data <= X"0000000004";
   	wait for clk_period*4;
		d_fin <= '0';
		wait for clk_period*4;
		d_fin <= '1';
		data <= X"0000011111";
   	wait for clk_period*4;
		d_fin <= '0';
		wait for clk_period*4; 
		d_fin <= '1';
		data <= X"00000fffff";
   	wait for clk_period*4;
		d_fin <= '0';
		wait for clk_period*4;
		d_fin <= '1';
		data <= X"0000055555"; 
   	wait for clk_period*4;
		d_fin <= '0';
		wait for clk_period*10;
		msr_fin <= '1';

      wait;
   end process;

END;
