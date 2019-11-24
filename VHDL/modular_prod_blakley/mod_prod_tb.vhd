
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

    --  uut_mod_prod : entity work.mod_prod(simple)
    uut_mod_prod : entity work.mod_prod(Blakley)
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
    wait for 5*CLK_PERIOD;
    input_valid_tb <= '0';
    output_ready_tb <= '1';

    -- 420 * 1337 mod 6969 = 4020
    input_valid_tb <= '1';
	--modulus <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
    A_tb <= x"0000000011111111222222223333333344444444555555556666666677777777";
    B_tb <= x"0000000011111111222222223333333344444444555555556666666677777777";
    --A_tb       <= std_logic_vector(to_unsigned(420, A_tb'length));
    --B_tb       <= std_logic_vector(to_unsigned(1337, B_tb'length));
	  n_tb <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
    --n_tb       <= std_logic_vector(to_unsigned(6969, n_tb'length));
    wait for 5*CLK_PERIOD;
    input_valid_tb <= '0';
    wait for 255*CLK_PERIOD;
    
    --- 42 * 34 mod 50 = 28
    input_valid_tb <= '1';
    A_tb       <= std_logic_vector(to_unsigned(42, A_tb'length));
    B_tb       <= std_logic_vector(to_unsigned(34, B_tb'length));
    n_tb       <= std_logic_vector(to_unsigned(50, n_tb'length));
    wait for 5*CLK_PERIOD;
    input_valid_tb <= '0';
    wait for 255*CLK_PERIOD;

    --- 10333 * 57683 mod 73555 = 22274
    input_valid_tb <= '1';
    A_tb       <= std_logic_vector(to_unsigned(10333, A_tb'length));
    B_tb       <= std_logic_vector(to_unsigned(57683, B_tb'length));
    n_tb       <= std_logic_vector(to_unsigned(73555, n_tb'length));
    wait for 5*CLK_PERIOD;
    input_valid_tb <= '0';
    wait for 255*CLK_PERIOD;
    
    wait for 5*CLK_PERIOD;
    input_valid_tb <= '0';
    output_ready_tb <= '0';
    A_tb       <= std_logic_vector(to_unsigned(0, A_tb'length));
    B_tb       <= std_logic_vector(to_unsigned(0, B_tb'length));
    n_tb       <= std_logic_vector(to_unsigned(0, n_tb'length));
    
    wait for 500*CLK_PERIOD;

  end process;

end arch;