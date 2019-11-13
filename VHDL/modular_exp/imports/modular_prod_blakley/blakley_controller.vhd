----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 19:34:10
-- Design Name: 
-- Module Name: blakley_controller - Behavioral
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

entity blakley_controller is
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
end blakley_controller;


architecture Behavioral of blakley_controller is
    -- State declaration
    type States_t is (IDLE, LOAD_IN, CALC, FINISHED);
    signal state        : States_t;

    -- Calculation counter
    signal calc_counter : unsigned(7 downto 0);
    signal calc_start   : std_logic;

begin
    -- Real control code
    FSM: process(clk, reset_n) begin
        if (reset_n = '0') then
            -- Outputs
            input_ready     <= '0';
            output_valid    <= '0';
            in_reg_enable   <= '0';
            calc_enable     <= '0';
            out_reg_enable  <= '0';

            -- Internal signals
            calc_start      <= '0';
            state           <= IDLE;
        
        elsif (rising_edge(clk)) then
            case state is
                ----------------
                ----- IDLE -----
                when IDLE =>
                    input_ready     <= '1';
                    output_valid    <= '0';
                    in_reg_enable   <= '0';
                    calc_enable     <= '0';
                    out_reg_enable  <= '0';
                    calc_start      <= '0';

                    if (input_valid = '1') then
                        state <= LOAD_IN;
                    end if;
                    -- idle stuff happening, if-state to next state
                
                -------------------
                ----- LOAD IN -----
                when LOAD_IN =>
                    input_ready     <= '0';
                    output_valid    <= '0';
                    in_reg_enable   <= '1';
                    calc_enable     <= '0';
                    out_reg_enable  <= '0';

                    state <= CALC;

                ----------------
                ----- CALC -----
                when CALC =>
                    input_ready     <= '0';
                    output_valid    <= '0';
                    in_reg_enable   <= '0';
                    calc_enable     <= '1';
                    out_reg_enable  <= '0';
                    calc_start      <= '1';

                    -- if statement counter = 255
                    if (calc_counter = 255) then
                        state <= FINISHED;
                    end if;
                    -- Load data and start counter

                --------------------
                ----- FINISHED -----
                when FINISHED =>
                    input_ready     <= '0';
                    output_valid    <= '1';
                    in_reg_enable   <= '0';
                    calc_enable     <= '0';
                    out_reg_enable  <= '1';
                    
                    if (output_ready = '1') then
                        state <= IDLE;
                    end if;
                    -- Load out data and wait for out-ready

                ----------------
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
            end if;
        end if;
    end process;

end Behavioral;


--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
-- Simple straight forward implementation
--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
architecture simple of blakley_controller is
    signal output_valid_r : std_logic;

begin
    -- Add a one cycle stall
    input_ready <= '1';
    output_valid_r <= input_valid;
    output_valid <= output_valid_r;

end simple;
