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
			
			cnt_en : out std_logic;
			
			de_data : out std_logic_vector(63 downto 0));
end data_decode;

architecture decode of data_decode is

	type state_t is (idle, count); --状態名（アイドル、カウンター）
	type state_s is (first, second, third); --パルスシーケンスに相当するようにデータを割り当てる
	
	--識別用
	constant cnt : std_logic_vector(3 downto 0) :=X"0"; --カウンター

	type reg is record
		data : std_logic_vector(63 downto 0);
		d_en : std_logic; --decode_enable
		cnt_st : std_logic; --counter_start
		state : state_t;
		sequence : state_s;
		d_num : std_logic_vector(1 downto 0);
	end record;

	signal p : reg;
	signal n : reg;

begin

	decode_en <= p.d_en;
	
	de_data <= p.data;
	
	cnt_en <= p.cnt_st;

	process(n,p,data64,fetch_fin)
		begin
			n <= p;
			
			if fetch_fin = '1' then
				if p.d_en = '0' then
					case p.sequence is
						when first =>
							if p.d_num = "00" then
								--n.data(15 downto 0) <= data64(19 downto 4);
								n.data(15 downto 0) <= data64(15 downto 0);
								n.d_num <= "01";
							elsif p.d_num = "01" then
								--n.data(31 downto 16) <= data64(35 downto 20);
								n.data(31 downto 16) <= data64(31 downto 16);
								n.d_num <= "10";
							elsif p.d_num = "10" then
								--n.data(47 downto 32) <= data64(51 downto 36);
								n.data(47 downto 32) <= data64(47 downto 32);
								n.d_num <= "11";
							elsif p.d_num = "11" then
								--n.data(63 downto 48) <= cnt & data64(63 downto 52);
								n.data(63 downto 48) <= data64(63 downto 48);
								--n.d_en <= '1';
								n.cnt_st <= '0';
								n.d_num <= "00";
								n.state <= count;
							end if;
						
						when others =>
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
								n.d_num <= "00";
								n.state <= idle;
							end if;
							
					end case;
				end if;
			end if;
			
			case p.state is
				when idle =>
					n.d_en <= '0';
					
				when count =>
					n.cnt_st <= '1';
					--n.d_en <= '0';
					n.d_en <= '1';
					n.state <= idle;
					
				when others =>
					n.state <= idle;
				end case;
		
		end process;

	process(clk,rst)
		begin
			if rst = '1' then
				p.data <= (others => '0');
				p.cnt_st <= '0';
				p.d_en <= '0';
				p.state <= idle;
				p.sequence <= first;
				p.d_num <= "00";
				--p.stop <= '0'; --test用
			elsif clk' event and clk = '1' then
				p <= n;
			end if;
		end process;

end decode;

