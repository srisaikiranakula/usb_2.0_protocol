

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity controller is
port (  clk : in std_logic;                                     -- system clock 50Mhz
        rst : in std_logic;                                     -- system reset
        byte_sent_rcv : in std_logic;                           -- receiver will send this signal to tell the controller that byte register has been updated
        byte_register_rcv : in std_logic_vector (7 downto 0);   -- receiver will send this signal to give the controller, the byte register which contains field data
        start_rcv : in std_logic;                               -- receiver will send this signal to tell the controller that start of packet has been received and controller will enable the receiver
        eop_rcv : in std_logic;                                 -- receiver will send this signal to tell the controller that end of packet has been received and controller will disable the receiver
        field_byte_sent_tsm : in std_logic;                     -- transmitter will send this signal to update field_select_tsm after completion of each field
        field_select_tsm : out std_logic_vector(2 downto 0);    -- This selects the fields of packet to be sent in an order
        transmit_select_tsm : out std_logic_vector(1 downto 0); -- This selects whethet the transmitter has to send data/handshake packet
        transmitter_enable_tsm : inout std_logic;               -- transmitter enable signal
        receive_en_rcv : inout std_logic);                      -- receiver enable signal
end controller;

architecture Behavioral of controller is

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


component sample_controller is
port (  
        rst : in std_logic;
        start : in std_logic;
        eop : in std_logic;
        transmitter_enable : in std_logic;
        receiver_enable : out std_logic);
end component;

component crc5_checker is
port (  data : in std_logic_vector (10 downto 0);
        crc5 : in std_logic_vector (4 downto 0);
        rst : in std_logic;
        clk : in std_logic;
        crc5_en : in std_logic;
        check : out std_logic_vector(1 downto 0));
end component;

component crc16_checker is
port ( data : in std_logic_vector (7 downto 0);
        crc16 : in std_logic_vector (15 downto 0);
        rst : in std_logic;
        clk : in std_logic;
        crc16_en : in std_logic;
        check : out std_logic_vector(1 downto 0));
end component;

type receiver_state_type is (   idle_state,
                                pid_state,
                                token_addr_state,
                                token_endp_crc5_state,
                                crc5_checking_state,
                                data_data_state, 
                                data_crc16_1_state,
                                data_crc16_2_state,
                                crc16_checking_state);
signal rcv_state : receiver_state_type;

type transmit_state_type is (   tsm_idle_state,
                                transmit_data_sop_state,
                                transmit_data_pid_state,
                                transmit_data_data_state,
                                transmit_data_crc1_state,
                                transmit_data_crc2_state,
                                transmit_data_disable_state,
                                transmit_hs_sop_state,
                                transmit_hs_pid_state,
                                transmit_nak_sop_state,
                                transmit_nak_pid_state,
                                transmit_eop_state);
signal tsm_state,next_tsm_state : transmit_state_type;

-- The below signals are for storing the incoming data from the receiver
signal pid : std_logic_vector ( 7 downto 0);
signal addr : std_logic_vector (6 downto 0);
signal endp : std_logic_vector (3 downto 0);
signal crc_5 : std_logic_vector (4 downto 0);
signal data : std_logic_vector (7 downto 0);
signal crc_16 : std_logic_vector(15 downto 0);

-- The below signals are crc5 component;
signal data_crc5 : std_logic_vector(10 downto 0); 
signal crc5_en : std_logic;
signal check : std_logic_vector (1 downto 0);

-- The below signals are crc16 component;
signal data_crc16 : std_logic_vector(7 downto 0);
signal crc16_en : std_logic;
signal check_16 : std_logic_vector(1 downto 0); 

