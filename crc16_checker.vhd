
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity crc16_checker is
port ( data : in std_logic_vector (7 downto 0);
        crc16 : in std_logic_vector (15 downto 0);
        rst : in std_logic;
        clk : in std_logic;
        crc16_en : in std_logic;
        check : out std_logic_vector(1 downto 0));
end crc16_checker;

architecture Behavioral of crc16_checker is

signal index : integer;
signal new_reminder, prev_reminder : std_logic_vector (15 downto 0);


begin


checker : process (clk,rst,data,crc16) 
 
    variable crc16_calc : std_logic_vector(15 downto 0);
    begin
        if(rst = '1' or crc16_en = '0') then 
            index <= 7;
            prev_reminder <= "1111111111111111";
            new_reminder <= "1111111111111111";
            check <= "00";
        else
            if(index >= 0 and crc16_en = '1') then
                new_reminder(15) <= prev_reminder(14) xor (data(index) xor prev_reminder(15));
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
                new_reminder(2) <= prev_reminder(1) xor (data(index) xor prev_reminder(15));
                new_reminder(1) <= prev_reminder(0);
                new_reminder(0) <= (data(index) xor prev_reminder(15));
                
            end if;
        end if;
        
        if(rising_edge(clk) and crc16_en = '1') then
            crc16_calc := new_reminder;
            prev_reminder <= new_reminder;
            index <= index-1;
        end if;
        
        if(index = -1 and crc16_en = '1') then
            if(crc16 = crc16_calc) then
                check <= "01";
             else
                check <= "11";
            end if;
        end if;
        
        if(crc16_en = '0') then
            check <= "00";
        end if;
        
    end process checker;

end Behavioral;
