----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:52:12 10/08/2019 
-- Design Name: 
-- Module Name:    Measurement - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values 
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Measurement is
    Port (	clk : in  STD_LOGIC;
				
				WING_A	:	inout	std_logic_vector(15 downto 0);
				WING_B	:	inout	std_logic_vector(15 downto 0);
				WING_C	:	inout	std_logic_vector(15 downto 0);
--				TXD		:	in	std_logic;
--				RXD		:	out std_logic;
				
				DRAM_ADDR   : OUT		STD_LOGIC_VECTOR (12 downto 0);
				DRAM_BA     : OUT    STD_LOGIC_VECTOR (1 downto 0);
				DRAM_CAS_N  : OUT    STD_LOGIC;
				DRAM_CKE    : OUT    STD_LOGIC;
				DRAM_CLK    : OUT    STD_LOGIC;
				DRAM_CS_N   : OUT    STD_LOGIC;
				DRAM_DQ     : INOUT  STD_LOGIC_VECTOR(15 downto 0);
				DRAM_DQM    : OUT    STD_LOGIC_VECTOR(1 downto 0);
				DRAM_RAS_N  : OUT    STD_LOGIC;
				DRAM_WE_N   : OUT    STD_LOGIC;
								
				LED			: OUT	STD_LOGIC);
end Measurement;

architecture connect of Measurement is

	component DCM_100M is
		port( CLK_IN1 : in std_logic;
				CLK_100M : out std_logic);
	end component;

	component sdram_ctrl is
			port( clk1 	  : 	in 	std_logic;
					rst			:	in		std_logic;
					
					--SDRAM用信号
					sdram_addr	:	out	std_logic_vector(11 downto 0);
					sdram_ba		:	out	std_logic_vector(1 downto 0);
					sdram_cs		:	out	std_logic;
					sdram_cke	:	out	std_logic;
					sdram_clk	:	out	std_logic;
					sdram_dq		:	inout	std_logic_vector(15 downto 0);
					sdram_dqm	:	out	std_logic_vector(1 downto 0);
					sdram_ras	:	out	std_logic;
					sdram_cas	:	out	std_logic;
					sdram_we		:	out	std_logic;
					
					
					data_in		:	in		std_logic_vector(63 downto 0);
					data_out		:	out	std_logic_vector(63 downto 0);
					req_read		:	in		std_logic;
					req_write	:	in		std_logic;
					address		:	in		std_logic_vector(19 downto 0);
					data_mask	:	in		std_logic_vector(1 downto 0);
					data_out_valid : OUT     STD_LOGIC);
		end component;

	component SDRAM_wr is
		port(	clk : in std_logic;
				rst : in std_logic;
				
				tr_sw : in std_logic;
				--adr_in  : in std_logic_vector(19 downto 0);
				
				sdr_req : out std_logic;
				sdr_adr : out std_logic_vector(19 downto 0);
				sdr_data : out std_logic_vector(63 downto 0));
	end component;
	
	component SDRAM_rd is
		port(	clk : in std_logic;
				rst : in std_logic;
				
				re_sw : in std_logic;
				ctrl_data : out std_logic_vector(63 downto 0);
				
				adr_in : in std_logic_vector(19 downto 0);
				
				fetch_en : out std_logic;
				
				sdr_req : out std_logic;
				sdr_adr : out std_logic_vector(19 downto 0);
				sdr_fin : in std_logic;
				sdr_data : in std_logic_vector(63 downto 0));
	end component;
	
	component just_measurement is
	port( clk : in std_logic;
			rst : in std_logic;
			
			msr_start : in std_logic; 
			msr_finish : out std_logic;
			str_adr : in std_logic_vector(19 downto 0);
			end_adr : in std_logic_vector(19 downto 0);
			
			sdr_req : out std_logic;
			sdr_fin : in std_logic;
			ctrl_data : in std_logic_vector(63 downto 0);
			cite_addr : out std_logic_vector(19 downto 0);
			
			test_dout : out std_logic_vector(63 downto 0);
			test_bit : out std_logic;
			
			rf_pulse : out std_logic;
			data : out std_logic;
			fqud : out std_logic;
			reset : out std_logic;
			w_clk : out std_logic;
			adc_sig : out std_logic);
	end component;

	--common
	signal rst : std_Logic;
	signal clk100 : std_logic;
	
	--sdram_ctrl
	signal data64_i : std_logic_vector(63 downto 0);
	signal data64_o : std_logic_vector(63 downto 0);
	signal sdr_req_r : std_logic;
	signal sdr_req_w : std_logic;
	signal sdr_addr : std_logic_vector(19 downto 0);
	signal sdr_mask : std_logic_vector(1 downto 0):= "11";
	signal sdr_d_o_valid : std_logic;
	
	--sdram_wr
	signal tr_sw : std_logic;
	signal wr_adr : std_logic_vector(19 downto 0);
	signal req_adr_w : std_logic_vector(19 downto 0);
	
	--sdram_rd
	signal re_sw : std_logic;
	signal data64 : std_logic_vector(63 downto 0);
	signal rd_adr : std_logic_vector(19 downto 0);
	signal req_adr_r : std_logic_vector(19 downto 0);
	signal f_en : std_logic;
 	
	--just_measuremant
	signal msr_start : std_logic;
	signal m_fin : std_logic;
	signal str_adr : std_logic_vector(19 downto 0);
	signal end_adr : std_logic_vector(19 downto 0);
	signal rf : std_logic;
	signal data : std_logic;
	signal fqud : std_logic;
	signal reset : std_logic;
	signal w_clk : std_logic;
	signal adc : std_logic;
	signal test_d : std_logic_vector(63 downto 0); --テスト用
	signal test_b : std_logic; --テスト用
	
