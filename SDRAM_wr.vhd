----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:10:09 10/03/2019 
-- Design Name: 
-- Module Name:    SDRAM_wr - Behavioral 
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

--kopipeyou
--component SDRAM_wr is
--	port(	clk : in std_logic;
--			rst : in std_logic;
--			
--			tr_sw : in std_logic;
--
--			adr_in : in std_logic_vector(19 downto 0);
--			
--			sdr_req : out std_logic;
--			sdr_adr : out std_logic_vector(19 downto 0);
--			sdr_data : out std_logic_vector(63 downto 0));
--end component;
--
--write_sec : SDRAM_wr
--	port map( clk => ,
--				 rst => ,
--				 tr_sw => ,
--				 adr_in => ,
--				 sdr_req => ,
--				 sdr_adr => ,
--				 sdr_data => );

entity SDRAM_wr is
	port(	clk : in std_logic;
			rst : in std_logic;
			
			tr_sw : in std_logic;
			
			--adr_in : in std_logic_vector(19 downto 0);
			
			sdr_req : out std_logic;
			sdr_adr : out std_logic_vector(19 downto 0);
			sdr_data : out std_logic_vector(63 downto 0));
end SDRAM_wr;

architecture write_sec of SDRAM_wr is

	constant smp_data : std_logic_vector(63 downto 0):= X"000186A0000186A0"; --カウント値
	--constant smp_data : std_logic_vector(63 downto 0):= X"0000FFFF05050A0A"; --テスト用
	--constant smp_data : std_logic_vector(63 downto 0):= X"000000000000C350"; --テスト用2


	signal v_data : std_logic_vector(63 downto 0):= smp_data; 

	type state_t is (idle, sd_request, cycle_end); --状態名（アイドル状態、sdram動作、処理サイクル終了） 

	type reg is record
		data : std_logic_vector(63 downto 0); --データ用
		adr : std_logic_vector(19 downto 0); --アドレス用
		req : std_logic; --リクエスト用
		pend : std_logic; 
		state : state_t; --状態繊維用
		comp : std_logic; --書き込みリピート防止
	end record;
	
	signal p : reg;
	signal n : reg;

begin

	sdr_req <= p.req;
	sdr_adr <= p.adr;
	sdr_data <= p.data;
	
	process(p,n,tr_sw,n.data,n.adr,n.state)
	begin
		n <= p;               
		n.state <= p.state;   
	 
		if tr_sw = '1' then --tr_swが押されるとデータの書き込みが始まる
			if p.comp = '0' then
				n.pend <= '1';
				n.comp <= '1';
				if p.pend = '0' then
					n.adr <= p.adr +1; --アドレス変更
					n.data <= p.data + smp_data; --書き込みデータセット
					n.state <= sd_request;
				end if;
			end if;
		else
			n.comp <= '0';
			n.pend <= '0';
		end if;
	
		case p.state is
			when idle =>
				null;
				
			when sd_request =>
				n.req <= '1';
				n.state <= cycle_end;
				
			when cycle_end =>
				n.req <= '0';
				n.pend <= '0';
				v_data <= v_data; 
				n.state <= idle;
				
			when others =>
				n.req <= '0';
				n.pend <= '0';
				n.state <= idle;
		end case;
	
	end process;
	
	--クロックに同期してｎ信号がp信号に変わる
	process(clk,rst)
	begin
		if rst = '1' then
			p.data <= (others => '0');
			p.adr <= (others => '0');
			p.req <= '0';
			p.pend <= '0';
			p.state <= idle;
			p.comp <= '0';
			v_data <= smp_data;
		elsif clk' event and clk = '1' then
			p <= n;
		end if;
	end process;


end write_sec;

