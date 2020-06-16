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
			str_adr : in std_logic_vector(19 downto 0); --・ｽt・ｽF・ｽb・ｽ`・ｽ・ｽ・ｽJ・ｽn・ｽ・ｽ・ｽ・ｽA・ｽh・ｽ・ｽ・ｽX・ｽw・ｽ・ｽ・ｽ・ｽ・ｽ
			end_adr : in std_logic_vector(19 downto 0);
			
			sdr_req : out std_logic; --sdram・ｽﾇみ搾ｿｽ・ｽﾝ・ｿｽ・ｽN・ｽG・ｽX・ｽg
			sdr_fin : in std_logic; --sdram・ｽﾇみ搾ｿｽ・ｽﾝ終・ｽ・ｽ
			ctrl_data : in std_logic_vector(63 downto 0); --・ｽ・ｽ・ｽ・ｽp・ｽf・ｽ[・ｽ^
			cite_addr : out std_logic_vector(19 downto 0); --・ｽQ・ｽﾆア・ｽh・ｽ・ｽ・ｽX
			
			test_dout : out std_logic_vector(63 downto 0); --・ｽe・ｽX・ｽg・ｽpLED・ｽ_・ｽ・ｽ・ｽp
			test_bit : out std_logic; --・ｽe・ｽX・ｽg・ｽp1bit・ｽM・ｽ・ｽ
			
			rf_pulse : out std_logic; --RF・ｽp・ｽ・ｽ・ｽX・ｽM・ｽ・ｽ
			data : out std_logic; --DDS・ｽp・ｽM・ｽ・ｽ
			fqud : out std_logic;
			reset : out std_logic;
			w_clk : out std_logic;
			adc_sig : out std_logic); --ADC・ｽp・ｽM・ｽ・ｽ
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
				
				
				decode_fin_m : out std_logic;
				decode_fin_d : out std_logic;
				data_type : out std_logic_vector(3 downto 0);
				read_fin : in std_logic;
				decode_wait : in std_logic;
				count_end : out std_logic;

				d_data_out : out std_logic_vector(39 downto 0);
				c_data_out : out std_logic_vector(63 downto 0));
	end component;
		
	component master_counter is
		port( clk : in std_logic;
				rst : in std_logic;
				msr_fin : in std_logic;
				msr_allcomp : out std_logic;

				d_fin : in std_logic; 
				d_type : in std_logic_vector(3 downto 0); 
				rd_comp : out std_logic;
				data_full : out std_logic; 
				data : in std_logic_vector(63 downto 0); 

				output_rf : out std_logic;
				output_dds_1 : out std_logic_vector(7 downto 0);
				output_dds_2 : out std_logic_vector(7 downto 0);
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
				
				enable : out std_logic; 
				recieve : in std_logic;				
				data_out : out std_logic_vector(39 downto 0));
	end component;
	
	component DDS_data_drive is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (39 downto 0);
           enable : in  STD_LOGIC;
           recieve : out  STD_LOGIC;
           data_out_1 : out  STD_LOGIC_VECTOR (39 downto 0);
           data_out_2 : out  STD_LOGIC_VECTOR (39 downto 0);
           dds1_data : in  STD_LOGIC_VECTOR (7 downto 0);
           dds2_data : in  STD_LOGIC_VECTOR (7 downto 0);
				 req_dds_1	:	out	std_logic;
				 req_dds_2	:	out	std_logic;
			 	 enable_1	:	in	std_logic;
				 enable_2	:	in	std_logic);
	end component;
	
	component AD9851_ctrl is
		port(
			clk1 		: 	in		std_logic;
			clk2 		: 	in		std_logic;
			rst		:	in		std_logic;
			data40 	: 	in		std_logic_vector(39 downto 0);
			data	 	:	out	std_logic;
			fqud	 	:	out	std_logic;
			reset	 	:	out	std_logic;
			w_clk	 	:	out	std_logic;
			req_dds 	: 	in		std_logic;
			recieve	:	out	std_logic
		);
	end component;
	
--	component FIFO_A is
--		port( CLK : in std_logic;
--				RST : in std_logic;
--				DIN : in std_logic_vector(39 downto 0);
--				DOUT : out std_logic_vector(39 downto 0);
--				WR_EN : in std_logic;
--				RD_EN : in std_logic;
--				FULL : out std_logic;
--				EMPTY : out std_logic);
--	end component;
	
	--・ｽt・ｽF・ｽb・ｽ`-・ｽf・ｽR・ｽ[・ｽh・ｽp
	signal data64 : std_logic_vector(63 downto 0);
	signal m_fin : std_logic; --msr_finish・ｽﾉ対会ｿｽ
	signal f_fin : std_logic; --fetch_fin
	signal d_en : std_logic; --decode_en
	signal d_fin_c : std_logic; --decode_fin(master_counter)
	signal d_fin_d	:	std_logic;
	signal d_fin : std_logic;
	signal d_type : std_logic_vector(3 downto 0); --data_type
	signal rd_fin : std_logic; --read_fin
	signal d_wait : std_logic; --decoede_wait	
	signal s_req : std_logic;
	signal addr : std_logic_vector(19 downto 0);
	signal c_en : std_logic;
	signal d_data : std_logic_vector(39 downto 0); --dds・ｽf・ｽ[・ｽ^
	signal c_data : std_logic_vector(63 downto 0); --・ｽ}・ｽX・ｽ^・ｽ[・ｽJ・ｽE・ｽ・ｽ・ｽ^・ｽf・ｽ[・ｽ^
	signal d_change : std_logic;
	
	--・ｽ}・ｽX・ｽ^・ｽ[・ｽJ・ｽE・ｽ・ｽ・ｽ^・ｽp
	signal rf_out : std_logic;
	signal dds_set : std_logic;
	signal ad_out : std_logic;
	signal c_end : std_logic;
	signal rd_fin_c : std_logic; --read_fin
	signal msr_comp : std_logic;
	
	--DDS_data・ｽp
	signal dds_dat : std_logic_vector(39 downto 0);
	signal rd_fin_d : std_logic; --read_fin
	signal en_dat	:	std_logic;
	signal re_dat	:	std_logic;
	signal req_1 : std_logic;
	signal req_2 : std_logic;
	signal en_1 : std_logic;
	signal en_2 : std_logic;
	signal dds1_data : std_logic_vector(7 downto 0);
	signal dds2_data : std_logic_vector(7 downto 0);
	

	--DDS用
	signal data40_1 : std_logic_vector(39 downto 0);
	signal data40_2 : std_logic_vector(39 downto 0);



	signal f_data : std_logic_vector(39 downto 0); --first_data
	signal dds_f : std_logic;
	signal dds_s : std_logic; 
	

--	--fifo用
--	signal wr_en : std_logic;
--	signal rd_en : std_logic;
--	signal full : std_logic;
--	signal empty : std_logic;


	
	--・ｽe・ｽX・ｽg・ｽp
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
					 decode_fin_m => d_fin_c,
					 decode_fin_d => d_fin_d,
					 data_type => d_type,
					 read_fin => rd_fin,
					 decode_wait => d_wait,
					 count_end => c_end,
				
					 d_data_out => d_data,
					 c_data_out => c_data);
					 
	count_time : master_counter 
		port map( clk => clk,
					 rst => rst,
					 msr_fin => c_end,
					 msr_allcomp => msr_comp,

					 d_fin => d_fin, 
					 d_type => d_type,
					 rd_comp => rd_fin_c,
					 data_full => d_wait,
					 data => c_data, 

					 output_rf => rf_out,
					 output_dds_1 => dds1_data,
					 output_dds_2 => dds2_data,
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
				
					 enable => en_dat,
					 recieve => re_dat,
					 data_out => dds_dat);
	
	data_save : DDS_data_drive 
    Port map( clk => clk,
           rst => rst,
           data_in => dds_dat,
           enable => en_dat,
           recieve => re_dat,
           data_out_1 => data40_1,
           data_out_2 => data40_2,
           dds1_data => dds1_data,
           dds2_data => dds2_data,
				 req_dds_1	=> req_1,
				 req_dds_2	=> req_2,
			 	 enable_1	=> en_1,
				 enable_2	=> en_2);
	
	DDS : AD9851_ctrl 
		port map( clk1 => clk,
					 clk2 => clk,
					 rst	=> rst, 
					 data40 	=> data40_1,	
					 data	=> data,
					 fqud	 => fqud,
					 reset	=> reset,
					 w_clk	=> w_clk,
					 req_dds => req_1,
					 recieve => en_1);
					 
--	FIFO : FIFO_A 
--		port map( CLK => clk,
--					 RST => rst,
--					 DIN => dds_dat,
--					 DOUT => data40,
--					 WR_EN => wr_en,
--					 RD_EN => dds_set,
--					 FULL => full,
--					 EMPTY => empty);
					 
	rd_fin <= rd_fin_c or rd_fin_d;
					 
					 
	msr_finish <= c_end;
	sdr_req <= s_req;
	cite_addr <= addr;
	rf_pulse <= rf_out;
	adc_sig <= ad_out;
	
	test_dout(15 downto 0) <= data40_1(15 downto 0);
	test_bit <= led_blink;

	end measure;