begin

--	OBUF_inst : OBUF
--   generic map (
--      DRIVE => 12,
--      IOSTANDARD => "DEFAULT",
--      SLEW => "SLOW")
--   port map (
--      O => O,     -- Buffer output (connect directly to top-level port)
--      I => I      -- Buffer input 
--   );

	DCM : DCM_100M
		port map( CLK_IN1 => clk,
					 CLK_100M => clk100);

	ctrl : sdram_ctrl
			port map( clk1			=>	clk100,
						 rst			=>	rst,
						 sdram_addr	=>	DRAM_ADDR(11 downto 0),
						 sdram_ba    => DRAM_BA,
						 sdram_cas   => DRAM_CAS_N,
						 sdram_cke   => DRAM_CKE,
						 sdram_clk   => DRAM_CLK,
						 sdram_cs    => DRAM_CS_N,
						 sdram_dq    => DRAM_DQ,
						 sdram_dqm   => DRAM_DQM,
						 sdram_ras   => DRAM_RAS_N,
						 sdram_we    => DRAM_WE_N,
						 data_in		=>	data64_i,
						 data_out		=>	data64_o,
						 req_read		=>	sdr_req_r,
						 req_write	=>	sdr_req_w,
						 address		=> sdr_addr,
						 data_mask	=>	sdr_mask,
						 data_out_valid => sdr_d_o_valid);
			
	write_sec : SDRAM_wr
		port map( clk => clk100,
					 rst => rst,
					 tr_sw => tr_sw,
					 --adr_in => req_adr_w,
					 sdr_req => sdr_req_w,
					 sdr_adr => wr_adr,
					 sdr_data => data64_i);

	read_sec : SDRAM_rd 
		port map( clk => clk100,
					 rst => rst,
					 re_sw => re_sw,
					 ctrl_data => data64,
					 adr_in => req_adr_r,
					 fetch_en => f_en,
					 sdr_req => sdr_req_r,
					 sdr_adr => rd_adr,
					 sdr_fin => sdr_d_o_valid,
					 sdr_data => data64_o);
					 
	measure : just_measurement 
		port map( clk => clk100,
					 rst => rst,
				
					 msr_start => msr_start,
					 msr_finish => m_fin,
					 str_adr => str_adr,
					 end_adr => end_adr,
				
					 sdr_req => re_sw,
					 sdr_fin => sdr_d_o_valid,
					 ctrl_data => data64,
					 cite_addr => req_adr_r,
					 
					 test_dout => test_d, --テスト用
					 test_bit => test_b, --テスト用
				
					 rf_pulse => rf,
					 data => data,
					 fqud => fqud,
					 reset => reset,
					 w_clk => w_clk,
					 adc_sig => adc);
	
	req_adr_w <= X"00000"; --test
	
	str_adr <= X"00000";
	end_adr <= X"00006";
	
	--ピン割り当て
	DRAM_ADDR(12) <= '0';
	
	rst	<= WING_B(0);
	tr_sw	<= WING_B(1);
	msr_start <= WING_B(2);
	--start <= WING_A(1);
	
	--WING_A(4 downto 1) <= test_d(3 downto 0); --テスト用
	--WING_A(0) <= rf;
	WING_A(0) <= test_b; --テスト用
	--WING_A(2) <= adc;
	WING_A(15 downto 1) <= test_d(15 downto 1); --テスト用
	--WING_A(0) <= fin_sig;
	LED <= msr_start;

end connect;

