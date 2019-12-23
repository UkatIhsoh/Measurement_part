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
			msr_finish : out std_logic; --mesurement finish
			str_adr : in std_logic_vector(19 downto 0); --フェッチを開始するアドレス指定入力
			end_adr : in std_logic_vector(19 downto 0);
			
			sdr_req : out std_logic; --sdram読み込みリクエスト
			sdr_fin : in std_logic; --sdram読み込み終了
			ctrl_data : in std_logic_vector(63 downto 0); --制御用データ
			cite_addr : out std_logic_vector(19 downto 0); --参照アドレス
			
			test_dout : out std_logic_vector(63 downto 0); --テスト用LED点灯用
			test_bit : out std_logic; --テスト用1bit信号
			
			rf_pulse : out std_logic; --RFパルス信号
			data : out std_logic; --DDS用信号
			fqud : out std_logic;
			reset : out std_logic;
			w_clk : out std_logic;
			adc_sig : out std_logic); --ADC用信号
end just_measurement;

architecture measure of just_measurement is

	component data_fetch is
		port( clk : in std_logic;
				rst : in std_logic;
				msr_start : in std_logic;
				msr_finish : out std_logic;
				str_adr : in std_logic_vector(19 downto 0);
				end_adr : in std_logic_vector(19 downto 0);
				
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
				msr_fin : in std_logic;
				
				data64 : in std_logic_vector(63 downto 0);
				fetch_fin : in std_logic;
				decode_en : out std_logic;
				decode_fin : out std_logic;
				data_type : out std_logic_vector(3 downto 0);
				read_fin : in std_logic;
				decode_wait : in std_logic;
				count_end : out std_logic;
				
				data_change : in std_logic;

				d_data_out : out std_logic_vector(39 downto 0);
				c_data_out : out std_logic_vector(34 downto 0));
	end component;
		
	component master_counter is
		port( clk : in std_logic;
				rst : in std_logic;
				msr_fin : in std_logic;

				d_fin : in std_logic; 
				d_type : in std_logic_vector(3 downto 0); 
				rd_comp : out std_logic;
				data_full : out std_logic; 
				data : in std_logic_vector(34 downto 0); 

				output_rf : out std_logic;
				output_dds : out std_logic;
				dds_start : out std_logic;
				dds_fin : out std_logic;
				output_ad : out std_logic);
	end component;
	
	component DDS_data is
		port( clk : in std_logic;
				rst : in std_logic;
				msr_fin : in std_logic;
				
				d_fin : in std_logic; 
				d_type : in std_logic_vector(3 downto 0); 
				rd_comp : out std_logic; 
				data : in std_logic_vector(39 downto 0);
				
				wr_en_a : out std_logic; 
				full_a : in std_logic;				
				data_out : out std_logic_vector(39 downto 0);
				first_data : out std_logic_vector(39 downto 0);
				data_end : out std_logic);
	end component;
	
	component AD9851_ctrl is
	port( clk 		: 	in		std_logic;
			rst		:	in		std_logic;
			first_data 	: 	in		std_logic_vector(39 downto 0); 
			data40 	: 	in		std_logic_vector(39 downto 0);
			start		:	in		std_logic;	
			data_change : 	in 	std_logic; 
			data	 	:	out	std_logic;
			fqud	 	:	out	std_logic;
			reset	 	:	out	std_logic;
			w_clk	 	:	out	std_logic;
			msr_fin 	: 	in		std_logic); 
	end component;
	
	component FIFO_A is
		port( CLK : in std_logic;
				RST : in std_logic;
				DIN : in std_logic_vector(39 downto 0);
				DOUT : out std_logic_vector(39 downto 0);
				WR_EN : in std_logic;
				RD_EN : in std_logic;
				FULL : out std_logic;
				EMPTY : out std_logic);
	end component;
	
	--フェッチ-デコード用
	signal data64 : std_logic_vector(63 downto 0);
	signal m_fin : std_logic; --msr_finishに対応
	signal f_fin : std_logic; --fetch_fin
	signal d_en : std_logic; --decode_en
	signal d_fin_c : std_logic; --decode_fin(master_counter)
	signal d_fin : std_logic;
	signal d_type : std_logic_vector(3 downto 0); --data_type
	signal rd_fin : std_logic; --read_fin
	signal d_wait : std_logic; --decoede_wait	
	signal s_req : std_logic;
	signal addr : std_logic_vector(19 downto 0);
	signal c_en : std_logic;
	signal d_data : std_logic_vector(39 downto 0); --ddsデータ
	signal c_data : std_logic_vector(34 downto 0); --マスターカウンタデータ
	signal d_change : std_logic;
	
	--マスターカウンタ用
	signal rf_out : std_logic;
	signal dds_set : std_logic;
	signal ad_out : std_logic;
	signal c_end : std_logic;
	signal rd_fin_c : std_logic; --read_fin
	
	--DDS_data用
	signal dds_dat : std_logic_vector(39 downto 0);
	signal rd_fin_d : std_logic; --read_fin
	
	--DDS用
	signal data40 : std_logic_vector(39 downto 0);
	signal f_data : std_logic_vector(39 downto 0); --first_data
	signal dds_f : std_logic;
	signal dds_s : std_logic; 
	
	--fifo用
	signal wr_en : std_logic;
	signal rd_en : std_logic;
	signal full : std_logic;
	signal empty : std_logic;
	
	--テスト用
	signal test : std_logic:='0';
	signal led_blink : std_logic:='0';
	
	begin

	fetch : data_fetch 
		port map( clk => clk,
					 rst => rst,
					 msr_start => msr_start, 
					 msr_finish => m_fin,
					 str_adr => str_adr,
					 end_adr => end_adr, 
				
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
					 msr_fin => m_fin,
				
					 data64 => data64,
					 fetch_fin => f_fin,
					 decode_en => d_en,
					 decode_fin => d_fin,
					 data_type => d_type,
					 read_fin => rd_fin,
					 decode_wait => d_wait,
					 count_end => c_end,
					 
					 data_change => d_change,
				
					 d_data_out => d_data,
					 c_data_out => c_data);
					 
	count_time : master_counter 
		port map( clk => clk,
					 rst => rst,
					 msr_fin => c_end,

					 d_fin => d_fin, 
					 d_type => d_type,
					 rd_comp => rd_fin_c,
					 data_full => d_wait,
					 data => c_data, 

					 output_rf => rf_out,
					 output_dds => dds_set,
					 dds_start => dds_s,
					 dds_fin => dds_f,
					 output_ad => ad_out);
					 
	data_acquire : DDS_data 
		port map( clk => clk,
					 rst => rst,
				  	 msr_fin => c_end,
				
					 d_fin => d_fin,
					 d_type => d_type,
					 rd_comp => rd_fin_d,
					 data => d_data,
				
					 wr_en_a => wr_en,
					 full_a => full,
					 data_out => dds_dat,
					 first_data => f_data,
					 data_end => d_change);
	
	DDS : AD9851_ctrl 
		port map( clk => clk,
					 rst	=> rst,
					 first_data => f_data, 
					 data40 	=> data40,
					 start	=> dds_s,	
					 data_change => dds_set, 
					 data	=> data,
					 fqud	 => fqud,
					 reset	=> reset,
					 w_clk	=> w_clk,
					 msr_fin => dds_f);
					 
	FIFO : FIFO_A 
		port map( CLK => clk,
					 RST => rst,
					 DIN => dds_dat,
					 DOUT => data40,
					 WR_EN => wr_en,
					 RD_EN => dds_set,
					 FULL => full,
					 EMPTY => empty);
					 
	rd_fin <= rd_fin_c or rd_fin_d;
					 
	process(wr_en)
	begin
		if wr_en = '1' then
			led_blink <= not led_blink;
			--led_blink <= '1';
		end if;
	end process;
					 
	msr_finish <= m_fin;
	sdr_req <= s_req;
	cite_addr <= addr;
	rf_pulse <= rf_out;
	adc_sig <= ad_out;
	
	test_dout(15 downto 0) <= c_data(15 downto 0);
	test_bit <= led_blink;

	end measure;

