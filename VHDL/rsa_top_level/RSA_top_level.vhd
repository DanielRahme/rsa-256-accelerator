----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 19:46:54
-- Design Name: 
-- Module Name: RSA_top_level - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RSA_top_level is
    Port ( 
           clk          : in Std_logic;
           reset_n      : in Std_logic;
           msgin_valid  : in std_logic;
           msgin_last   : in Std_logic;
           msgout_ready : in std_logic;
           msgin_data   : in std_logic_vector (255 downto 0);
           key_n        : in std_logic_vector (255 downto 0);
           key_e_d      : in std_logic_vector (255 downto 0);
           msgin_ready  : out std_logic;
           msgout_valid : out std_logic;
           msgout_last  : out std_logic;
           rsa_status   : out std_logic_vector (31 downto 0);
           msgout_data  : out std_logic_vector (255 downto 0)
        );
end RSA_top_level;

architecture Behavioral of RSA_top_level is
    -- Internal signals
    signal rsa_enable_n : std_logic;

begin
    u_rsa_datapath : entity work.RSA_datapath port map (
        -- Clock and reset
        clk         => clk,
        reset_n     => reset_n,

        -- Data busses
        msgin_data      => msgin_data,
        msgout_data     => msgout_data,
        key_n           => key_n,
        key_e_d         => key_e_d,

        -- Control signals into datapath
        rsa_enable_n    => rsa_enable_n
    );


    u_rsa_controller : entity work.RSA_controller port map (
        -- Clock and reset
        clk         => clk,
        reset_n     => reset_n,

        -- Signals for input interface
        msgin_valid => msgin_valid,
        msgin_last => msgin_last,
        msgin_ready => msgin_ready,
        
        -- Signals for output interface
        msgout_valid => msgout_valid,
        msgout_ready => msgout_ready,
        msgout_last => msgout_last,
        rsa_status => rsa_status,
        
        -- Control signals into datapath
        rsa_enable_n    => rsa_enable_n

    );

end Behavioral;
