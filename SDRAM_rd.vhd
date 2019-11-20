----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:51 10/09/2019 
-- Design Name: 
-- Module Name:    SDRAM_rd - read_sec 
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
--component SDRAM_rd is
--	port(	clk : in std_logic;
--			rst : in std_logic;
--			
--			re_sw : in std_logic;
--			ctrl_data : out std_logic_vector(63 downto 0);
--
--			adr_in : in std_logic_vector(19 downto 0);
--			
--			sdr_req : out std_logic;
--			sdr_adr : out std_logic_vector(19 downto 0);
--			sdr_fin : in std_logic;
--			sdr_data : in std_logic_vector(63 downto 0));
--end component;

--read_sec : SDRAM_rd 
--	port map( clk => ,
--				 rst => ,
--			    re_sw => ,
--				 ctrl_data => ,
--				 adr_in => ,
--				 sdr_req => ,
--				 sdr_adr => ,
--				 sdr_fin => ,
--				 sdr_data => );



entity SDRAM_rd is
	port(	clk : in std_logic;
			rst : in std_logic;
			
			re_sw : in std_logic;
			ctrl_data : out std_logic_vector(63 downto 0);
			
			adr_in : in std_logic_vector(19 downto 0);
			
			sdr_req : out std_logic;
			sdr_adr : out std_logic_vector(19 downto 0);
			sdr_fin : in std_logic;
			sdr_data : in std_logic_vector(63 downto 0));
end SDRAM_rd;

architecture read_sec of SDRAM_rd is

	type state_t is (idle, sd_request, dt_aquire, cycle_end); --��Ԗ�(�A�C�h���ASDRAM���N�G�X�g�A�f�[�^�l���A1�T�C�N���I��)

	type reg is record
		data : std_logic_vector(63 downto 0); --�f�[�^
		adr : std_logic_vector(19 downto 0); --�A�h���X
		req : std_logic; --�ǂݍ��ݗv���M��
		pend : std_logic; --�ǂݍ��݉\�M��
		state : state_t; --��ԗp
		comp : std_logic; --�X�C�b�`��������邽�тɃA�h���X��Ԃ邱�Ƃ�����
	end record;
	
	signal p : reg; 
	signal n : reg;

begin

	sdr_req <= p.req;
	sdr_adr <= p.adr;
	ctrl_data <= p.data;

	process(n,p,adr_in,re_sw,sdr_fin,n.data,n.adr,n.state)
	begin
		n <= p;
		n.state <= p.state;
		
		if re_sw = '1' then --re_sw���������Ɠǂݍ��݊J�n
			if p.comp = '0' then --re_sw���������тɃA�h���X���؂�ւ��i�������ςȂ��ł̓A�h���X���ς��Ȃ��j
				n.pend <= '1';
				n.comp <= '1'; 
				if p.pend = '0' then
					n.adr <= adr_in; --�A�h���X�ύX
					n.state <= sd_request;
				end if;
			end if;
		else
			n.comp <= '0';
		end if;
		
		case p.state is
			when idle =>
				null;
				
			when sd_request =>
				n.req <= '1';
				n.state <= dt_aquire;
				
			when dt_aquire =>
				n.req <= '0';
				if sdr_fin = '1' then
					n.data <= sdr_data;
					n.state <= cycle_end;
				end if;
				
			when cycle_end =>
				n.pend <= '0';
				n.state <= idle;
				
			when others =>
				n.req <= '0';
				n.pend <= '0';
				n.state <= idle;
		end case;
	
	end process;

	--�N���b�N�ɓ������Ă��M����p�M���ɕς��
	process(clk,rst)
	begin
		if rst = '1' then
			p.data <= (others => '0');
			p.adr <= (others => '0');
			p.req <= '0';
			p.pend <= '0';
			p.state <= idle;
			p.comp <= '0';
		elsif clk' event and clk = '1' then
			p <= n;
		end if;
	end process;


end read_sec;

