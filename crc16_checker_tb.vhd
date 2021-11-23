
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity crc16_checker_tb is
--  Port ( );
end crc16_checker_tb;

architecture Behavioral of crc16_checker_tb is

component crc16_checker is
port ( data : in std_logic_vector (7 downto 0);
        crc16 : in std_logic_vector (15 downto 0);
        rst : in std_logic;
        clk : in std_logic;
        crc16_en : in std_logic;
        check : out std_logic);
end component;

signal data_in : std_logic_vector (7 downto 0);
signal crc16_in,crc_val : std_logic_vector (15 downto 0);
signal rst,clk,crc16_en,check : std_logic;

begin

dut : crc16_checker port map(data => data_in, crc16 => crc16_in, rst => rst, clk => clk, crc16_en => crc16_en, check => check);
 

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

input : process
begin
    wait for 2ns;
    data_in <= "01100000";
    crc16_in <= "1111111001000010";
    crc16_en <= '1';
    wait;
end process input;

end Behavioral;
