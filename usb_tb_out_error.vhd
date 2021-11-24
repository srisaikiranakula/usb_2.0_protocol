

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity usb_tb_out_error is
--  Port ( );
end usb_tb_out_error;

architecture Behavioral of usb_tb_out_error is
component usb is
port (  clk : in std_logic;                             -- system clock 50Mhz = 20ns 
        rst : in std_logic;                             -- system reset
        D_pos : in std_logic;                           -- D+ input signal host
        D_neg : in std_logic;                           -- D- input signal host
        input_tsm : in std_logic_vector(7 downto 0);    -- Input data to the transmitter so that when trasnmitter is enabled it will send this data
        data_clock_rcv : inout std_logic;               -- Data clock 50/32Mhz = 1.5625 Mhz = 640ns
        data_clock_tsm : in std_logic;
        data_bus_pos            : inout std_logic;        -- D+ output signal bus 
        data_bus_neg            : inout std_logic);       -- D+ output signal bus
end component;

signal clk,rst : std_logic;
signal input_tsm : std_logic_vector(7 downto 0);
signal data_clock_rcv : std_logic;
signal D_pos_input : std_logic;
signal D_neg_input : std_logic;
signal data_bus_pos : std_logic;
signal data_bus_neg : std_logic;
signal data_clock_tsm : std_logic;
begin

dut : usb port map( clk => clk,
                    rst => rst,
                    D_pos => D_pos_input,
                    D_neg => D_neg_input,
                    data_bus_pos => data_bus_pos,
                    data_bus_neg => data_bus_neg,
                    input_tsm => input_tsm,
                    data_clock_tsm => data_clock_tsm,
                    data_clock_rcv => data_clock_rcv);

    system_clock : process
    begin
        clk <= '0';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
    end process system_clock;

    data_clock : process
    begin
        data_clock_tsm <= '0';
        wait for 320ns;
        data_clock_tsm <= '1';
        wait for 320ns;
    end process data_clock;
    
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
        D_pos_input <= '0';
        D_neg_input <= '1';
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
