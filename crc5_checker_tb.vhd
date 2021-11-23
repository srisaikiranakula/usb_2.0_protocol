


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity crc5_checker_tb is
--  Port ( );
end crc5_checker_tb;

architecture Behavioral of crc5_checker_tb is

component crc5_checker is
port (  data : in std_logic_vector (10 downto 0);
        crc5 : in std_logic_vector (4 downto 0);
        rst : in std_logic;
        crc5_en : in std_logic;
        new_reminder : inout std_logic_vector (4 downto 0);
        prev_reminder : inout std_logic_vector (4 downto 0);
        clk : in std_logic;
        index : inout  integer;
        data_bit : inout std_logic;
        check : out std_logic_vector(1 downto 0));
end component;

signal data_in : std_logic_vector (10 downto 0);
signal crc5_in,new_reminder,prev_reminder : std_logic_vector (4 downto 0);
signal rst,clk,data_bit,crc5_en : std_logic;
signal check : std_logic_vector(1 downto 0);
signal index : integer;

begin

dut : crc5_checker port map(data => data_in,
                            crc5_en => crc5_en, 
                            crc5 => crc5_in, 
                            rst => rst, 
                            clk => clk, 
                            check => check,
                            new_reminder => new_reminder, 
                            index => index,
                            data_bit => data_bit,
                            prev_reminder => prev_reminder );

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
crc5_en <= '1';
wait;
end process reset;

input : process
begin
data_in <= "11111111111";
crc5_in <= "01100";
wait;
end process input;

end Behavioral;
