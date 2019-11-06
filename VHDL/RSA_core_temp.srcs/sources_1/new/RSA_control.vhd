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
           
           --other useful signal for control
           key_e   : in std_logic_vector(255 downto 0); 
           
           --control for interface
           msgin_valid   : in STD_LOGIC;
           msgin_ready   : out STD_LOGIC;
           msgin_last    : in STD_LOGIC;
           msgout_valid  : out STD_LOGIC;
           msgout_ready  : in STD_LOGIC;
           msgout_last   : out STD_LOGIC;
           rsa_status    : out STD_LOGIC_VECTOR (31 downto 0);
           --control for datapath
           input_valid   : out std_logic;
           input_ready   : in std_logic;
           output_valid  : in std_logic;
           output_ready  : out std_logic;
           initial_start : out std_logic;
           e_idx_bit    : out std_logic;
           right_to_left_data_out_valid : out std_logic
           );
           
end RSA_control;

architecture Behavioral of RSA_control is

    signal e_idx_counter        : std_logic_vector (7 downto 0);
    signal output_valid_buffer  : std_logic;
    signal key_e_shift_reg      : std_logic_vector(255 downto 0);
    signal key_e_shift_reg_nxt  : std_logic_vector(255 downto 0);
    signal end_flag_r           : std_logic;
    signal end_flag_nxt         : std_logic;
    signal zero_256bit          : std_logic_vector(255 downto 0) := (others => '0');
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

--Key_e shift register
key_e_shift_register : process(clk,reset_n) begin
    if(reset_n = '0') then
        key_e_shift_reg <= (others => '0');
    elsif(rising_edge(clk)) then
        key_e_shift_reg <= key_e_shift_reg_nxt;
        
    end if;
end process;

key_e_shifting_operation: process(key_e_shift_reg, e_idx_counter) begin
    if (e_idx_counter = x"00") then
        key_e_shift_reg_nxt <= key_e;
    else
        key_e_shift_reg_nxt <= '0' & key_e_shift_reg(255 downto 1);
    end if;
end process;

e_idx_bit <= key_e_shift_reg(0);
--e_index bit: continue to increment until key_e shift = 0 
--generate the end flag need to understand when the shifted exponent is equal to 0

-- condition for flag = shift exponent equal to zero or e_idx_count reach 255
end_flag_register: process (reset_n, clk) begin
    if (reset_n = '0') then
        end_flag_r <= '0';
    elsif (rising_edge(clk)) then
        end_flag_r <= end_flag_nxt;
    end if;
end process;

end_flag_generation: process (key_e_shift_reg, e_idx_counter)  begin
    if ((key_e_shift_reg(255 downto 0) and zero_256bit(255 downto 0)) = zero_256bit(255 downto 0)) then
        end_flag_nxt <= '1';
    else
        end_flag_nxt <= '0';
    end if;
end process;




e_index_selection : process(clk, reset_n) begin
    if (reset_n = '0') then
        e_idx_counter <= (others => '0');
    elsif(rising_edge(clk)) then
        if (end_flag_r = '1') then
            e_idx_counter <= (others => '0');
        else 
            e_idx_counter <=  e_idx_counter + 1;
        end if;
    end if;
end process;

--e_idx_cntr <= e_idx_counter;

--interface signals
msgout_valid <= msgout_ready and end_flag_r;
right_to_left_data_out_valid <= end_flag_r;
input_valid <= end_flag_r;
msgin_ready <= end_flag_r;
output_ready <= msgout_ready;

msgout_last  <= msgin_last and end_flag_r;


end Behavioral;
