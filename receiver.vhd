

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity receiver is
port (  clk : in std_logic;                                         -- This is the system clock - 50Mhz
        reset : in std_logic;                                       -- This reset signal
        D_pos_input : in std_logic;                                 -- This is D+ input signal 
        D_neg_input : in std_logic;                                 -- This is D- input signal
        receiver_enable : in std_logic;                             -- This signal which comes from the controller enables the receiver upon the start of packet
        eop : out std_logic;                                        -- This tells the controller that it reached the end of the packet
        data_clock : out std_logic;                                 -- This is the clock for the data transfer which is 50/32 = 1.5Mhz
        byte_register : inout std_logic_vector (7 downto 0);        -- This register is used to send the received data to controller 
        byte_sent : out std_logic;                                  -- This signal is used to tell the controller that the byte is sent
        start : out std_logic);                                     -- This tells the controller that start of a packet is received
                
end receiver;

architecture Behavioral of receiver is

component start_of_packet_detector
port (  D_pos_input : in std_logic;
        D_neg_input : in std_logic;
        reset : in std_logic;
        clock : in std_logic;
        outp : out std_logic);
end component;

component pll is
port (  system_clock : in std_logic;
        data_clock : out std_logic;
        d_in : in std_logic;
        rst : in std_logic);        
end component;


component eop_detector is
port(   D_pos_input : in std_logic;
        D_neg_input : in std_logic;
        reset : in std_logic;
        clock : in std_logic;
        outp : out std_logic);
end component;

signal input : std_logic ; 
signal data_receiver_clock : std_logic;
signal count_ones : integer;
signal count_bits_in_byte : integer;
signal prev_nrzi_data : std_logic;

begin
data_clock <= data_receiver_clock;
sop_1 : start_of_packet_detector port map (D_pos_input => D_pos_input, D_neg_input => D_neg_input, reset => reset, clock => data_receiver_clock, outp => start);
pll_1 : pll port map (system_clock => clk, data_clock => data_receiver_clock, d_in =>D_pos_input , rst => reset );
eop_1 : eop_detector port map(D_pos_input => D_pos_input, D_neg_input => D_neg_input,reset => reset, clock => data_receiver_clock, outp => eop);

--- On getting the SOP , the controller informs the receiver to start receiving through receive_enable.
--- We have to decode the NRZI data and get into binary form
--- We have to do bit-unstuffing
    
    receiving_data : process (data_receiver_clock, reset, input,receiver_enable)
    
    begin
        if(reset = '1' or receiver_enable = '0') then
            prev_nrzi_data <= '1';
            count_ones <= 0;
            count_bits_in_byte <= 0;
            byte_register <= "00000000";
            byte_sent <= '0';
        elsif( rising_edge(data_receiver_clock) and receiver_enable = '1') then
            case D_pos_input is 
                when '0' => 
                    case D_neg_input is
                    when '0' =>
                        
                    when '1' =>
                        input <= '0';
                        if(prev_nrzi_data = '0') then
                            byte_register <= byte_register(6 downto 0) & '1';
                            count_bits_in_byte <= (count_bits_in_byte + 1) mod 8;
                            count_ones <= count_ones+1;
                        else
                            if(count_ones = 6) then
                                count_ones <= 0;
                            else
                                byte_register <= byte_register(6 downto 0) & '0';
                                count_bits_in_byte <= (count_bits_in_byte + 1) mod 8;
                                count_ones <= 0;
                            end if;
                        end if;
                        prev_nrzi_data <= '0';
                    when others =>  
                    
                    end case;
                when '1' =>
                    case D_neg_input is
                    when '0' =>
                        input <= '1';
                        if(prev_nrzi_data = '1') then
                            byte_register <= byte_register(6 downto 0) & '1';
                            count_bits_in_byte <= (count_bits_in_byte + 1) mod 8;
                            count_ones <= count_ones+1;
                        else
                            if(count_ones = 6) then
                                count_ones <= 0;
                            else
                                byte_register <= byte_register(6 downto 0) & '0';
                                count_bits_in_byte <= (count_bits_in_byte + 1) mod 8;
                                count_ones <= 0;
                            end if;
                        end if;
                        prev_nrzi_data <= '1';
                    when '1' =>
                    when others =>    
                    end case;
                when others =>  
            end case;
            if(count_bits_in_byte = 7) then
                byte_sent <= '1';
            else
                byte_sent <= '0';
            end if;
            
        end if;
        
    end process receiving_data;



end Behavioral;
