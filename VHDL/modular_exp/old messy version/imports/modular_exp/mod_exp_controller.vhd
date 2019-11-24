----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 19:48:43
-- Design Name: 
-- Module Name: mod_exp_controller - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.state_type_pakage.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_exp_controller is
Port ( mod_exp_out_ready : in  STD_LOGIC;
       mod_exp_in_valid  : in  STD_LOGIC;
       mod_exp_in_ready  : out STD_LOGIC;
       mod_exp_out_valid : out STD_LOGIC;
       clk, reset_n      : in  STD_LOGIC;
       
       --signal for datapath
       state             : out state_type;
       sub_state         : out sub_state_type;
       mod_prod_MM_data_in_ready : in std_logic;
       mod_prod_CM_data_in_ready : in std_logic;
       mod_prod_MM_data_out_valid : in std_logic;
       mod_prod_CM_data_out_valid : in std_logic;
       e_reg_control_logic        : in std_logic_vector(255 downto 0)
       );
end mod_exp_controller;

architecture Behavioral of mod_exp_controller is
    
    signal state_control : state_type;
    signal sub_state_control : sub_state_type;
    signal nxt_state : state_type;
    signal nxt_sub_state : sub_state_type;
begin

state_logic: process (reset_n,clk) begin
    if reset_n = '0' then
        state_control <= inital;
    end if;
    if rising_edge(clk) then
        if    state_control = inital      then
            if sub_state_control = recieve_from_mod_prod then 
                state_control <= calculating;
            else 
                state_control <= inital;
            end if;
        elsif state_control = calculating then
            if (nor_reduce(e_reg_control_logic) = '1') and sub_state_control = recieve_from_mod_prod then
                state_control <= finished;
            else 
                state_control <= calculating;
            end if;
        elsif state_control = finished then
            state_control <= finished;                      
        end if;
    end if;
end process;

sub_state_logic : process (clk, reset_n) begin
    if reset_n = '0' then 
        sub_state_control <= prepare;
    end if;
    if rising_edge(clk) then
        if sub_state_control = prepare then
            if mod_prod_MM_data_in_ready = '1' and mod_prod_CM_data_in_ready = '1' then
                sub_state_control <= send_to_mod_prod;
            else
                sub_state_control <= prepare;
            end if;
        elsif sub_state_control = send_to_mod_prod then
            if mod_prod_MM_data_out_valid = '1' and mod_prod_CM_data_out_valid  = '1' then
                sub_state_control <= recieve_from_mod_prod;
            else
                sub_state_control <= send_to_mod_prod;
            end if;
        elsif sub_state_control = recieve_from_mod_prod then
            if nor_reduce(e_reg_control_logic) = '1' then
                sub_state_control <= waiting;
            else
                sub_state_control <= prepare;
            end if;
        end if;
    end if;
end process;


handshake : process( reset_n, clk) begin
    if(reset_n = '0') then
        mod_exp_out_valid <= '0';
        mod_exp_in_ready <= '1';
    elsif( rising_edge(clk)) then
        if state_control = finished then
            mod_exp_out_valid <= '1';
            mod_exp_in_ready <= '1';
        else 
            mod_exp_out_valid <= '0';
            mod_exp_in_ready <= '0';
        end if;
    end if;
end process;

sub_state <= sub_state_control;
state     <= state_control;

end Behavioral;
