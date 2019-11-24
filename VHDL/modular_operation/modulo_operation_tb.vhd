----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2019 18:50:57
-- Design Name: 
-- Module Name: modulo_operation_tb - Behavioral
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

entity modulo_operation_tb is

end modulo_operation_tb;

architecture Behavioral of modulo_operation_tb is
    signal clk : std_logic;
    signal reset_n : std_logic;
               
    --data input
    signal A_tb : STD_LOGIC_VECTOR (255 downto 0);
    signal modulus_tb : STD_LOGIC_VECTOR (255 downto 0);
               
    --data output
    signal result_tb : STD_LOGIC_VECTOR (255 downto 0);
               
    --I/O interface
    signal input_ready :  STD_LOGIC;
    signal input_valid :  STD_LOGIC;
    signal output_ready : STD_LOGIC;
    signal output_valid :  STD_LOGIC;
begin

uut_modulo_operation: entity work.modulo_operation(Behavioral)
    port map(
           --clk and reset
           clk      => clk,
           reset_n  => reset_n,
           
           --data input
           A        => A_tb,
           modulus  => modulus_tb,
           
           --data output
           result   => result_tb,
           
           --I/O interface
           input_ready  => input_ready,
           input_valid  => input_valid,
           output_ready => output_ready,
           output_valid => output_valid
    );
-- generate a clock
clock: process begin 
    clk <= '1'; wait for 25ns;
    clk <= '0'; wait for 25ns;
end process;

reset_n <= '1';
     A_tb       <= x"1059393059295030105939305929503010593930592950301059393059295030";
  modulus_tb    <= x"050003956719993211059393059295030105939305929503010593000000000";
--   wait for 1400ns;
    --A_tb <= std_logic_vector(to_unsigned(1000, A_tb'length));
    --modulus_tb <= std_logic_vector(to_unsigned(50000000, modulus_tb'length));
--handshake: process begin
   input_valid <= '1';
--    wait for 1000ns;
   output_ready <= '1';
end Behavioral;
