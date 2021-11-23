

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sample_controller is
port (
        rst : in std_logic;
        start : in std_logic;
        eop : in std_logic;
        transmitter_enable : in std_logic;
        receiver_enable : out std_logic);
end sample_controller;

architecture Behavioral of sample_controller is

begin

    enabling : process (rst,start,eop) is
    begin
        case rst is
            when '1' => receiver_enable <= '0';
            when others =>
                case transmitter_enable is
                    when '1' => receiver_enable <= '0';
                    when others => 
                        case start is 
                            when '1' => receiver_enable <= '1';
                            when others => 
                                case eop is 
                                    when '1' => receiver_enable <= '0';
                                    when others => 
                                end case;
                        end case;
                end case;
        end case;
        
    end process enabling;

    
    
end Behavioral;
