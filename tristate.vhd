
-- This block selects which signal, the differential bus signals.
-- When device transmitter is HIGH, the bus signals are driven by transmitter of device
-- When device transmitter is LOW, the bus signals are driven the host input.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tristate is
port (  rst : in std_logic;                     -- system reset
        transmitter_enable : in std_logic;      -- transmitter enable signal
        data_pos_host : in std_logic;           -- D+ input host
        data_neg_host : in std_logic;           -- D- input host
        data_pos_tsm : in std_logic;            -- D+ output device
        data_neg_tsm : in std_logic;            -- D- output device
        data_bus_pos : out std_logic;           -- D+ bus
        data_bus_neg : out std_logic);          -- D- bus
end tristate;

architecture Behavioral of tristate is

begin

tri_state : process(rst, transmitter_enable,data_pos_host, data_neg_host , data_pos_tsm, data_neg_tsm)
begin
    if(rst = '1' or transmitter_enable = '0') then
        data_bus_pos <= data_pos_host;
        data_bus_neg <= data_neg_host;
    elsif(transmitter_enable = '1') then
        data_bus_pos <= data_pos_tsm;
        data_bus_neg <= data_neg_tsm;
    end if;
end process tri_state;

end Behavioral;
