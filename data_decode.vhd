----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:39:39 10/21/2019 
-- Design Name: 
-- Module Name:    data_decode - Behavioral 
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


use IEEE.NUMERIC_STD.ALL;

library work;
use work.data_types.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--component data_decode is
--	port( clk : in std_logic;
--			rst : in std_logic;
--			
--			data64 : in std_logic_vector(63 downto 0);
--			fetch_fin : in std_logic;
--			decode_en : out std_logic;
--			
--			cnt_en : out std_logic;
--			
--			de_data : out std_logic_vector(63 downto 0));
--end component;
--
--decode : data_decode is
--	port map( clk => ,
--				 rst => ,
--			
--				 data64 => ,
--				 fetch_fin => ,
--				 decode_en => ,
--			
--				 cnt_en => ,
--			
--				 de_data => );


entity data_decode is
	port( clk : in std_logic;
			rst : in std_logic;
			
			data64 : in std_logic_vector(63 downto 0);
			fetch_fin : in std_logic;
			decode_en : out std_logic;
			decode_fin : out std_logic; --master_couterへデコードが終わったことを知らせる
			data_type : out std_logic_vector(3 downto 0); --master_counterへデータがどこのデータだか伝える
			read_fin : in std_logic; --master_counterがデータの読み込みを終了したことを知らせる
			decode_wait : in std_logic; --master_counterは現在データが満タンです
			
			data_out : out std_logic_vector(63 downto 0)); --change
end data_decode;

architecture decode of data_decode is

	type state_t is (idle, count); --状態名（アイドル、カウンター）

	type reg is record
		data : std_logic_vector(63 downto 0);
		d_type : std_logic_vector(3 downto 0); --data_type
		d_en : std_logic; --decode_enable
		d_fin : std_logic; --decode_fin
		state : state_t;
		sequence : std_logic_vector(3 downto 0);
		d_num : std_logic_vector(1 downto 0);
	end record;

	signal p : reg;
	signal n : reg;
	
	signal fresh : std_logic; --p.sequenceの値をfirstに最初はなるようにするためのもの

begin

	decode_en <= p.d_en;

	data_out <= p.data;
	decode_fin <= p.d_fin;
	data_type <= p.d_type;

	process(n,p,data64,fetch_fin,read_fin,decode_wait)
		begin
			n <= p;
			
			if fetch_fin = '1' then
				if decode_wait = '0' then
					if p.d_en = '0' then
						case p.sequence is
							when first =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= first;
									n.d_num <= "00";
									n.sequence <= second;
									n.state <= count;
								end if;
								
							when second =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= second;
									n.d_num <= "00";
									n.sequence <= third;
									n.state <= count;
								end if;
								
							when third =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= third;
									n.d_num <= "00";
									n.sequence <= fourth;
									n.state <= count;
								end if;
								
							when fourth =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= fourth;
									n.d_num <= "00";
									n.sequence <= fifth;
									n.state <= count;
								end if;
								
							when fifth =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= fifth;
									n.d_num <= "00";
									n.sequence <= sixth;
									n.state <= count;
								end if;
								
							when sixth =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= sixth;
									n.d_num <= "00";
									n.sequence <= seventh;
									n.state <= count;
								end if;
								
							when seventh =>
								if p.d_num = "00" then
									n.data(15 downto 0) <= data64(15 downto 0);
									n.d_num <= "01";
								elsif p.d_num = "01" then
									n.data(31 downto 16) <= data64(31 downto 16);
									n.d_num <= "10";
								elsif p.d_num = "10" then
									n.data(47 downto 32) <= data64(47 downto 32);
									n.d_num <= "11";
								elsif p.d_num = "11" then
									n.data(63 downto 48) <= data64(63 downto 48);
									n.d_type <= seventh;
									n.d_num <= "00";
									n.sequence <= first;
									n.state <= count;
								end if;
							
							when others =>
									n.sequence <= first;
									n.state <= idle;	
						end case;
					end if;
				end if;
			end if;
			
			case p.state is
				when idle =>
					n.d_en <= '0';
					
				when count =>
					if read_fin = '0' then
						n.d_fin <= '1';
					else
						n.d_fin <= '0';
						n.d_en <= '1';
						n.state <= idle;
					end if;
					
				when others =>
					n.state <= idle;
				end case;
		
		end process;

	process(clk,rst)
		begin
			if rst = '1' then
				p.data <= (others => '0');
				p.d_type <= (others => '0');
				p.d_en <= '0';
				p.d_fin <= '0';
				p.state <= idle;
				p.sequence <= first;
				p.d_num <= "00";
				fresh <= '0';
			elsif clk' event and clk = '1' then
				p <= n;
				if fresh = '0' then
					p.sequence <= first;
					fresh <= '1';
				end if;
			end if;
		end process;

end decode;

