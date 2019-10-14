----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 20:02:14
-- Design Name: 
-- Module Name: RSA_datapath - Behavioral
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

entity RSA_datapath is
    Port ( 
           clk          : in std_logic;
           reset_n      : in std_logic;
           rsa_enable_n : in std_logic;
           msgin_data   : in std_logic_vector (255 downto 0);
           key_n        : in std_logic_vector (255 downto 0);
           key_e_d      : in std_logic_vector (255 downto 0);

           msgout_data  : out std_logic_vector (255 downto 0)
           );
end RSA_datapath;

architecture Behavioral of RSA_datapath is

begin


end Behavioral;
