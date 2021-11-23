
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity transmitter is
port(   input_data          : in std_logic_vector(7 downto 0);  -- data byte that we want to send
        clk                 : in std_logic;                     -- This is the system clock - 50Mhz
        data_clk            : in std_logic;                     -- This is the clock for the data transfer which is 50/32 = 1.5Mhz
        transmit_select     : in std_logic_vector(1 downto 0);  -- This signal coming from the controller selects whether it needs to send data/ack/nak
        rst                 : in std_logic;                     -- Reset signal
        transmitter_enable  : in std_logic;                     -- This signal coming from controller will enable the transmitter
        field_select        : in std_logic_vector(2 downto 0);  -- This vector comes from the controller selects the field to be sent next
        field_byte_sent     : out std_logic ;                   -- This signal tells the controller that byte has been sent
        data_out_pos        : out std_logic;                    -- This is the D+ output signal
        data_out_neg        : out std_logic);                   -- This is the D- output signal
end transmitter;

architecture Behavioral of transmitter is

component crc16 is
port (  input_data : in std_logic_vector (7 downto 0);
        crc16_output : out std_logic_vector (15 downto 0);
        clk : in std_logic;
        rst : in std_logic);
end component;

-- This functions helps to reverse a byte, making it LSB to MSB
function reverse_any_vector (a: in std_logic_vector)
return std_logic_vector is
  variable result: std_logic_vector(a'RANGE);
  alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
begin
  for i in aa'RANGE loop
    result(i) := aa(i);
  end loop;
  return result;
end; 

signal input_less_indian : std_logic_vector(7 downto 0);    -- This is to make it convenient for transmitter to send the data LSB to MSB
signal pid : std_logic_vector(7 downto 0);                  -- this signal is to store pid field (LSB to MSB)
signal data_0_or_1 : std_logic;                             -- this signal is toggle the data0 and data1 after each data transaction
signal crc_16 : std_logic_vector (15 downto 0);             -- CRC16 value of data
signal field_select_byte : std_logic_vector (7 downto 0);   -- field values for selected fields

-- We have to send sync,pid,data(optional),crc16(optional),eop.
-- When asked for data we send sync,pid,data,crc16,eop
-- When asked for handshake we send sync,pid(corresponding to ack or nak),eop

signal data_bit_for_encoding : std_logic;
signal data_bit_stuffed : std_logic;
signal prev_data_out_pos : std_logic;
begin

    input_less_indian <= reverse_any_vector(input_data);
    
    -- This process is to select the type of packet we need to send when commanded by the controller.
    pid_select : process (transmit_select,rst) is
    begin
        if (rst = '1') then
        pid <= "00001111"; -- default
        data_0_or_1 <= '0';
        else
            case transmit_select is 
            when "00" => pid <= "00001111";
            when "01" => pid <= "01001011";data_0_or_1 <= not(data_0_or_1); -- ack
            when "10" => pid <= "01011010"; -- nak
            when "11" => if(data_0_or_1 = '0')then pid <= "11000011"; data_0_or_1 <= '1';
                        else pid <= "11010010"; data_0_or_1 <= '0';
                        end if;
            when others => pid <= "00001111";
            end case;
        end if;
    end process pid_select;
    
    -- transmitter need to perform CRC16 on the input data and data stuffing.
    -- All CRCs are generated over their respective fields in the transmitter before bit-stuffing is performed. 
    -- The USB employs NRZI data encoding when transmitting packets.  
    --In NRZI encoding, a “1” is represented by no change in level and a “0” is represented by a change in level.
    
    -- 1. RAW DATA ---> CRC_16
    
    crc_1 : crc16 port map (input_data => input_less_indian, clk => clk, rst => rst, crc16_output => crc_16);
    
    
    -- RAW DATA ---> BIT-STUFFED DATA ---> NRZI ENCODED DATA
    
    
    bit_stuffing : process (data_clk,rst,transmitter_enable) is
        variable count_ones : integer ;
        variable count_bits_in_byte : integer;
        variable field_byte_copy : std_logic_vector (7 downto 0);
        
        begin
            if(rst = '1' or transmitter_enable = '0') then
                count_ones := 0;
                count_bits_in_byte := 0;
                field_byte_sent <= '0';
                data_out_pos <= '0';
                data_out_neg <= '1';
                prev_data_out_pos <= '0';
                data_bit_stuffed <= '1';
                
            else
                if(transmitter_enable = '1') then
                    if( rising_edge(data_clk)) then
                        if(count_bits_in_byte = 0) then
                            field_byte_copy := field_select_byte;
                        end if;
                        
                        if(count_ones = 6) then
                            data_bit_stuffed <= '0';
                            count_ones := 0;
                        else
                            data_bit_for_encoding <= field_byte_copy(7);
                            field_byte_copy := field_byte_copy (6 downto 0) & '1' ;
                            data_bit_stuffed <= data_bit_for_encoding;
                            count_bits_in_byte := count_bits_in_byte + 1;
                            if(data_bit_for_encoding = '1') then
                                count_ones := count_ones+1;
                            else count_ones := 0;
                            end if;
                        end if;
    
                        if(count_bits_in_byte = 8) then
                            field_byte_sent <= '1';
                            count_bits_in_byte := 0;
                        else 
                            field_byte_sent <= '0';
                        end if;
                        if(data_bit_stuffed = '0') then 
                            prev_data_out_pos <= not(prev_data_out_pos) ; 
                            data_out_pos <= not(prev_data_out_pos) ;
                            data_out_neg <= (prev_data_out_pos);
                        elsif(data_bit_stuffed = '1') then
                            data_out_pos <= prev_data_out_pos;
                            data_out_neg <= not(prev_data_out_pos);
                        elsif(data_bit_stuffed = 'X') then
                            prev_data_out_pos <= '0';
                            data_out_pos <= '0';
                            data_out_neg <= '0';
                        end if;
                    end if;
                end if;
            end if;
     end process bit_stuffing;
    
    
    -- The controller updates the field_sel signal to send the next field after the present field has been sent
    field_sel : process (field_select,clk,rst,pid,input_data,crc_16) is
    begin
        case field_select is
            when "000" => field_select_byte <= "00000001";
            when "001" => field_select_byte <= pid;
            when "010" => field_select_byte <= input_less_indian;
            when "011" => field_select_byte <= reverse_any_vector(crc_16(7 downto 0));
            when "100" => field_select_byte <= reverse_any_vector(crc_16(15 downto 8));
            when "101" => field_select_byte <= "XX111111"; -- eop
            when others => field_select_byte <= input_data;
        end case;
    end process field_sel;
    
end Behavioral;
