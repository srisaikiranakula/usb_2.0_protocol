----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2021 21:33:45
-- Design Name: 
-- Module Name: host - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dummy_host is
port (  D_pos : in std_logic;
        D_neg : in std_logic;
        data_pos : out std_logic;
        data_neg : out std_logic);
end dummy_host;

architecture Behavioral of dummy_host is

begin

    data_pos <= D_pos;
    data_neg <= D_neg;

end Behavioral;
