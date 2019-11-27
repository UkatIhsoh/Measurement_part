----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:06 10/15/2019 
-- Design Name: 
-- Module Name:    timekeeper - count_time 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--kopipeyou
--component timekeeper is
--	port( clk : in std_logic;
--			rst : in std_logic;
--			cnt_start : in std_logic;
--			data : in std_logic_vector(63 downto 0); 
--			output : out std_logic);
--end component;
--
--title : timekeeper 
--	port map( clk => ,
--				 rst => ,
--				 cnt_start => ,
--				 data => , 
--				 output => );

entity timekeeper is
	port( clk : in std_logic;
			rst : in std_logic;
			cnt_start : in std_logic;
			data : in std_logic_vector(63 downto 0); 
			output : out std_logic);
end timekeeper;

architecture count_time of timekeeper is

	signal counter : std_logic_vector(63 downto 0):= (others => '0'); 		--カウンター
	signal count_num : std_logic_vector(63 downto 0):=X"00000000000000FF";		--カウント上限
	signal data_en : std_logic:= '0'; 									--データがかわっているかのチェック
	signal en_count : std_logic_vector(7 downto 0):=(others => '0'); 		--出力がhighになっている時間のカウント
	signal out_sig : std_logic:='0'; 									--出力信号

	constant en_time : std_logic_vector(7 downto 0):= X"FF"; --出力high時間
	
begin

	output <= out_sig;
		
	process(clk,rst,cnt_start,data)
	begin
	
		if rst = '1' then
			--count_num <= (others => '0');
			data_en <= '0';
			en_count <= (others => '0');
			out_sig <= '0';
			counter <= (others => '0');
		elsif clk' event and clk = '1' then
			if out_sig = '1' then
				if en_count = en_time then --出力信号highの間の時間をカウントし、設定した時間になったら出力をlowにする
					en_count <= (others =>'0');
					out_sig <= '0';
				else
					en_count <= en_count +1; 
				end if;
			else
				if data_en = '1' then
					if counter = count_num then
						counter <= (others => '0');
						out_sig <= '1';
					else
						counter <= counter +1;
						out_sig <= '0';
					end if;
				else
					out_sig <= '0';
				end if;
			end if;
		end if;
		
		if cnt_start = '1' then --cnt_start(カウントスタート)がイネーブル中にカウント
			if data_en = '0' then
				counter <= (others => '0');
				--count_num <= data;
				data_en <= '1';
			end if;
		else 
			data_en <= '0';
		end if;
		
	end process;

end count_time;

