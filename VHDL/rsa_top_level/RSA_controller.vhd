----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 20:23:09
-- Design Name: 
-- Module Name: RSA_controller - Behavioral
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

entity RSA_controller is
    Port ( msgin_valid : in std_logic;
           msgin_last : in std_logic;
           msgout_ready : in std_logic;
           clk : in std_logic;
           reset_n : in std_logic;
           msgout_valid : out std_logic;
           msgin_ready : out std_logic;
           msgout_last : out std_logic;
           rsa_enable_n : out std_logic;
           rsa_status : out std_logic_vector (31 downto 0));
end RSA_controller;

architecture Behavioral of RSA_controller is

begin


end Behavioral;
