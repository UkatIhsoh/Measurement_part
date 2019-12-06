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

library work;
use work.data_types.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--kopipeyou
--component master_counter is
--	port( clk : in std_logic;
--			rst : in std_logic;
--			d_fin : in std_logic; 
--			d_type : in std_logic_vector(3 downto 0); 
--			rd_comp : out std_logic; 
--			data : in std_logic_vector(63 downto 0); 
--			output_rf : out std_logic;
--			output_dds : out std_logic;
--			output_ad : out std_logic);
--end component;
--
--count_time : master_counter 
--	port map( clk => ,
--				 rst => ,
--				 d_fin => , 
--				 d_type => ,
--				 rd_comp => ,
--				 data => , 
--				 output_rf => ,
--				 output_dds => ,
--				 output_ad => );


entity master_counter is
	port( clk : in std_logic;
			rst : in std_logic;
			
			d_fin : in std_logic; --デコードが終わったかどうかみる
			d_type : in std_logic_vector(3 downto 0); --どのタイプのでーたが来るのかを確認
			rd_comp : out std_logic; --データの読み取りが終わったかどうか見る
			data_full : out std_logic; --データが満タンなのを知らせる
			data : in std_logic_vector(63 downto 0); 
			
			output_rf : out std_logic; --出力
			output_dds : out std_logic;
			output_ad : out std_logic);
end master_counter;

architecture count_time of master_counter is

	type reg is record
		t_1 : std_logic_vector(63 downto 0);		--カウント上限
		t_2 : std_logic_vector(63 downto 0);		--カウント上限
		t_3 : std_logic_vector(63 downto 0);		--カウント上限
		t_4 : std_logic_vector(63 downto 0);		--カウント上限
		t_5 : std_logic_vector(63 downto 0);		--カウント上限
		t_6 : std_logic_vector(63 downto 0);		--カウント上限
		t_7 : std_logic_vector(63 downto 0);		--カウント上限
		t_0 : std_logic_vector(63 downto 0);		--カウント上限
	end record;	
	
	signal p : reg;
	signal n : reg;

	signal counter : std_logic_vector(63 downto 0):= (others => '0'); 		--カウンター

	signal preset : std_logic:= '0'; --プリセットしているかどうかチェック
	signal dst_1 : std_logic:= '0'; --データセットがどの程度進行しているか
	signal dst_2 : std_logic:= '0'; 
	signal dst_3 : std_logic:= '0'; 
	signal dst_4 : std_logic:= '0'; 
	signal dst_5 : std_logic:= '0';
	signal dst_6 : std_logic:= '0'; 
	signal dst_7 : std_logic:= '0'; 
	signal dst_0 : std_logic:= '0'; 
	signal full : std_logic:= '0'; --データが満タン状態を知らせる
	signal comp_rd : std_logic:= '0'; --rd_compに対応
	
	signal rf_out : std_logic:='0';	--RFパルス用
	signal dds_set : std_logic:='0'; --ddsの周波数を変える	
	signal ad_out : std_logic:='0'; --AD用
		
begin

	rd_comp <= comp_rd;
	data_full <= full;
	
	output_rf <= rf_out;
	output_dds <= dds_set;
	output_ad <= ad_out;
		
	process(clk,rst,data,d_fin,d_type)
	begin
	
		if rst = '1' then
			counter <= (others => '0');
			preset <= '0';
			full <= '0';
			comp_rd <= '0';
			rf_out <= '0';
			dds_set <= '0';
			ad_out <= '0';
			dst_1 <= '0';	dst_2 <= '0';	dst_3 <= '0';	dst_4 <= '0';	dst_5 <= '0';	dst_6 <= '0';	dst_7 <= '0';
		elsif clk' event and clk = '1' then
			if preset = '1' then
				if counter = p.t_1 then	
					counter <= counter +1;	
					rf_out <= '1';
				elsif counter = p.t_2 then	
					counter <= counter +1;	
					rf_out <= '0';
				elsif counter = p.t_3 then	
					counter <= counter +1;	
					dds_set <= '1';
				elsif counter = p.t_4 then	
					counter <= counter +1;	
					rf_out <= '1';
				elsif counter = p.t_5 then	
					counter <= counter +1;	
					rf_out <= '0';
				elsif counter = p.t_6 then	
					counter <= counter +1;	
					dds_set <= '1';	
				elsif counter = p.t_7 then
					counter <= (others => '0');
					ad_out <= '1';
					p <= n;
					full <= '0';					
				elsif counter = p.t_0 then
					counter <= counter +1;					
				else	
					counter <= counter +1;
					dds_set <= '0';
					ad_out <= '0';
				end if;
			end if;
		end if;
		
		if preset = '0' then
			if d_fin = '1' then
				case d_type is
					when first =>		
						p.t_1 <= data;	comp_rd <= '1';	dst_1 <= '1';
					
					when second =>		
						p.t_2 <= data;	comp_rd <= '1';	dst_2 <= '1';
						
					when third =>		
						p.t_3 <= data;	comp_rd <= '1';	dst_3 <= '1';
					
					when fourth =>		
						p.t_4 <= data;	comp_rd <= '1';	dst_4 <= '1';
						
					when fifth =>		
						p.t_5 <= data;	comp_rd <= '1';	dst_5 <= '1';
					
					when sixth =>		
						p.t_6 <= data;	comp_rd <= '1';	dst_6 <= '1';
						
					when seventh =>	
						p.t_7 <= data;	comp_rd <= '1';	dst_7 <= '1';
					
					when eighth =>		
						p.t_0 <= data;	comp_rd <= '1';	dst_0 <= '1';
						
					when others =>		
						comp_rd <= '1';
				end case;
			else
				comp_rd <= '0';
				if dst_1 = '1' and dst_2 = '1' and dst_3 = '1' and dst_4 = '1' and dst_5 = '1' and dst_6 = '1' and dst_7 = '1' then
					preset <= '1';
					dst_1 <= '0';	dst_2 <= '0';	dst_3 <= '0';	dst_4 <= '0';	dst_5 <= '0';	dst_6 <= '0';	dst_7 <= '0';
				end if;
			end if;
		else
			if d_fin = '1' then
				case d_type is
					when first =>		
						n.t_1 <= data;	comp_rd <= '1';	dst_1 <= '1';
					
					when second =>		
						n.t_2 <= data;	comp_rd <= '1';	dst_2 <= '1';
						
					when third =>		
						n.t_3 <= data;	comp_rd <= '1';	dst_3 <= '1';
					
					when fourth =>		
						n.t_4 <= data;	comp_rd <= '1';	dst_4 <= '1';
						
					when fifth =>		
						n.t_5 <= data;	comp_rd <= '1';	dst_5 <= '1';
					
					when sixth =>		
						n.t_6 <= data;	comp_rd <= '1';	dst_6 <= '1';
						
					when seventh =>	
						n.t_7 <= data;	comp_rd <= '1';	dst_7 <= '1';
					
					when eighth =>		
						n.t_0 <= data;	comp_rd <= '1';	dst_0 <= '1';
						
					when others =>		
						comp_rd <= '1';
				end case;
			else
				comp_rd <= '0';
				if dst_1 = '1' and dst_2 = '1' and dst_3 = '1' and dst_4 = '1' and dst_5 = '1' and dst_6 = '1' and dst_7 = '1' then
					full <= '1';
					dst_1 <= '0';	dst_2 <= '0';	dst_3 <= '0';	dst_4 <= '0';	dst_5 <= '0';	dst_6 <= '0';	dst_7 <= '0';
				end if;
			end if;
		end if;
				
	end process;

end count_time;



