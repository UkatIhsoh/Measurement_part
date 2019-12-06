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
			d_fin : in std_logic; --デコードが終わったかどうかみる
			d_type : in std_logic_vector(3 downto 0); --どのタイプのでーたが来るのかを確認
			rd_comp : out std_logic; --データの読み取りが終わったかどうか見る
			data : in std_logic_vector(63 downto 0); 
			output : out std_logic);
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

	signal data_en : std_logic:= '0'; 	--データがかわっているかのチェック
	signal preset : std_logic; --プリセットしているかどうかチェック
	signal dst_1 : std_logic; --データセットがどの程度進行しているか
	signal dst_2 : std_logic; 
	signal dst_3 : std_logic; 
	signal dst_4 : std_logic; 
	signal dst_5 : std_logic;
	signal dst_6 : std_logic; 
	signal dst_7 : std_logic; 
	signal dst_0 : std_logic; 
	signal full : std_logic; --データが満タン状態を知らせる
	signal comp_rd : std_logic; --rd_compに対応
	
	signal rf_out : std_logic:='0';	--RFパルス用
	signal dds_set : std_logic:='0'; --ddsの周波数を変える	
	signal ad_out : std_logic:='0'; --AD用


		
begin

	output <= out_sig;
	rd_comp <= comp_rd;
		
	process(clk,rst,cnt_start,data,d_fin)
	begin
	
		if rst = '1' then
			count_num <= (others => '0');
			data_en <= '0';
			out_sig <= '0';
			d_num <= "00";
			counter <= (others => '0');
		elsif clk' event and clk = '1' then
			if preset = '1' then
			
			end if;
		end if;
		
		if preset = '0' then
			if d_fin = '1' then
				case d_type is
					when first =>		p.t_1 <= data;	comp_rd <= '1';	dst_1 <= '1';
					
					when second =>		p.t_2 <= data;	comp_rd <= '1';	dst_2 <= '1';
						
					when third =>		p.t_3 <= data;	comp_rd <= '1';	dst_3 <= '1';
					
					when fourth =>		p.t_4 <= data;	comp_rd <= '1';	dst_4 <= '1';
						
					when fifth =>		p.t_5 <= data;	comp_rd <= '1';	dst_5 <= '1';
					
					when sixth =>		p.t_6 <= data;	comp_rd <= '1';	dst_6 <= '1';
						
					when seventh =>	p.t_7 <= data;	comp_rd <= '1';	dst_7 <= '1';
					
					when eighth =>		p.t_0 <= data;	comp_rd <= '1';	dst_0 <= '1';
						
					when others =>		comp_rd <= '1';
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
					when first =>		n.t_1 <= data;	comp_rd <= '1';	dst_1 <= '1';
					
					when second =>		n.t_2 <= data;	comp_rd <= '1';	dst_2 <= '1';
						
					when third =>		n.t_3 <= data;	comp_rd <= '1';	dst_3 <= '1';
					
					when fourth =>		n.t_4 <= data;	comp_rd <= '1';	dst_4 <= '1';
						
					when fifth =>		n.t_5 <= data;	comp_rd <= '1';	dst_5 <= '1';
					
					when sixth =>		n.t_6 <= data;	comp_rd <= '1';	dst_6 <= '1';
						
					when seventh =>	n.t_7 <= data;	comp_rd <= '1';	dst_7 <= '1';
					
					when eighth =>		n.t_0 <= data;	comp_rd <= '1';	dst_0 <= '1';
						
					when others =>		comp_rd <= '1';
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



