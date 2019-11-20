----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:51 10/18/2019 
-- Design Name: 
-- Module Name:    data_fetch - fetch 
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
--component data_fetch is
--	port( clk : in std_logic;
--			rst : in std_logic;
--			msr_start : in std_logic; 
--			
--			data64 : out std_logic_vector(63 downto 0);
--			fetch_fin : out std_logic; 
--			decode_en : in std_logic;
--			
--			data_req : out std_logic;
--			sdr_adr : out std_logic_vector(19 downto 0);
--			sdr_data : in std_logic_vector(63 downto 0));	
--end component;
--
--fetch : data_fetch 
--	port map( clk => ,
--				 rst => ,
--				 msr_start => , 
--			
--				 data64 => ,
--				 fetch_fin => , 
--				 decode_en => ,
--			
--				 data_req => ,
--				 sdr_adr => ,
--				 sdr_data => ,);	


entity data_fetch is
	port( clk : in std_logic;
			rst : in std_logic;
			msr_start : in std_logic; 
			
			data64 : out std_logic_vector(63 downto 0);
			fetch_fin : out std_logic; 
			decode_en : in std_logic;
			
			data_req : out std_logic;
			sdr_adr : out std_logic_vector(19 downto 0);
			sdr_data : in std_logic_vector(63 downto 0));	
end data_fetch;

architecture fetch of data_fetch is

	type state_t is (idle, dt_wait, dt_aquire, prepare); --状態名（アイドル、データ待機、データ獲得、次への準備）

	type reg is record
		data : std_logic_vector(63 downto 0);
		f_fin : std_logic; --fetch完了
		d_req : std_logic;
		addr : std_logic_vector(19 downto 0);
		f_run : std_logic;	--fetch回路動作中
		state : state_t;
		fresh : std_logic;
	end record;

	signal p : reg;
	signal n : reg;
	
--	signal fresh : std_logic:= '1';
	
	constant start_adr : std_logic_vector(19 downto 0):= X"00000";

begin

	data64 <= p.data;
	fetch_fin <= p.f_fin;
	
	data_req <= p.d_req;
	sdr_adr <= p.addr; 
	
	process(n,p,msr_start,sdr_data,decode_en,n.state)
	begin
		n <= p;
		
		if msr_start = '1' then
			if p.f_run = '0' then --fetch回路始動
				n.d_req <= '1';	--ｓｄｒamへリクエスト
				n.f_run <= '1';
				if p.fresh = '1' then --freshでないならstart_addressを読み込み
					n.addr <= start_adr;
					n.fresh <= '0';
				else
					n.addr <= p.addr +1;
				end if;
				n.state <= dt_wait;
			else
				n.d_req <= '0';
				case p.state is
					when idle =>
						null;
				
					when dt_wait => 
						n.state <= dt_aquire;
						
					when dt_aquire => 
						n.data <= sdr_data;
						n.f_fin <= '1';
						n.state <= prepare;
						
					when prepare => 
						if decode_en = '1' then
							n.f_run <= '0';
							n.state <= idle;
						end if;
						
					when others =>
						n.f_run <= '0';
				end case;					
			end if;
		end if;
	end process;
	
	process(clk,rst)
	begin
		if rst = '1' then
			p.data <= (others => '0');
			p.f_fin <= '0';
			p.d_req <= '0';
			p.addr <= (others => '0');
			p.f_run <= '0';
			p.state <= idle;
			p.fresh <= '1';
		elsif clk' event and clk = '1' then
			p <= n;
		end if;
	end process;

end fetch;

