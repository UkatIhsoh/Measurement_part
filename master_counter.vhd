----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:33:32 12/05/2019 
-- Design Name: 
-- Module Name:    master_counter - count_time 
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

entity master_counter is
	port( clk : in std_logic;
			rst : in std_logic;
			cnt_start : in std_logic;
			d_fin : in std_logic; --デコードが終了しているかの確認
			rd_fin : out std_logic; --デコードから受けたデータを読み取ったことを伝える
			data : in std_logic_vector(63 downto 0); 
			output : out std_logic);
end master_counter;

architecture count_time of master_counter is

	type reg is record
		count_num_1 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_2 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_3 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_4 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_5 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_6 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_7 : std_logic_vector(63 downto 0);		--カウント上限
		count_num_8 : std_logic_vector(63 downto 0);		--カウント上限
	end record;	
	
	signal p : reg;
	signal n : reg;

	signal counter : std_logic_vector(63 downto 0):= (others => '0'); 		--カウンター

	signal data_en : std_logic:= '0'; 	--データがかわっているかのチェック
	signal preset : std_logic; --プリセットしているかどうかチェック
	
	signal rf_out : std_logic:='0';	--RFパルス用
	signal dds_set : std_logic:='0'; --ddsの周波数を変える	
	signal ad_out : std_logic:='0'; --AD用


		
begin

	output <= out_sig;
		
	process(clk,rst,cnt_start,data)
	begin
	
		if rst = '1' then
			count_num <= (others => '0');
			data_en <= '0';
			out_sig <= '0';
			d_num <= "00";
			counter <= (others => '0');
		elsif clk' event and clk = '1' then
			if cnt_start = '1' then
				if preset = '1' then
					
				end if;
			end if;
		end if;
				
		if preset = '0' then
			if
		end if;
		
	end process;

end count_time;



