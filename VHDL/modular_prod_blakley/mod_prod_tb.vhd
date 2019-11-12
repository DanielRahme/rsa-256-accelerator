
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_prod_tb is
end mod_prod_tb;


architecture arch of mod_prod_tb is
    constant CLK_PERIOD : time := 5 ns; 

    -- Inputs
    signal reset_n_tb       : std_logic := '0';
    signal clk_tb           : std_logic := '1';
    signal A_tb             : std_logic_vector (255 downto 0);
    signal B_tb             : std_logic_vector (255 downto 0);
    signal n_tb             : std_logic_vector (255 downto 0);
    signal input_valid_tb   : std_logic;
    signal output_ready_tb  :  std_logic;

    -- Outputs
    signal input_ready_tb  : std_logic;
    signal output_valid_tb :  std_logic;
    signal C_tb            :  std_logic_vector (255 downto 0);

begin

    --  uut_mod_prod : entity work.mod_prod_blakley(simple)
    uut_mod_prod : entity work.mod_prod_blakley(Behavioral)
        port map (
           reset_n      => reset_n_tb,
           clk          => clk_tb,
           A            => A_tb,
           B            => B_tb,
           n            => n_tb,
           input_valid  => input_valid_tb,
           input_ready  => input_ready_tb,

           output_ready => output_ready_tb,
           output_valid => output_valid_tb,
           C            => C_tb
        );

    -- Clock generation
    clk_tb <= not clk_tb after CLK_PERIOD/2;

    -- reset = 1 for first clock cycle and then 0
    -- reset_n_tb <= '0', '1' after CLK_PERIOD/2;

  -- Stimuli generation
  stimuli_proc: process
  begin
    reset_n_tb <= '1';
    wait for CLK_PERIOD;
    reset_n_tb <= '0';
    wait for CLK_PERIOD;
    reset_n_tb <= '1';
    wait for CLK_PERIOD;
  
    -- Send in first test vector
    -- 333 * 666 mod 69 = 12
    wait for 10*CLK_PERIOD;
    input_valid_tb <= '1';
    output_ready_tb <= '1';
    A_tb       <= std_logic_vector(to_unsigned(333, A_tb'length));
    B_tb       <= std_logic_vector(to_unsigned(666, B_tb'length));
    n_tb       <= std_logic_vector(to_unsigned(69, n_tb'length));

  end process;

end arch;