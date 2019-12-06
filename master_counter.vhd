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
			d_fin : in std_logic; --�f�R�[�h���I��������ǂ����݂�
			d_type : in std_logic_vector(3 downto 0); --�ǂ̃^�C�v�̂Ł[��������̂����m�F
			rd_comp : out std_logic; --�f�[�^�̓ǂݎ�肪�I��������ǂ�������
			data : in std_logic_vector(63 downto 0); 
			output : out std_logic);
end master_counter;

architecture count_time of master_counter is

	type reg is record
		t_1 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_2 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_3 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_4 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_5 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_6 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_7 : std_logic_vector(63 downto 0);		--�J�E���g���
		t_0 : std_logic_vector(63 downto 0);		--�J�E���g���
	end record;	
	
	signal p : reg;
	signal n : reg;

	signal counter : std_logic_vector(63 downto 0):= (others => '0'); 		--�J�E���^�[

	signal data_en : std_logic:= '0'; 	--�f�[�^��������Ă��邩�̃`�F�b�N
	signal preset : std_logic; --�v���Z�b�g���Ă��邩�ǂ����`�F�b�N
	signal dst_1 : std_logic; --�f�[�^�Z�b�g���ǂ̒��x�i�s���Ă��邩
	signal dst_2 : std_logic; 
	signal dst_3 : std_logic; 
	signal dst_4 : std_logic; 
	signal dst_5 : std_logic;
	signal dst_6 : std_logic; 
	signal dst_7 : std_logic; 
	signal dst_0 : std_logic; 
	signal full : std_logic; --�f�[�^�����^����Ԃ�m�点��
	signal comp_rd : std_logic; --rd_comp�ɑΉ�
	
	signal rf_out : std_logic:='0';	--RF�p���X�p
	signal dds_set : std_logic:='0'; --dds�̎��g����ς���	
	signal ad_out : std_logic:='0'; --AD�p


		
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



