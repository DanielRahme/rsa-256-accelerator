----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 19:34:10
-- Design Name: 
-- Module Name: mod_prod_blakley - Behavioral
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

entity mod_prod_blakley is
    Port (
           reset_n      : in std_logic;
           clk          : in std_logic;
           A            : in std_logic_vector (255 downto 0);
           B            : in std_logic_vector (255 downto 0);
           n            : in std_logic_vector (255 downto 0);
           input_valid  : in std_logic;
           input_ready  : out std_logic;

           output_ready : in std_logic;
           output_valid : out std_logic;
           C            : out std_logic_vector (255 downto 0)
           );
end mod_prod_blakley;

architecture Behavioral of mod_prod_blakley is
    signal in_reg_enable : std_logic;
    signal out_reg_enable : std_logic;
    signal calc_enable : std_logic;
    signal B_bit_index          : std_logic_vector(7 downto 0);

begin

    -- Instatiate controller module
    u_blakley_controller: entity work.blakley_controller(impl) port map (
        reset_n => reset_n,
        clk => clk,
        input_valid => input_valid,
        input_ready => input_ready,
        output_ready => output_ready,
        output_valid => output_valid,

        -- Control singals to datapath
        in_reg_enable => in_reg_enable,
        out_reg_enable => out_reg_enable,
        calc_enable => calc_enable,
        B_bit_index => B_bit_index
    );



    -- Instatiate datapath module
    u_blakley_datapath: entity work.blakley_datapath port map (
        reset_n => reset_n,
        clk => clk,

        -- The data
        A => A,
        B => B,
        C => C,
        n => n,

        -- Control singals
        in_reg_enable => in_reg_enable,
        out_reg_enable => out_reg_enable,
        calc_enable => calc_enable,
        B_bit_index => B_bit_index
    );

end Behavioral;
