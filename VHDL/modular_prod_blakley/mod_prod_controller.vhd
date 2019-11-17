
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
            out_reg_enable  : out std_logic);
end mod_prod_controller;


architecture Blakley of mod_prod_controller is
    -- State declaration
    type States_t is (IDLE, LOAD_IN, CALC, FINISHED);
    signal state        : States_t;

    -- Calculation counter
    signal calc_counter : unsigned(8 downto 0);
    signal calc_start   : std_logic;

begin

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
                    calc_start      <= '0';

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
                    calc_start      <= '0';

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
                    calc_start      <= '1';

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
                    calc_start      <= '0';

                ------------------
                ----- OTHERS -----
                ------------------
                when OTHERS => 
                    input_ready     <= '0';
                    output_valid    <= '0';
                    in_reg_enable   <= '0';
                    calc_enable     <= '0';
                    out_reg_enable  <= '0';
                    calc_start      <= '0';
                end case;
    end process;
    
    -- FSM Transitions Handler
    fsm_transitions: process(clk, reset_n) begin
        if (reset_n = '0') then
            state           <= IDLE;
        
        elsif (rising_edge(clk)) then
            case state is
                ----- IDLE -----
                when IDLE =>
                    if (input_valid = '1') then
                        state <= LOAD_IN;
                    end if;
                
                ----- LOAD IN -----
                when LOAD_IN =>
                    state <= CALC;

                ----- CALC -----
                when CALC =>
                    if (calc_counter >= 255) then
                        state <= FINISHED;
                    end if;

                ----- FINISHED -----
                when FINISHED =>
                    if (output_ready = '1') then
                        state <= IDLE;
                    end if;

                ----- OTHERS -----
                    when OTHERS => 
                        state <= IDLE;
            end case;
        end if;
    end process;

    Calculation_counter: process(clk, reset_n) begin
        if (reset_n = '0') then
            calc_counter <= (others => '0');

        elsif (rising_edge(clk)) then
            if (calc_start = '1') then
                calc_counter <= calc_counter + 1;
            else
               calc_counter <= (others => '0'); 
            end if;
        end if;
    end process;

end Blakley;


--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
-- Simple straight forward implementation
--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
architecture simple of mod_prod_controller is
    signal output_valid_r : std_logic;

begin
    -- Add a one cycle stall
    output_valid_r <= input_valid;
    output_valid <= output_valid_r;

end simple;
