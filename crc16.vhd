

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- This block generates the CRC16 value for data field of data packet in USB

entity crc16 is
port (  input_data : in std_logic_vector (7 downto 0);
        crc16_output : out std_logic_vector (15 downto 0);
        clk : in std_logic;
        rst : in std_logic);
end crc16;

architecture Behavioral of crc16 is

signal new_reminder,prev_reminder : std_logic_vector (15 downto 0);

begin

    crc_calculation : process (clk,rst,input_data) is
    variable index : integer;
    variable xor_comp : std_logic;
    variable xor_comp_16 : std_logic_vector (15 downto 0);
    begin
    
        if(rst = '1') then
            new_reminder <= "1111111111111111";
            prev_reminder <= "1111111111111111";
            index := 7;
        else
            if(index >= 0) then
            
                new_reminder(15) <= prev_reminder(14) xor (input_data(index) xor prev_reminder(15));
                new_reminder(14) <= prev_reminder(13);
                new_reminder(13) <= prev_reminder(12);
                new_reminder(12) <= prev_reminder(11);
                new_reminder(11) <= prev_reminder(10);
                new_reminder(10) <= prev_reminder(9);
                new_reminder(9) <= prev_reminder(8);
                new_reminder(8) <= prev_reminder(7);
                new_reminder(7) <= prev_reminder(6);
                new_reminder(6) <= prev_reminder(5);
                new_reminder(5) <= prev_reminder(4);
                new_reminder(4) <= prev_reminder(3);
                new_reminder(3) <= prev_reminder(2);
                new_reminder(2) <= prev_reminder(1) xor (input_data(index) xor prev_reminder(15));
                new_reminder(1) <= prev_reminder(0);
                new_reminder(0) <= (input_data(index) xor prev_reminder(15));
                
            end if;
            
        end if;
        
        if(clk'event and clk = '1') then
            crc16_output <= new_reminder;
            prev_reminder <= new_reminder;
            index := index-1;
        end if;
    end process crc_calculation;

end Behavioral;
