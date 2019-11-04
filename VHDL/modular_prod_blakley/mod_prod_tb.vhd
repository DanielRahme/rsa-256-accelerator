
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_prod_tb is
end mod_prod_tb;


architecture arch of mod_prod_tb is
    constant T : time := 20 ns; 

    -- Inputs
    signal reset_n_tb : std_logic;
    signal clk_tb           : std_logic;
    signal A_tb            : std_logic_vector (255 downto 0);
    signal B_tb            : std_logic_vector (255 downto 0);
    signal n_tb            : std_logic_vector (255 downto 0);
    signal input_valid_tb  : std_logic;
    signal output_ready_tb :  std_logic;

    -- Outputs
    signal input_ready_tb  : std_logic;
    signal output_valid_tb :  std_logic;
    signal C_tb            :  std_logic_vector (255 downto 0);

begin

    uut_mod_prod : entity work.mod_prod_blakley
        port map (
           reset_n => reset_n_tb,
           clk => clk_tb,
           A            => A_tb,
           B            => B_tb,
           n            => n_tb,
           input_valid  => input_valid_tb,
           input_ready  => input_ready_tb,

           output_ready => output_ready_tb,
           output_valid => output_valid_tb,
           C            => C_tb
        );

    -- continuous clock
    clock: process 
    begin
        clk_tb <= '0';
        wait for T/2;
        clk_tb <= '1';
        wait for T/2;
    end process;


    -- reset = 1 for first clock cycle and then 0
    reset_n_tb <= '0', '1' after T/2;

end arch;