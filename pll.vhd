

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pll is
port (  system_clock : in std_logic;
        data_clock : out std_logic;
        d_in : in std_logic;
        rst : in std_logic);        
end pll;

-- We want 50Mhz/32 = 1.5625Mhz clock.

architecture Behavioral of pll is
signal count : integer;
signal prev_in : std_logic;
begin
    pll : process (system_clock,d_in,rst) is
    begin
        if(rst = '1') then
            count <= 0;
            prev_in <= '0';
        elsif(system_clock'event and system_clock = '1') then
            if( (prev_in xor d_in) = '1' ) then
                if(count >= 30) then count <= 1;
                end if;
            else
                count <= count+1;
                if(count > 30) then count <= 0;
                end if;
            end if;
            prev_in <= d_in;
            if(count >= 15) then data_clock <= '1';
            else data_clock <= '0';
            end if;
        end if;
        
    end process pll;
    
end Behavioral;
