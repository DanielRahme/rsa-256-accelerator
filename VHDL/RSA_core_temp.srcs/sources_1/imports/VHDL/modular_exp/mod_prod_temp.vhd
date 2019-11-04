----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 19:18:16
-- Design Name: 
-- Module Name: mod_prod_temp - Behavioral
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

entity mod_prod_temp is
    Port ( A,B,n : in STD_LOGIC_VECTOR (255 downto 0);
           mod_prod : out STD_LOGIC_VECTOR (255 downto 0);
           clk, reset_n : in STD_LOGIC);
end mod_prod_temp;

architecture Behavioral of mod_prod_temp is

begin


end Behavioral;
