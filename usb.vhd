
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity usb is
port (  clk : in std_logic;                             -- system clock 50Mhz = 20ns 
        rst : in std_logic;                             -- system reset
        D_pos : in std_logic;                           -- D+ input signal host
        D_neg : in std_logic;                           -- D- input signal host
        input_tsm : in std_logic_vector(7 downto 0);    -- Input data to the transmitter so that when trasnmitter is enabled it will send this data
        data_clock_rcv : inout std_logic;               -- Data clock 50/32Mhz = 1.5625 Mhz = 640ns
        data_bus_pos            : inout std_logic;        -- D+ output signal bus 
        data_bus_neg            : inout std_logic);       -- D+ output signal bus
end usb;

architecture Behavioral of usb is

component receiver is
port (  clk : in std_logic;
        reset : in std_logic;
        D_pos_input : in std_logic;
        D_neg_input : in std_logic;
        eop : out std_logic;
        data_clock : out std_logic;
        byte_register : inout std_logic_vector (7 downto 0);
        byte_sent : out std_logic;
        receiver_enable : in std_logic;
        start : out std_logic);       
end component;

component controller is
port (  clk : in std_logic;
        rst : in std_logic;
        byte_sent_rcv : in std_logic;
        byte_register_rcv : in std_logic_vector (7 downto 0);
        start_rcv : in std_logic;
        eop_rcv : in std_logic;
        field_byte_sent_tsm : in std_logic;
        field_select_tsm : out std_logic_vector(2 downto 0); 
        transmit_select_tsm : out std_logic_vector(1 downto 0);
        transmitter_enable_tsm : inout std_logic;
        receive_en_rcv : inout std_logic);
end component;

component transmitter is
port(   input_data          : in std_logic_vector(7 downto 0);  -- data byte that we want to send
        clk                 : in std_logic;                     -- clock signal
        data_clk            : in std_logic;
        transmit_select     : inout std_logic_vector(1 downto 0);  -- This selects whether it needs to send data/ack/nak
        rst                 : in std_logic;                     -- Reset signal
        transmitter_enable  : in std_logic;                     -- controller will enable the transmitter
        field_select        : inout std_logic_vector(2 downto 0); 
        field_byte_sent     : inout std_logic ;  
        data_out_pos            : out std_logic;
        data_out_neg            : out std_logic);
end component;

component dummy_host is
port (  D_pos : in std_logic;
        D_neg : in std_logic;
        data_pos : out std_logic;
        data_neg : out std_logic);
end component;

component tristate is
port (  rst : in std_logic;
        transmitter_enable : in std_logic;
        data_pos_host : in std_logic;
        data_neg_host : in std_logic;
        data_pos_tsm : in std_logic;
        data_neg_tsm : in std_logic;
        data_bus_pos : out std_logic;
        data_bus_neg : out std_logic);
end component;

----These are the receiver signals
signal byte_sent_rcv : std_logic;
signal start_rcv : std_logic;
signal receiver_enable_rcv : std_logic;
signal byte_register_rcv : std_logic_vector(7 downto 0);
signal D_pos_rcv : std_logic;
signal D_neg_rcv : std_logic;

----These are the transmitter signals
signal field_byte_sent_tsm : std_logic;
signal eop : std_logic;
signal eop_rcv : std_logic;
signal transmitter_enable_tsm : std_logic;
signal field_select_tsm : std_logic_vector(2 downto 0); 
signal transmit_select_tsm : std_logic_vector(1 downto 0);
signal data_pos_tsm : std_logic;
signal data_neg_tsm : std_logic;

--- These are for host
signal data_pos : std_logic;
signal data_neg : std_logic;
begin


tri_state_1 : tristate port map(    rst => rst,
                                    transmitter_enable => transmitter_enable_tsm,
                                    data_pos_host => data_pos,
                                    data_neg_host => data_neg,
                                    data_pos_tsm => data_pos_tsm,
                                    data_neg_tsm => data_neg_tsm,
                                    data_bus_pos => data_bus_pos,
                                    data_bus_neg => data_bus_neg);

rcv_1 : receiver port map(  clk => clk, 
                            reset => rst, 
                            eop => eop_rcv,
                            D_pos_input => data_bus_pos,
                            D_neg_input => data_bus_neg,
                            data_clock => data_clock_rcv, 
                            byte_register => byte_register_rcv, 
                            byte_sent => byte_sent_rcv,
                            receiver_enable => receiver_enable_rcv,
                            start => start_rcv);

ctrl_1 : controller port map(   clk => clk,
                                rst => rst,
                                byte_sent_rcv => byte_sent_rcv,
                                byte_register_rcv => byte_register_rcv,
                                start_rcv => start_rcv,
                                eop_rcv => eop_rcv,
                                receive_en_rcv => receiver_enable_rcv,
                                --check_16 => check_16,
                                field_byte_sent_tsm => field_byte_sent_tsm,
                                field_select_tsm => field_select_tsm,
                                transmit_select_tsm => transmit_select_tsm,
                                transmitter_enable_tsm => transmitter_enable_tsm);

tsm_1 : transmitter port map(   input_data => input_tsm,
                                clk => clk,
                                data_clk => data_clock_rcv,
                                transmit_select => transmit_select_tsm,
                                rst => rst,
                                transmitter_enable => transmitter_enable_tsm,
                                field_select => field_select_tsm,
                                field_byte_sent => field_byte_sent_tsm,
                                data_out_pos => data_pos_tsm,
                                data_out_neg => data_neg_tsm);
                                
host_1 : dummy_host port map(   D_pos => D_pos,
                                D_neg => D_neg,
                                data_pos => data_pos,
                                data_neg => data_neg);
end Behavioral;
