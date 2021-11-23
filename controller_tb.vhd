----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2021 15:36:01
-- Design Name: 
-- Module Name: controller_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_tb is

end controller_tb;

architecture Behavioral of controller_tb is

component controller is
port (  clk : in std_logic;
        rst : in std_logic;
        byte_sent_rcv : in std_logic;
        byte_register_rcv : in std_logic_vector (7 downto 0);
        start_rcv : in std_logic;
        eop_rcv : in std_logic;
        field_byte_sent_tsm : in std_logic;
        field_select_tsm : inout std_logic_vector(2 downto 0); 
        transmit_select_tsm : out std_logic_vector(1 downto 0);
        transmitter_enable_tsm : inout std_logic;
        check : inout std_logic_vector (1 downto 0);
        receive_en_rcv : inout std_logic);
end component;

signal clk, byte_sent,start,rcv_en,rst: std_logic;
signal byte_register,pid : std_logic_vector(7 downto 0);
signal field_byte_sent_tsm,crc5_en : std_logic;
signal field_select_tsm : std_logic_vector(2 downto 0); 
signal transmit_select_tsm : std_logic_vector(1 downto 0);
signal transmitter_enable_tsm : std_logic;
signal check : std_logic_vector(1 downto 0);
signal crc_5 : std_logic_vector (4 downto 0);
signal count : integer;
signal data_crc5 : std_logic_vector (10 downto 0);
signal check_16 : std_logic;
signal crc16_en : std_logic;
signal crc_16 : std_logic_vector(15 downto 0);
signal eop_rcv : std_logic;
begin

dut : controller port map(  clk => clk, 
                            byte_sent_rcv => byte_sent, 
                            byte_register_rcv => byte_register, 
                            start_rcv => start, 
                            receive_en_rcv => rcv_en,
                            transmitter_enable_tsm => transmitter_enable_tsm,
                            transmit_select_tsm => transmit_select_tsm,
                            field_select_tsm => field_select_tsm,
                            field_byte_sent_tsm => field_byte_sent_tsm,
                            check => check,
                            eop_rcv => eop_rcv,
                            rst => rst);

    clock : process 
    begin
    clk <= '0';
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
    end process;
    
    reset : process
    begin
    rst <= '1';
    wait for 2ns;
    rst <= '0';
    wait;
    end process reset;

    input_signals : process
    begin
    start <= '0';
    field_byte_sent_tsm <= '0';
    byte_sent <= '0';    
    wait for 5122ns;
    start <= '1';
    wait for 641ns;
    start <= '0';
    wait for 5120ns;
    
    byte_sent <= '1';
    byte_register <= "10010110"; -- pid 87
    wait for 641ns;
    byte_sent <= '0';
    wait for 5120ns;
    
    byte_sent <= '1';
    byte_register <= "11111111"; -- addr ff
    wait for 641ns;
    byte_sent <= '0';
    wait for 5120ns;
    
    byte_sent <= '1';
    byte_register <= "11110111"; -- endp f7
    wait for 641ns;
    byte_sent <= '0';
    wait for 1280ns;
    eop_rcv <= '1';
    wait for 640ns;
    eop_rcv <= '0';
    
    
    
      
    wait for 5120ns;
    field_byte_sent_tsm <= '1';
    wait for 640ns;
    field_byte_sent_tsm <= '0';
    wait for 5120ns;
    field_byte_sent_tsm <= '1';
    wait for 640ns;
    field_byte_sent_tsm <= '0';
    wait for 5120ns;
    field_byte_sent_tsm <= '1';
    wait for 640ns;
    field_byte_sent_tsm <= '0';
    wait for 5120ns;
    field_byte_sent_tsm <= '1';
    wait for 640ns;
    field_byte_sent_tsm <= '0';
    wait for 5120ns;
    field_byte_sent_tsm <= '1';
    wait for 640ns;
    field_byte_sent_tsm <= '0';
    wait for 5120ns;
    
    end process input_signals;
end Behavioral;
