----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2019 19:54:28
-- Design Name: 
-- Module Name: Right_to_left_tb - test_bench
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Right_to_left_tb is
end Right_to_left_tb;

architecture test_bench of Right_to_left_tb is
    constant CLK_PERIOD : time := 20 ns;
 
    --clock and reset
    signal clk_tb           : std_logic := '1';
    signal reset_n_tb       : std_logic := '0';
      
    -- Message_in interface
    signal msgin_valid_tb   : STD_LOGIC;
    signal msgin_ready_tb   : STD_LOGIC;
    signal msgin_last_tb    : STD_LOGIC;
    signal msgin_data_tb    : STD_LOGIC_VECTOR (255 downto 0);
        
    --key interface
    signal key_n_tb         : STD_LOGIC_VECTOR (255 downto 0);
    signal key_e_tb         : STD_LOGIC_VECTOR (255 downto 0);
    signal rsa_status_tb    : STD_LOGIC_VECTOR (31 downto 0);
           
    -- Message_out interface
    signal msgout_valid_tb  : STD_LOGIC;
    signal msgout_ready_tb  : STD_LOGIC;
    signal msgout_last_tb   : STD_LOGIC;
    signal msgout_data_tb   : STD_LOGIC_VECTOR (255 downto 0);
    
begin

uut_RSA_core : entity work.RSA_core
    port map(
    --clock and reset
    clk             => clk_tb,
    reset_n         => reset_n_tb,
         
    -- Message_in interface
    msgin_valid     => msgin_valid_tb,
    msgin_ready     => msgin_ready_tb,
    msgin_last      => msgin_last_tb,
    msgin_data      => msgin_data_tb,
           
   --key interface
   key_n            => key_n_tb,
   key_e            => key_e_tb,
   rsa_status       => rsa_status_tb, 
           
   -- Message_out interface
   msgout_valid     => msgout_valid_tb,
   msgout_ready     => msgout_ready_tb,
   msgout_last      => msgout_last_tb, 
   msgout_data      => msgout_data_tb
   );
   
   -- Clock generation
   clk_tb <= not clk_tb after CLK_PERIOD/2;

  -- reset = 1 for first clock cycle and then 0
  reset_n_tb <= '0', '1' after CLK_PERIOD/2;
  
    -- Stimuli generation
  stimuli_proc: process
  begin
  -- Send in first test vector
  -- 10 ^ 1 mod 69 = 10
  wait for 10*CLK_PERIOD;
  key_n_tb   <= std_logic_vector(to_unsigned(69, key_n_tb'length));
  key_e_tb   <= std_logic_vector(to_unsigned(1, key_e_tb'length));
  msgin_data_tb   <= std_logic_vector(to_unsigned(10, msgin_data_tb'length));
  wait for 1*CLK_PERIOD;
  msgin_valid_tb <= '1';
  msgout_ready_tb <= '1';
  
  end process;
end test_bench;
