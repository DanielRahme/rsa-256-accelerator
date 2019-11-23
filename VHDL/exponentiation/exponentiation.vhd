library ieee;
use ieee.std_logic_1164.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		message 	: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		key 		: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );

		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--output data
		result 		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		modulus 	: in STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is
	signal Load_in_reg     : std_logic;
	signal Load_calc_reg   : std_logic;
	signal Calc_done       : std_logic;
	signal Load_out_reg    : std_logic;

begin

    -- Instatiate controller module
    u_controller: entity work.exponentiation_controller(Behavioral) port map (
        reset_n => reset_n,
		clk => clk,

        -- Top-level entitiy
        input_valid => valid_in,
        input_ready => ready_in,
        output_ready => ready_out,
        output_valid => valid_out,

        -- Datapath
        Load_in_reg     => Load_in_reg,
        Load_calc_reg   => Load_calc_reg,
        Calc_done       => Calc_done,
        Load_out_reg    => Load_out_reg
        --Mod_prod_done    => Mod_prod_done
    );

    -- Instatiate datapath module
    u_datapath: entity work.exponentiation_datapath(Behavioral) port map (
        reset_n => reset_n,
		clk => clk,

        -- Top-level entitiy
        Message => message,
        Key => key,
        Modulus => modulus,
        Result => result,

        -- Controller
        Load_in_reg     => Load_in_reg,
        Load_calc_reg   => Load_calc_reg,
        Calc_done       => Calc_done,
        Load_out_reg    => Load_out_reg
        --Mod_prod_done    => Mod_prod_done
    );

end expBehave;
