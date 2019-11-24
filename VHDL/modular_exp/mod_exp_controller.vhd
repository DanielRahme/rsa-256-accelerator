library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mod_exp_controller is
Port ( mod_exp_out_ready : in  STD_LOGIC;
       mod_exp_in_valid  : in  STD_LOGIC;
       mod_exp_in_ready  : out STD_LOGIC;
       mod_exp_out_valid : out STD_LOGIC;
       init              : out STD_LOGIC;
       calculate         : out STD_LOGIC;
       mod_prod_out_ready: out STD_LOGIC;
       e0                : in STD_LOGIC;
       mod_prod_MM_out_valid : in STD_LOGIC;
       clk, reset_n      : in  STD_LOGIC);
end mod_exp_controller;

architecture Behavioral of mod_exp_controller is

type state_type is (idle, initial, calculating, finished);
signal state: state_type;

signal input_ready, output_valid: std_logic;
signal mod_prod_out_ready_r : std_logic;
begin
mod_exp_in_ready  <= input_ready;
mod_exp_out_valid <= output_valid;

next_state : process(reset_n,clk) begin
    if reset_n = '0' then
        state <= idle;
    end if;
    if rising_edge(clk) then
        case state is 
        when idle =>
            if mod_exp_in_valid = '1' then
                state <= initial;
            else
                state <= idle;
            end if;
        
        when initial =>
            if mod_prod_MM_out_valid = '1' then
                state <= calculating;
            else
                state <= initial;
            end if;
        
        when calculating =>
            if e0 = '0' then
                state <= finished;
            else
                state <= calculating;
            end if;
   
        when finished =>
            if mod_exp_out_ready = '1' then
                state <= idle;
            else
                state <= finished;
            end if;
        when others => state <= idle;   
        end case;
    end if;
end process;

handshake_out : process(state) begin
    case state is 
    when idle =>
        input_ready  <= '1';
        output_valid <= '0'; 
        calculate <= '0';    
    when initial =>
        input_ready  <= '0';
        output_valid <= '0';
        calculate <= '1';
    when calculating =>
        input_ready  <= '0';
        output_valid <= '0';
        calculate <= '1';
    when finished =>
        input_ready  <= '0';
        output_valid <= '1'; 
        calculate <= '0';     
    end case;
end process;

init_out : process (state) begin
    if state = initial then
        init <= '1';
    else
        init <= '0';
    end if;
end process; 


mod_prod_output_ready: process (reset_n, clk) begin
    if reset_n = '0' then
        mod_prod_out_ready <= '0';
    end if;
    if rising_edge(clk) then
        if  mod_prod_MM_out_valid = '1' and ((state = initial) or (state = calculating)) then
            mod_prod_out_ready <= '1';
        else 
            mod_prod_out_ready <= '0';
        end if;
    end if;
end process;



end Behavioral;