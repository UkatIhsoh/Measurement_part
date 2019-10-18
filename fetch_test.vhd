--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:56:29 10/18/2019
-- Design Name:   
-- Module Name:   E:/hoshino_Data/SotsuKen/ISE/measurement_part/fetch_test.vhd
-- Project Name:  measurement_part
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_fetch
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
 
ENTITY fetch_test IS
END fetch_test;
 
ARCHITECTURE behavior OF fetch_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_fetch
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         msr_start : IN  std_logic;
         data64 : OUT  std_logic_vector(63 downto 0);
         fetch_fin : OUT  std_logic;
         decode_en : IN  std_logic;
         data_req : OUT  std_logic;
         sdr_adr : OUT  std_logic_vector(19 downto 0);
         sdr_data : IN  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal msr_start : std_logic := '0';
   signal decode_en : std_logic := '0';
   signal sdr_data : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal data64 : std_logic_vector(63 downto 0);
   signal fetch_fin : std_logic;
   signal data_req : std_logic;
   signal sdr_adr : std_logic_vector(19 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_fetch PORT MAP (
          clk => clk,
          rst => rst,
          msr_start => msr_start,
          data64 => data64,
          fetch_fin => fetch_fin,
          decode_en => decode_en,
          data_req => data_req,
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
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';

      wait for clk_period*10;

      -- insert stimulus here 
		
		msr_start <= '1'; 
		
		wait for clk_period*2;
		
		sdr_data <= X"FFFFFFFFFFFFFFFF";
		
		wait for clk_period*2;
		
		decode_en <= '1';

      wait;
   end process;

END;
