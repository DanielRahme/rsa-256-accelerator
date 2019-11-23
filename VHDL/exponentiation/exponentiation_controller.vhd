
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity exponentiation_controller is
    Port ( 
        --Utility
        reset_n         : in std_logic;
        clk             : in std_logic;

        -- Top-level entitiy
        input_valid     : in std_logic;
        output_ready    : in std_logic;
        input_ready     : out std_logic;
        output_valid    : out std_logic;

        -- Datapath
        Load_in_reg     : out std_logic;
        Load_calc_reg   : out std_logic;
        Calc_done       : in std_logic;
        Load_out_reg    : out std_logic
        --Mod_prod_finished	: out std_logic
    );
end exponentiation_controller;


architecture Behavioral of exponentiation_controller is
    -- State declaration
    type States_t is (IDLE, LOAD_IN, CALC, LOAD_OUT);
    signal state, next_state        : States_t;

    -- Calculation counter
    signal calc_counter : unsigned(8 downto 0);
    signal calc_start   : std_logic;

begin

    state_reg: process(clk, reset_n) begin
        if (reset_n = '0') then
            state <= IDLE;
        
        elsif (rising_edge(clk)) then
              state <= next_state;
        end if;
    end process;


    controller_output_generator: process(state) begin
        case state is
            ----------------
            ----- IDLE -----
            when IDLE =>
                input_ready   <= '1';
                output_valid  <= '0';

                Load_in_reg   <= '0';
                Load_calc_reg <= '0';
                Load_out_reg  <= '0';

            -------------------
            ----- LOAD IN -----
            when LOAD_IN =>
                input_ready   <= '0';
                output_valid  <= '0';

                Load_in_reg   <= '1';
                Load_calc_reg <= '0';
                Load_out_reg  <= '0';

            ----------------
            ----- CALC -----
            when CALC =>
                input_ready   <= '0';
                output_valid  <= '0';

                Load_in_reg   <= '0';
                Load_calc_reg <= '1';
                Load_out_reg  <= '0';

            --------------------
            ----- LOAD OUT -----
            when LOAD_OUT =>
                input_ready   <= '0';
                output_valid  <= '1';

                Load_in_reg   <= '0';
                Load_calc_reg <= '0';
                Load_out_reg  <= '1';

            ------------------
            ----- OTHERS -----
            when OTHERS => 
                input_ready   <= '0';
                output_valid  <= '0';

                Load_in_reg   <= '0';
                Load_calc_reg <= '0';
                Load_out_reg  <= '0';
            end case;
    end process;
    
    next_state_proc: process(state, input_valid, output_ready, Calc_done) begin
        case state is
            ----------------
            ----- IDLE -----
            when IDLE =>
                if (input_valid = '1') then
                    next_state <= LOAD_IN;
                else
                    next_state <= IDLE;
                end if;
            
            -------------------
            ----- LOAD IN -----
            when LOAD_IN =>
                next_state <= CALC;

            ----------------
            ----- CALC -----
            when CALC =>
                if (Calc_done = '1') then
                    next_state <= LOAD_OUT;
                else 
                    next_state <= CALC;
                end if;

            --------------------
            ----- FINISHED -----
            when LOAD_OUT =>
                if (output_ready = '1') then
                    next_state <= IDLE;
                else
                    next_state <= LOAD_OUT;
                end if;
                -- Load out data and wait for out-ready

            ----------------
            ----- OTHERS -----
                when OTHERS => 
                    next_state <= IDLE;

        end case;
    end process;


end Behavioral; 
