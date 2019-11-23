library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity exponentiation_tb is
	generic (
		C_block_size : integer := 256
	);
end exponentiation_tb;


architecture expBehave of exponentiation_tb is
    constant CLK_PERIOD : time := 5 ns; 

	signal message 		: STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	signal key 			: STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	signal valid_in 	: STD_LOGIC;
	signal ready_in 	: STD_LOGIC;
	signal ready_out 	: STD_LOGIC;
	signal valid_out 	: STD_LOGIC;
	signal result 		: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal modulus 		: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal clk 			: STD_LOGIC := '1';
	signal reset_n 		: STD_LOGIC := '0';

begin
	i_exponentiation : entity work.exponentiation
		port map (
			message   => message  ,
			key       => key      ,
			valid_in  => valid_in ,
			ready_in  => ready_in ,
			ready_out => ready_out,
			valid_out => valid_out,
			result    => result   ,
			modulus   => modulus  ,
			clk       => clk      ,
			reset_n   => reset_n
		);

    -- Clock generation
	clk <= not clk after CLK_PERIOD/2;

  -- Stimuli generation
  stimuli_proc: process
  begin
	-- Reset pulse
    reset_n <= '1';
    wait for CLK_PERIOD;
    reset_n <= '0';
    wait for CLK_PERIOD;
    reset_n <= '1';
	wait for CLK_PERIOD;

	-- Keys
  	--n: x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
	--e: x"0000000000000000000000000000000000000000000000000000000000010001";
	--d: x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9";

	--M: 0000000011111111222222223333333344444444555555556666666677777777
	--C: 23026c469918f5ea097f843dc5d5259192f9d3510415841ce834324f4c237ac7

	--M: 8888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
	--C: 4dd5e8dfda5da31a8881b3fdd37dd9f3a5009f1354cd078e5c2c49b54ccb5f3f

	key 	<= x"0000000000000000000000000000000000000000000000000000000000010001";
	modulus <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";

	-- First test vector
	message <= x"0000000011111111222222223333333344444444555555556666666677777777";
    valid_in <= '1';
	ready_out <= '1';
	wait for 5*CLK_PERIOD;
    
    valid_in <= '0';
    ready_out <= '1';
    message   <= std_logic_vector(to_unsigned(0, message'length));
    wait for 255*CLK_PERIOD;

	-- Second test vector
	message <= x"8888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff";
    valid_in <= '1';
	ready_out <= '1';
	wait for 5*CLK_PERIOD;
    
    valid_in <= '0';
    ready_out <= '1';
    message   <= std_logic_vector(to_unsigned(0, message'length));
    wait for 255*CLK_PERIOD;
  end process;

end expBehave;
