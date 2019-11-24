
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity mod_prod_controller is
    Port ( 
        -- Input
        reset_n         : in std_logic;
        clk             : in std_logic;
        input_valid     : in std_logic;
        output_ready    : in std_logic;

        -- Output
        input_ready     : out std_logic;
        output_valid    : out std_logic;
        in_reg_enable   : out std_logic;
        calc_enable     : out std_logic;
        out_reg_enable  : out std_logic;
        calc_done       : in  std_logic
    );
end mod_prod_controller;


architecture Blakley of mod_prod_controller is
    -- State declaration
    type States_t is (IDLE, LOAD_IN, CALC, FINISHED);
    signal state, next_state        : States_t;

    -- Calculation counter
    --signal calc_start   : std_logic;

    signal input_valid_i    : std_logic;
    signal output_ready_i   : std_logic;
    signal calc_done_i      : std_logic;

begin

    input_valid_i <= input_valid;
    output_ready_i <= output_ready;
    calc_done_i    <= calc_done;

    state_reg: process(clk, reset_n) begin
        if (reset_n = '0') then
            state <= IDLE;
        
        elsif (rising_edge(clk)) then
              state <= next_state;
        end if;
    end process;

    -- FSM Outputs for each state
    fsm_outputs: process(state) begin
        case state is
                ----------------
                ----- IDLE -----
                ----------------
                when IDLE =>
                    -- Outputs
                    input_ready     <= '1';
                    output_valid    <= '0';
                    in_reg_enable   <= '0';
                    calc_enable     <= '0';
                    out_reg_enable  <= '0';
                    -- Internal

                -------------------
                ----- LOAD IN -----
                -------------------
                when LOAD_IN =>
                    -- Outputs
                    output_valid    <= '0';
                    calc_enable     <= '0';
                    out_reg_enable  <= '0';
                    input_ready     <= '0';
                    in_reg_enable   <= '1';
                    -- Internal

                ----------------
                ----- CALC -----
                ----------------
                when CALC =>
                    -- Outputs
                    output_valid    <= '0';
                    out_reg_enable  <= '0';
                    input_ready     <= '0';
                    in_reg_enable   <= '0';
                    calc_enable     <= '1';
                    -- Internal

                --------------------
                ----- FINISHED -----
                --------------------
                when FINISHED =>
                    -- Outputs
                    input_ready     <= '0';
                    in_reg_enable   <= '0';
                    output_valid    <= '1';
                    calc_enable     <= '0';
                    out_reg_enable  <= '1';
                    -- Internal

                ------------------
                ----- OTHERS -----
                ------------------
                when OTHERS => 
                    input_ready     <= '0';
                    output_valid    <= '0';
                    in_reg_enable   <= '0';
                    calc_enable     <= '0';
                    out_reg_enable  <= '0';

                end case;
    end process;
    
    -- FSM Transitions Handler
    fsm_transitions: process(input_valid, output_ready, state, calc_done) begin
        case state is
            ----- IDLE -----
            when IDLE =>
                if (input_valid = '1') then
                    next_state <= LOAD_IN;
                else
                    next_state <= IDLE;
                end if;
            
            ----- LOAD IN -----
            when LOAD_IN =>
                next_state <= CALC;

            ----- CALC -----
            when CALC =>
                if (calc_done = '1') then
                    next_state <= FINISHED;
                else
                    next_state <= CALC;
                end if;

            ----- FINISHED -----
            when FINISHED =>
                if (output_ready = '1') then
                    next_state <= IDLE;
                else
                    next_state <= FINISHED;
                end if;

            ----- OTHERS -----
                when OTHERS => 
                    next_state <= IDLE;
        end case;
    end process;


end Blakley;


--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
-- Simple straight forward implementation
--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
--architecture simple of mod_prod_controller is
    --signal output_valid_r : std_logic;
--
--begin
    ---- Add a one cycle stall
    --output_valid_r <= input_valid;
    --output_valid <= output_valid_r;
--
--end simple;
