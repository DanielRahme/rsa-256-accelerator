----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2019 17:42:56
-- Design Name: 
-- Module Name: modulo_operation_datapath - Behavioral
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
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modulo_operation_datapath is
    Port (
    --clk and reset
    clk : in std_logic;
    reset_n : in std_logic;
    
    --data input
     A : in STD_LOGIC_VECTOR (255 downto 0);
     modulus : in STD_LOGIC_VECTOR (255 downto 0);
     
     --data output
     result : out STD_LOGIC_VECTOR (255 downto 0);
     
     --signal from control logic
     load_input_register : in STD_LOGIC;
     load_output_register : in STD_LOGIC;
     partial_result_select : in std_logic;
     
     --signal to control logic
     a_less_n_flag : out STD_LOGIC
     );
end modulo_operation_datapath;

architecture Behavioral of modulo_operation_datapath is
    signal partial_result_r, partial_result_nxt : std_logic_vector(255 downto 0);
    signal modulus_r, modulus_nxt : std_logic_vector(255 downto 0);
    signal result_r: std_logic_vector(255 downto 0);
begin

--input register
modulus_register: process (clk, reset_n) begin
    if (reset_n = '0') then
        modulus_r <= (others => '0');
    elsif (rising_edge(clk)) then
        modulus_r <= modulus_nxt;
    end if;
end process;

modulus_nxt_gen: process (load_input_register) begin
    if load_input_register = '1' then
        modulus_nxt <= modulus;
    else
        modulus_nxt <= modulus_r;
    end if;
end process;

--output register
output_register: process (clk, reset_n ) begin
    if ( reset_n = '0') then
        result_r <= (others => '0');
    elsif (rising_edge(clk)) then
        if(load_output_register = '1') then
            result_r <= std_logic_vector (unsigned(partial_result_r) + unsigned(modulus_r));
        else
            result_r <= result_r;
        end if;
    end if;
end process;

result <= result_r;        
--parial result register
partial_result_register: process(clk, reset_n) begin
    if( reset_n = '0') then
        partial_result_r <= (others => '0');
    elsif (rising_edge(clk)) then
        if(partial_result_select = '0') then
           partial_result_r <= A;
        else
           partial_result_r <= partial_result_nxt;
        end if;
    end if;
end process;

partial_result_nxt <= std_logic_vector ( (unsigned(partial_result_r)) - (unsigned(modulus_r)));

--A<n flag
a_less_n_flag_gen : process (partial_result_r, modulus_r) begin
    if (partial_result_r < modulus_r) then
        a_less_n_flag <= '1';
    else 
        a_less_n_flag <= '0';
    end if;
end process;

end Behavioral;
