----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 19:34:10
-- Design Name: 
-- Module Name: blakley_controller - Behavioral
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

entity blakley_controller is
    Port ( 
            reset_n : in STD_LOGIC;
            clk : in STD_LOGIC;
            input_valid : in STD_LOGIC;
            input_ready : out STD_LOGIC;
            output_ready : in STD_LOGIC;
            output_valid : out STD_LOGIC;
            in_reg_enable : out STD_LOGIC;
            calc_enable : out STD_LOGIC;
            out_reg_enable : out STD_LOGIC);
end blakley_controller;

architecture impl of blakley_controller is

begin


end impl;
