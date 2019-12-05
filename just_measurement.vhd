----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:16:08 10/15/2019 
-- Design Name: 
-- Module Name:    just_measurement - Behavioral 
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

--kopipeyou
--component just_measurement is
--	port( clk : in std_logic;
--			rst : in std_logic;
--			
--			msr_start : in std_logic; 
--			str_adr : in std_logic_vector(19 downto 0);
--			
--			sdr_req : out std_logic;
--			sdr_fin : in std_logic;
--			ctrl_data : in std_logic_vector(63 downto 0);
--			cite_addr : out std_logic_vector(19 downto 0);
--			
--			rf_pulse : out std_logic;
--			adc_sig : out std_logic);
--end component;
--
--measure : just_measurement 
--	port map( clk => ,
--				 rst => ,
--			
--				 msr_start => ,
--				 str_dar => ,
--			
--				 sdr_req => ,
--				 sdr_fin => ,
--				 ctrl_data => ,
--				 cite_addr => ,
--			
--				 rf_pulse => ,
--				 adc_sig => ,);




entity just_measurement is
	port( clk : in std_logic;
			rst : in std_logic;
			
			msr_start : in std_logic; --measurement start
			str_adr : in std_logic_vector(19 downto 0); --フェッチを開始するアドレス指定入力
			
			sdr_req : out std_logic; --sdram読み込みリクエスト
			sdr_fin : in std_logic; --sdram読み込み終了
			ctrl_data : in std_logic_vector(63 downto 0); --制御用データ
			cite_addr : out std_logic_vector(19 downto 0); --参照アドレス
			
			test_dout : out std_logic_vector(63 downto 0); --テスト用LED点灯用
			test_bit : out std_logic; --テスト用1bit信号
			
			rf_pulse : out std_logic; --RFパルス信号
			adc_sig : out std_logic); --ADC用信号
end just_measurement;

architecture measure of just_measurement is

	component data_fetch is
		port( clk : in std_logic;
				rst : in std_logic;
				msr_start : in std_logic;
				str_adr : in std_logic_vector(19 downto 0);
				
				data64 : out std_logic_vector(63 downto 0);
				fetch_fin : out std_logic; 
				decode_en : in std_logic;
				
				test_pin : out std_logic; --test
				
				data_req : out std_logic;
				sdr_adr : out std_logic_vector(19 downto 0);
				sdr_fin : in std_logic;
				sdr_data : in std_logic_vector(63 downto 0));	
	end component;

	component data_decode is
		port( clk : in std_logic;
				rst : in std_logic;
				
				data64 : in std_logic_vector(63 downto 0);
				fetch_fin : in std_logic;
				decode_en : out std_logic;
				
				cnt_en : out std_logic;
				
				de_data : out std_logic_vector(63 downto 0));
	end component;

	component timekeeper is
		port( clk : in std_logic;
				rst : in std_logic;
				cnt_start : in std_logic;
				data : in std_logic_vector(63 downto 0); 
				output : out std_logic);
	end component;
	
	--フェッチ-デコード用
	signal data64 : std_logic_vector(63 downto 0);
	signal data64_vr : std_logic_vector(63 downto 0); --test
	signal f_fin : std_logic;
	signal d_en : std_logic;
	signal s_req : std_logic;
	signal addr : std_logic_vector(19 downto 0);
	signal c_en : std_logic;
	signal d_data : std_logic_vector(63 downto 0);
	
	--カウンター用
	signal c_out : std_logic;
	
	--テスト用
	signal test : std_logic;

begin

	fetch : data_fetch 
		port map( clk => clk,
					 rst => rst,
					 msr_start => msr_start, 
					 str_adr => str_adr,
				
					 data64 => data64,
					 fetch_fin => f_fin, 
					 decode_en => d_en,
					 
					 test_pin => test, --test
				
					 data_req => s_req,
					 sdr_adr => addr,
					 sdr_fin => sdr_fin,
					 sdr_data => ctrl_data);	

	decode : data_decode 
		port map( clk => clk,
					 rst => rst,
				
					 data64 => data64,
					 fetch_fin => f_fin,
					 decode_en => d_en,
				
					 cnt_en => c_en,
				
					 de_data => d_data);

	title : timekeeper 
		port map( clk => clk,
					 rst => rst,
					 cnt_start => c_en,
					 data => d_data, 
					 --data => data64_vr,
					 output => c_out);
					 
	sdr_req <= s_req;
	cite_addr <= addr;
	rf_pulse <= c_out;
	
	test_dout <= d_data;
	test_bit <= c_en;
	data64_vr <= X"00000000000186A0"; --test

	end measure;

