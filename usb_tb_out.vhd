----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2021 18:25:03
-- Design Name: 
-- Module Name: usb_tb - Behavioral
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

entity usb_tb is
--  Port ( );
end usb_tb;

architecture Behavioral of usb_tb is

component usb is
port (  clk : in std_logic;
        rst : in std_logic;
        D_pos: in std_logic;
        D_neg : in std_logic;
        input_tsm : in std_logic_vector(7 downto 0);
        --start_rcv : inout std_logic;
        --receiver_enable_rcv : inout std_logic;
        --byte_sent_rcv : inout std_logic;
        --byte_register_rcv : inout std_logic_vector(7 downto 0);
        data_clock_rcv : inout std_logic;
        
        --check_16 : inout std_logic;
        --field_byte_sent_tsm : inout std_logic;
        --field_select_tsm : inout std_logic_vector(2 downto 0); 
        --transmit_select_tsm : inout std_logic_vector(1 downto 0);
        --transmitter_enable_tsm : inout std_logic; 
        data_bus_pos            : inout std_logic;
        data_bus_neg            : inout std_logic);
end component;

signal clk,rst : std_logic;
signal input_tsm : std_logic_vector(7 downto 0);
--signal field_byte_sent_tsm,transmitter_enable_tsm : std_logic;
--signal field_select_tsm : std_logic_vector(2 downto 0); 
--signal transmit_select_tsm : std_logic_vector(1 downto 0);
--signal start_rcv : std_logic;
--signal receiver_enable_rcv : std_logic;
--signal byte_register_rcv : std_logic_vector(7 downto 0);
--signal byte_sent_rcv : std_logic;
signal data_clock_rcv : std_logic;
--signal check_16 : std_logic;
signal D_pos_input : std_logic;
signal D_neg_input : std_logic;
--signal eop_tsm : std_logic;
signal data_bus_pos : std_logic;
signal data_bus_neg : std_logic;

begin

dut : usb port map( clk => clk,
                    rst => rst,
                    D_pos => D_pos_input,
                    D_neg => D_neg_input,
                    data_bus_pos => data_bus_pos,
                    data_bus_neg => data_bus_neg,
                    input_tsm => input_tsm,
                    --start_rcv => start_rcv,
                    --receiver_enable_rcv => receiver_enable_rcv,
                    --byte_sent_rcv => byte_sent_rcv,
                    --byte_register_rcv => byte_register_rcv,
                    --check_16 => check_16,
                    --field_byte_sent_tsm => field_byte_sent_tsm,
                    --field_select_tsm => field_select_tsm,
                    --transmit_select_tsm => transmit_select_tsm,
                    --transmitter_enable_tsm => transmitter_enable_tsm,
                    data_clock_rcv => data_clock_rcv);

    clock : process
    begin
        clk <= '0';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
    end process clock;

    reset : process
    begin
    rst <= '1';
    wait for 2ns;
    rst <= '0';
    wait;
    end process reset;
    
    tsm : process
    begin
    input_tsm <= "11111100"; 
    wait;
    end process tsm;
    
    rcv : process
    begin
        wait for 2ns;
        -- sop
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        
        -- pid  for out 87
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        
        
        -- addr randm ff
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        
        --endp f7
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        
        ---eop
        D_pos_input <= '0';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        
        
        ---sop 
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        
        --pid for data c3
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        
        -- data value 3f
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        
        --crc 01
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        
        --crc bf
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        D_pos_input <= '1';
        D_neg_input <= '0';
        wait for 640ns;
        
        
        --eop
        D_pos_input <= '0';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '0';
        wait for 640ns;
        D_pos_input <= '0';
        D_neg_input <= '1';
        wait for 640ns;
        wait;
    end process rcv;
end Behavioral;