begin
    
    rcv_en_1 : sample_controller port map(rst => rst, start => start_rcv, receiver_enable => receive_en_rcv, eop => eop_rcv,transmitter_enable => transmitter_enable_tsm );
    crc5_1 : crc5_checker port map(data => data_crc5, crc5 => crc_5, rst => rst, clk => clk, crc5_en => crc5_en, check => check);
    crc16_1 : crc16_checker port map(data => data_crc16, crc16 => crc_16, rst => rst, clk => clk, crc16_en => crc16_en, check => check_16);
    
    receiving_data : process (rst,byte_sent_rcv,clk)
    begin
        if(rst = '1') then rcv_state <= idle_state; 
        elsif(rising_edge(byte_sent_rcv)) then
            case rcv_state is
                when idle_state =>  
                when pid_state =>
                    pid <= byte_register_rcv;
                when token_addr_state =>
                    
                    addr <= byte_register_rcv(7 downto 1);
                    endp(3) <= byte_register_rcv(0);
                    rcv_state <= token_endp_crc5_state;
                when token_endp_crc5_state =>
                    
                    endp <= endp(3) & byte_register_rcv(7 downto 5);
                    crc_5 <= reverse_any_vector(byte_register_rcv(4 downto 0));
                    rcv_state <= crc5_checking_state;
                when data_data_state =>
                    data <= byte_register_rcv;
                    rcv_state <= data_crc16_1_state;
                when data_crc16_1_state =>
                    crc_16(7 downto 0) <= reverse_any_vector(byte_register_rcv);
                    rcv_state <= data_crc16_2_state;
                when data_crc16_2_state =>
                    crc_16(15 downto 8) <= reverse_any_vector(byte_register_rcv);
                    rcv_state <= crc16_checking_state;
                when others =>           
            end case;
        end if;
        if(rcv_state = pid_state) then
                    case pid is
                        when "10010110" =>
                            rcv_state <= token_addr_state;
                        when "10000111" =>
                            rcv_state <= token_addr_state;
                        when "11000011" =>
                            rcv_state <= data_data_state;   
                        when "11010010" =>
                            rcv_state <= data_data_state;   
                        when others =>
                            
                    end case;
        end if;
        if(rcv_state = idle_state ) then
            if( rising_edge(clk)) then 
                
                if(receive_en_rcv = '1') then
                   rcv_state <= pid_state;
                end if;
            end if;
        end if;
        if(rcv_state = crc5_checking_state) then
            
            if( rising_edge(clk)) then 
                if(check = "01") then
                    rcv_state <= idle_state;
                    pid <= "00001111"; --- idle default
                elsif(check = "11") then
                    rcv_state <= idle_state;
                    pid <= "00001111"; --- idle default    
                end if;
            end if;
        end if;    
        if(rcv_state = crc16_checking_state ) then
            if( rising_edge(clk)) then 
                if(check_16 = "01") then
                    rcv_state <= idle_state;
                    pid <= "00001111"; --- idle default
                elsif(check_16 = "11") then
                    rcv_state <= idle_state;
                    pid <= "00001111"; --- idle default
                end if;
            end if;
        end if;
    end process receiving_data;
    
    crc_checking : process(rcv_state,clk,rst)
    begin
        if(rst = '1') then next_tsm_state <= tsm_idle_state; 
        elsif(rcv_state = crc5_checking_state and receive_en_rcv = '0' ) then
            if( rising_edge(clk)) then
                data_crc5 <= addr & endp;
                crc5_en <= '1';
                if(check = "01" and pid = "10010110" ) then
                    next_tsm_state <= transmit_data_sop_state;
                    crc5_en <= '0';
                elsif(check = "01" and pid = "10000111") then
                    crc5_en <= '0';
                elsif(check = "11") then
                    next_tsm_state <= transmit_nak_sop_state;
                    crc5_en <= '0';
                end if;
            end if;
        elsif(rcv_state = crc16_checking_state and receive_en_rcv = '0') then
            if( rising_edge(clk)) then
                data_crc16 <= data;
                crc16_en <= '1';
                if(check_16 = "01" and ( pid = "11000011" or pid = "11010010")) then
                    next_tsm_state <= transmit_hs_sop_state;
                    crc16_en <= '0';
                elsif(check_16 = "11" and ( pid = "11000011" or pid = "11010010")) then
                    next_tsm_state <= transmit_nak_sop_state;
                    crc16_en <= '0';
                end if;
            end if;
        else
            next_tsm_state <= tsm_idle_state;
        end if;
    end process crc_checking;       
    
    transmitting_data : process (rst,field_byte_sent_tsm,next_tsm_state)
    begin
        if(rst = '1') then 
            tsm_state <= tsm_idle_state;
            transmitter_enable_tsm <= '0';
        elsif( rising_edge(field_byte_sent_tsm)) then
            case tsm_state is
                when transmit_data_pid_state =>
                    field_select_tsm <= "001";
                    tsm_state <= transmit_data_data_state;
                when transmit_data_data_state =>
                    field_select_tsm <= "010";
                    tsm_state <= transmit_data_crc1_state;
                when transmit_data_crc1_state =>
                    field_select_tsm <= "011";
                    tsm_state <= transmit_data_crc2_state;
                when transmit_data_crc2_state =>
                    field_select_tsm <= "100";
                    tsm_state <= transmit_eop_state;
                when transmit_eop_state =>
                    field_select_tsm <= "101";
                    tsm_state <= transmit_data_disable_state;
                when transmit_data_disable_state => 
                    transmitter_enable_tsm <= '0';
                    tsm_state <= tsm_idle_state;
                when transmit_hs_pid_state =>
                    field_select_tsm <= "001";
                    tsm_state <= transmit_eop_state;
                when transmit_nak_pid_state =>
                    field_select_tsm <= "001";
                    tsm_state <= transmit_eop_state;
                when others =>
            end case;
        end if;
        if(next_tsm_state = transmit_data_sop_state and tsm_state = tsm_idle_state ) then
            tsm_state <= transmit_data_sop_state;
            field_select_tsm <= "000";
            transmitter_enable_tsm <= '1';
            transmit_select_tsm <= "11";
            tsm_state <= transmit_data_pid_state;
        end if;
        if(next_tsm_state = transmit_hs_sop_state and tsm_state = tsm_idle_state) then
            tsm_state <= transmit_hs_sop_state;
            field_select_tsm <= "000";
            transmitter_enable_tsm <= '1';
            transmit_select_tsm <= "01";
            tsm_state <= transmit_hs_pid_state;
        end if;
        if(next_tsm_state = transmit_nak_sop_state and tsm_state = tsm_idle_state) then
            tsm_state <= transmit_nak_sop_state;
            field_select_tsm <= "000";
            transmitter_enable_tsm <= '1';
            transmit_select_tsm <= "10";
            tsm_state <= transmit_nak_pid_state;
        end if;
    end process transmitting_data;
    
end Behavioral;
