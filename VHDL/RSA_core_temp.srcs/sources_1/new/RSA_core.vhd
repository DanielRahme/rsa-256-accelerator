----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2019 19:21:43
-- Design Name: 
-- Module Name: RSA_core - Behavioral
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

entity RSA_core is
    Port (
           --clock and reset
           clk :  in std_logic;
           reset_n : in std_logic;
           
           -- Message_in interface
           msgin_valid : in STD_LOGIC;
           msgin_ready : out STD_LOGIC;
           msgin_last : in STD_LOGIC;
           msgin_data : in STD_LOGIC_VECTOR (255 downto 0);
           
           --key interface
           key_n : in STD_LOGIC_VECTOR (255 downto 0);
           key_e : in STD_LOGIC_VECTOR (255 downto 0);
           rsa_status : out STD_LOGIC_VECTOR (31 downto 0);
           
           -- Message_out interface
           msgout_valid : out STD_LOGIC;
           msgout_ready : in STD_LOGIC;
           msgout_last : out STD_LOGIC;
           msgout_data : out STD_LOGIC_VECTOR (255 downto 0));
end RSA_core;

architecture Behavioral of RSA_core is
        --signal between datapath and control
        signal input_valid: std_logic;
        signal input_ready: std_logic;
        signal output_ready: std_logic;
        signal output_valid: std_logic; 
        signal initial_start: std_logic; 
        signal e_idx_bit: std_logic;
        signal right_to_left_data_out_valid: std_logic;
begin

    u_RSA_datapath :  entity work.RSA_datapath(Behavioral) port map (
        
        --clock and reset
        clk        => clk,
        reset_n    => reset_n,
        
        --DATA
        msgin_data => msgin_data,
        key_e      => key_e,
        key_n      => key_n,
        msgout_data=> msgout_data,
        
        --Signals from control logic
        input_valid=> input_valid,
        input_ready     => input_ready,
        output_ready    => output_ready,
        output_valid    => output_valid,
        initial_start   => initial_start,
        e_idx_bit       => e_idx_bit,
        right_to_left_data_out_valid    => right_to_left_data_out_valid
    );    
        
    u_RSA_control : entity work.RSA_control(Behavioral) port map(
    
        --clock and reset
        clk        => clk,
        reset_n    => reset_n,
        
        --other useful signal for control
        key_e      => key_e,
        
        --control for interface
        msgin_valid     => msgin_valid,
        msgin_ready     => msgin_ready,
        msgin_last      => msgin_last,
        msgout_valid    => msgout_valid,
        msgout_ready    => msgout_ready,
        msgout_last     => msgout_last,
        rsa_status      => rsa_status,
        
        --control for datapath
        input_valid     => input_valid,
        input_ready     => input_ready,
        output_ready    => output_ready,
        output_valid    => output_valid,
        initial_start   => initial_start,
        e_idx_bit       => e_idx_bit,
        right_to_left_data_out_valid    => right_to_left_data_out_valid
        
        
     );
           
    

end Behavioral;
