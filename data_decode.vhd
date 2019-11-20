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
	
	--識別用
	constant cnt : std_logic_vector(3 downto 0) :=X"0"; --カウンター

	type reg is record
		data : std_logic_vector(63 downto 0);
		d_en : std_logic; --decode_enable
		cnt_st : std_logic; --counter_start
		state : state_t;
	end record;

	signal p : reg;
	signal n : reg;

begin

	decode_en <= p.d_en;
	
	de_data <= p.data;
	
	cnt_en <= p.cnt_st;

	process(n,p,data64,fetch_fin,n.state)
		begin
			n <= p;
			
			if fetch_fin = '1' then
				n.d_en <= '0';
				if p.d_en = '1' then
					case data64(3 downto 0) is
						when cnt =>
							n.data(63 downto 60) <= X"0";
							n.data(59 downto 0) <= data64(63 downto 4);
							n.cnt_st <= '0';
							n.state <= count;
						
						when others =>
							n.data <= data64;
							n.state <= idle;
					end case;
				end if;
			end if;
			
			case p.state is
				when idle =>
					n.d_en <= '1';
					
				when count =>
					n.cnt_st <= '1';
					n.state <= idle;
					
				when others =>
					n.d_en <= '0';
					n.state <= idle;
				end case;
		
		end process;

	process(clk,rst)
		begin
			if rst = '1' then
				p.data <= (others => '0');
				p.state <= idle;
			elsif clk' event and clk = '1' then
				p <= n;
			end if;
		end process;

end decode;

