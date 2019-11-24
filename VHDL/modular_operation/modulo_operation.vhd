----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2019 17:32:30
-- Design Name: 
-- Module Name: modulo_operation - Behavioral
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

entity modulo_operation is
    Port (
           --clk and reset
           clk : in std_logic;
           reset_n : in std_logic;
           
           --data input
           A : in STD_LOGIC_VECTOR (255 downto 0);
           modulus : in STD_LOGIC_VECTOR (255 downto 0);
           
           --data output
           result : out STD_LOGIC_VECTOR (255 downto 0);
           
           --I/O interface
           input_ready : out STD_LOGIC;
           input_valid : in STD_LOGIC;
           output_ready : in STD_LOGIC;
           output_valid : out STD_LOGIC
    );
           
end modulo_operation;

architecture Behavioral of modulo_operation is
    signal a_less_n_flag :std_logic;
    signal load_input_register: std_logic;
    signal load_output_register: std_logic;
    signal partial_result_select : std_logic;
begin
    
mod_datapath : entity work.modulo_operation_datapath(Behavioral)
Port map(
    --clk and reset
    clk     => clk,
    reset_n => reset_n,
    --data input
    A       => A,
    modulus => modulus,
    
    --data output
    result  => result,
    
    --signal from control logic
    load_input_register     => load_input_register,
    load_output_register    => load_output_register,
    partial_result_select   => partial_result_select,
    
    --signal to control logic
    a_less_n_flag   => a_less_n_flag
    );

mod_control : entity work.modulo_operation_control(Behavioral)
Port map(

    --clk and reset
    clk     => clk,
    reset_n => reset_n,
    
    input_valid     => input_valid,
    input_ready     => input_ready,
    output_valid    => output_valid,
    output_ready    => output_ready,
    
    --signal to datapath
    load_input_register     => load_input_register,
    load_output_register    => load_output_register,
    partial_result_select   => partial_result_select,
    
    --signal from datapath
    a_less_n_flag   => a_less_n_flag 
);
    
    
  
    
    

end Behavioral;
