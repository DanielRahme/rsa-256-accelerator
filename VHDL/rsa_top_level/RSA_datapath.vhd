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
    signal data_out_valid : std_logic;
    signal init : std_logic;

begin
    u_mod_exp_datapath : entity work.mod_exp_datapath port map (
        M => msgin_data,
        e => key_e_d,
        n => key_n,
        clk => clk,
        reset_n => reset_n,
        data_out_valid => data_out_valid,
        init => init,
        C => msgout_data
    );


end Behavioral;
