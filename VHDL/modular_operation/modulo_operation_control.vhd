----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2019 17:42:56
-- Design Name: 
-- Module Name: modulo_operation_control - Behavioral
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

entity modulo_operation_control is
    Port (
        --clk and reset
        clk : in std_logic;
        reset_n : in std_logic; 
        
        --I/O interface
        input_valid : in STD_LOGIC;
        input_ready : out STD_LOGIC;
        output_valid : out STD_LOGIC;
        output_ready : in STD_LOGIC;
        
        --output for datapath
        load_output_register: out std_logic;
        load_input_register: out std_logic;
        partial_result_select : out std_logic;
        
        --input from datapath
        a_less_n_flag : in STD_LOGIC
        
        );
end modulo_operation_control;

architecture Behavioral of modulo_operation_control is
    type state_type is (IDLE, LOAD_IN, CALC, LOAD_OUT, WAIT_FOR_READY_OUT);
    signal state_r, state_nxt: state_type;
begin

--state register
sreg: process (clk, reset_n) begin
    if(reset_n = '0') then
        state_r <= IDLE;
    elsif (rising_edge(clk)) then
        state_r <= state_nxt;
    end if;
end process;

--state generation
state_nxt_gen: process(state_r, input_valid, a_less_n_flag, output_ready) begin
    case state_r is 
        when IDLE => 
            if(input_valid = '1') then
                state_nxt <= LOAD_IN;
             else
                state_nxt <= IDLE;
             end if;
             
        when LOAD_IN => 
            state_nxt <= CALC;
            
        when CALC =>
            if(a_less_n_flag = '1') then
                state_nxt <= LOAD_OUT;
            else
                state_nxt <= CALC;
            end if;
         
        when LOAD_OUT =>
            state_nxt <= WAIT_FOR_READY_OUT;
        when WAIT_FOR_READY_OUT =>
            if (output_ready = '1') then
                state_nxt <= IDLE;
            else
                state_nxt <= WAIT_FOR_READY_OUT;
            end if;
        when others =>
            state_nxt <= IDLE;
        end case;        
end process;

--output generation
out_generation: process(state_r) begin
    case state_r is
        when IDLE =>
           input_ready <= '1';
           output_valid <= '0';
           load_output_register <= '0';
           load_input_register <= '0';
           partial_result_select <= '0';
        when LOAD_IN =>
           input_ready <= '0';
           output_valid <= '0';
           load_output_register <= '0';
           load_input_register <= '1';
           partial_result_select <= '0';
        when CALC =>
           input_ready <= '0';
           output_valid <= '0';
           load_output_register <= '0';
           load_input_register <= '0';
           partial_result_select <= '1'; 
        when LOAD_OUT =>
           input_ready <= '0';
           output_valid <= '0';
           load_output_register <= '1';
           load_input_register <= '0';
           partial_result_select <= '1';
        when WAIT_FOR_READY_OUT =>
           input_ready <= '0';
           output_valid <= '1';
           load_output_register <= '0';
           load_input_register <= '1';
           partial_result_select <= '1';
        end case;
end process;

end Behavioral;
