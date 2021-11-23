
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity transmitter_tb is
end transmitter_tb;

architecture Behavioral of transmitter_tb is

component transmitter is
port(   input_data          : in std_logic_vector(7 downto 0);  -- data byte that we want to send
        clk                 : in std_logic;                     -- clock signal
        data_clk            : in std_logic;
        transmit_select     : in std_logic_vector(1 downto 0);  -- This selects whether it needs to send data/ack/nak
        rst                 : in std_logic;                     -- Reset signal
        data_bit_stuffed    : inout std_logic;
        transmitter_enable  : in std_logic;                     -- controller will enable the transmitter
        field_select        : in std_logic_vector(2 downto 0);   
        field_byte_sent     : out std_logic;                    
        data_out_pos            : out std_logic;
        data_out_neg            : out std_logic);
end component;

signal clock,reset,data_pos,data_neg,tran_en,byte_sent,data_clk : std_logic;
signal sel : std_logic_vector (1 downto 0);
signal in_data : std_logic_vector(7 downto 0);
signal field_sel : std_logic_vector(2 downto 0);
signal data_bit_stuffed : std_logic;
begin
dut : transmitter port map( clk => clock,
                            data_clk => data_clk, 
                            transmit_select => sel , 
                            rst => reset,  
                            data_bit_stuffed => data_bit_stuffed,
                            data_out_pos => data_pos, 
                            data_out_neg => data_neg,
                            input_data => in_data, 
                            transmitter_enable => tran_en, 
                            field_select =>field_sel,
                            field_byte_sent => byte_sent);

    clk_in : process 
    begin 
    clock <= '0';
    wait for 10ns;
    clock <= '1';
    wait for 10ns;
    end process clk_in;
    
    select_pid : process
    begin 
    
    sel <= "11";
    wait;
    end process select_pid;

    reset_tb : process 
    begin
    reset <= '1';
    tran_en <= '1';
    wait for 2ns;
    reset <= '0';
    wait;
    end process reset_tb;
    
    data_clock : process
    begin
    data_clk <= '0';
    wait for 320ns;
    data_clk <= '1';
    wait for 320ns;
    end process data_clock;
    
    field : process
    begin
    field_sel <= "000";
    wait for 5120ns;
    field_sel <= "001";
    wait for 5120ns;
    field_sel <= "010";
    wait for 5120ns;
    field_sel <= "011";
    wait for 5120ns;
    field_sel <= "100";
    wait for 5120ns;
    field_sel <= "101";
    wait for 5120ns;
    wait;
    end process field;
    
    inputdata : process
    begin
    in_data <= "11111100";
    wait;
    end process inputdata;
    
    
end Behavioral;
