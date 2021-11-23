
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity receiver_tb is
--  Port ( );
end receiver_tb;

architecture Behavioral of receiver_tb is

component receiver is
port (  clk : in std_logic;
        reset : in std_logic;
        D_pos_input : in std_logic;
        D_neg_input : in std_logic;
        receiver_enable : in std_logic;
        eop : out std_logic;
        data_clock : out std_logic;
        byte_register : inout std_logic_vector (7 downto 0);
        byte_sent : out std_logic;
        start : inout std_logic);
end component;

signal clock, rst, inp, start,eop : std_logic;
signal outp : std_logic_vector (7 downto 0);
signal outp_copy : std_logic_vector (7 downto 0);
signal sent,data_clock,data,nrzi_data,prev_nrzi_data,rcv_en  : std_logic;
signal count,count_ones : integer;
signal D_pos_input : std_logic;
signal D_neg_input : std_logic;
begin

dut : receiver port map(clk => clock, 
                        reset => rst, 
                        D_pos_input => D_pos_input, 
                        D_neg_input => D_neg_input,
                        start => start,
                        byte_register => outp,
                        eop => eop,
                        byte_sent => sent,
                        receiver_enable => rcv_en,
                        data_clock => data_clock);

    clock_tb : process 
    begin 
    clock <= '0';
    wait for 10ns;
    clock <= '1';
    wait for 10ns;
    end process clock_tb;
    
    reset_tb : process
    begin
    rst <= '1';
    
    --receive_en <= '1';
    wait for 2ns;
    rst <= '0';
    wait;
    end process reset_tb;

    input_tb : process
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
        
        rcv_en <= '1';
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
        
        rcv_en <= '0';
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
        
        rcv_en <= '1';
        
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
        
        rcv_en <= '0';
    wait;
    end process input_tb;
    
    
end Behavioral;
