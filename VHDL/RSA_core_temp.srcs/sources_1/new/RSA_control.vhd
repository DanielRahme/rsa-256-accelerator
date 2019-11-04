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
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

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
           e_idx_cntr : out std_logic_vector(7 downto 0);
           right_to_left_data_out_valid : out std_logic
           );
           
end RSA_control;

architecture Behavioral of RSA_control is

    signal e_idx_counter : std_logic_vector (7 downto 0);
    signal output_valid_buffer  : std_logic;

begin

--First modular operation
first_operation: process(reset_n, clk) begin
    if(reset_n = '0') then
        initial_start <= '0';  
    elsif( rising_edge(clk)) then
       if(msgin_valid = '1') then
            initial_start <= '1';
       else
            initial_start <= '0';
       end if;
    end if;
end process;

--e_index bit: continue to increment until 255 (later we will check if it finish earlier)
e_index_selection : process(clk, reset_n) begin
    if (reset_n = '0') then
        e_idx_counter <= (others => '0');
    elsif(rising_edge(clk)) then
        e_idx_counter <=  e_idx_counter + 1;
    end if;
end process;

e_idx_cntr <= e_idx_counter;
    
--output data when e_idx_cntr = 255, or when the exponent is done
output_manage : process(clk, reset_n) begin
    if(reset_n = '0') then
        output_valid_buffer <= '0';
    elsif rising_edge(clk) then
        if (e_idx_counter <= x"11") then
            output_valid_buffer <= '1';
        else
            output_valid_buffer <= '0';
        end if;
    end if;
end process;

--interface signals
msgout_valid <= msgout_ready and output_valid_buffer;
right_to_left_data_out_valid <= output_valid_buffer;
input_valid <= output_valid_buffer;
msgin_ready <= output_valid_buffer;
output_ready <= msgout_ready;

--still to implement
msgout_last  <= msgin_last;


end Behavioral;
