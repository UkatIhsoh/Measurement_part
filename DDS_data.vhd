----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:53:49 12/20/2019 
-- Design Name: 
-- Module Name:    DDS_data - Behavioral 
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

library work;
use work.data_types.all;

--componwnt DDS_data is
--	port( clk : in std_logic;
--			rst : in std_logic;
--			msr_fin : in std_logic;
--			
--			d_fin : in std_logic; --�f�R�[�h���I��������ǂ����݂�
--			d_type : in std_logic_vector(3 downto 0); --�ǂ̃^�C�v�̂Ł[��������̂����m�F
--			rd_comp : out std_logic; --�f�[�^�̓ǂݎ�肪�I��������ǂ�������
--			data : in std_logic_vector(39 downto 0);
--			
--			wr_en_a : out std_logic; --fifo��WR_EN
--			full_a : in std_logic; --fifo��FULL
--			data_out : out std_logic_vector(39 downto 0);
--			data_end : out std_logic);
--end component;
--dds_DATA : DDS_data 
--	port map( clk => ,
--				 rst => ,
--			  	 msr_fin => ,
--			
--				 d_fin => ,
--				 d_type => ,
--				 rd_comp => ,
--				 data => ,
--			
--				 wr_en_a => ,
--				 full_a => ,
--				 data_out => ,
--				 data_end => );


entity DDS_data is
	port( clk : in std_logic;
			rst : in std_logic;
			msr_fin : in std_logic;
			
			d_fin : in std_logic; --�f�R�[�h���I��������ǂ����݂�
			d_type : in std_logic_vector(3 downto 0); --�ǂ̃^�C�v�̂Ł[��������̂����m�F
			rd_comp : out std_logic; --�f�[�^�̓ǂݎ�肪�I��������ǂ�������
			data : in std_logic_vector(39 downto 0);
			
			wr_en_a : out std_logic; --fifo��WR_EN
			full_a : in std_logic; --fifo��FULL
			data_out : out std_logic_vector(39 downto 0);
			data_end : out std_logic);
end DDS_data;

architecture data_read of DDS_data is

	signal counter : std_logic_vector(15 downto 0):= (others => '0');
	signal count_end : std_logic_vector(15 downto 0):= X"FFFF";
	
	signal d_end : std_logic:='0'; --data_end
	signal d_num : std_logic_vector(1 downto 0):= "00";  
	signal d_out : std_logic_vector(39 downto 0); --data_out
	
	signal tr_pend_a : std_logic:= '0'; --wr_en_a
	signal comp_rd : std_logic:= '0'; --rd_comp

begin

	rd_comp <= comp_rd;
	wr_en_a <= tr_pend_a;
	data_out <= d_out;
	data_end <= d_end;

	process(clk,rst,msr_fin,d_fin,full_a)
		begin
			if rst = '1' or msr_fin = '1' then
				counter <= (others => '0');
				count_end <= X"FFFF";
				d_end <= '0';
				d_num <= "00";
				d_out <= (others => '0');
				tr_pend_a <= '0';
				comp_rd <= '0';
			elsif clk' event and clk = '1' then
				if counter = X"0000" then
					if d_fin = '1' then 
						if comp_rd = '0' then
							count_end <= data(15 downto 0);
							comp_rd <= '1';
						end if;
					else
						counter <= counter +1;
						if comp_rd = '1' then
							comp_rd <= '0';
						end if;
					end if;
				elsif counter = count_end then
					d_end <= '1';
				else
					if d_fin = '1' then
						case d_type is
							when dds_A =>
								if d_num = "00" then
									d_out(19 downto 0) <= data(19 downto 0);
									d_num <= "01";
								elsif d_num = "01" then
									d_out(39 downto 20) <= data(39 downto 20);
									d_num <= "10";
								else
									if full_a = '0' then
										if tr_pend_a <= '0' then 
											tr_pend_a <= '1';
										else
											tr_pend_a <= '0';
										end if;
										if counter = count_end then
											d_end <= '1';
										else
											counter <= counter +1;
										end if;
										comp_rd <= '1';
										d_num <= "00";
									else
										tr_pend_a <= '0';
									end if;
								end if;
								
							when others =>
								comp_rd <= '1';
						end case;
					else
						comp_rd <= '0';
						tr_pend_a <= '0';
					end if;
				end if;
			end if;
		end process;


end data_read;

