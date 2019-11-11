----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 19:48:43
-- Design Name: 
-- Module Name: mod_exp_controller - Behavioral
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

entity mod_exp_controller is
Port ( mod_exp_out_ready : in  STD_LOGIC;
       mod_exp_in_valid  : in  STD_LOGIC;
       mod_exp_in_ready  : out STD_LOGIC;
       mod_exp_out_valid : out STD_LOGIC;
       clk, reset_n      : in  STD_LOGIC);
end mod_exp_controller;

architecture Behavioral of mod_exp_controller is

begin


end Behavioral;
