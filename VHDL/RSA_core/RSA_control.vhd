----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2019 19:33:14
-- Design Name: 
-- Module Name: RSA_control - Behavioral
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

entity RSA_control is
    Port (
           --clock and reset
           clk :  in std_logic;
           reset_n : in std_logic;
           --control for interface
           msgin_valid : in STD_LOGIC;
           msgin_ready : out STD_LOGIC;
           msgin_last : in STD_LOGIC;
           msgout_valid : out STD_LOGIC;
           msgout_ready : in STD_LOGIC;
           msgout_last : out STD_LOGIC;
           rsa_status : out STD_LOGIC_VECTOR (31 downto 0);
           --control for datapath
           input_valid : out std_logic;
           input_ready : in std_logic;
           output_valid: in std_logic;
           output_ready: out std_logic;
           initial_start: out std_logic;
           e_idx_cntr : out std_logic_vector(7 downto 0)
           );
           
           
end RSA_control;

architecture Behavioral of RSA_control is

begin


end Behavioral;
