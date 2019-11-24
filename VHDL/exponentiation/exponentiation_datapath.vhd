library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity exponentiation_datapath is
	generic (
		C_block_size : integer := 256
	);
	port (
		-- Utility
		clk 		: in STD_LOGIC;
        reset_n 	: in STD_LOGIC;

		-- Top-level entity data
		Message 	: in std_logic_vector ( C_block_size-1 downto 0 );
		Key 		: in std_logic_vector ( C_block_size-1 downto 0 );
		Modulus 	: in std_logic_vector(C_block_size-1 downto 0);
		Result 		: out std_logic_vector(C_block_size-1 downto 0);

		-- Controller
		Load_in_reg  : in std_logic;
		Load_calc_reg  : in std_logic;
        Calc_done    : out std_logic;
        Load_out_reg : in std_logic;

        First_mod_done	    : out std_logic;
        First_mod_in_valid	: in std_logic;
        First_mod_out_ready	: in std_logic;
        First_mod_in_ready	: out std_logic;

        Mod_prod_done	    : out std_logic;
        Mod_prod_in_valid	: in std_logic;
        Mod_prod_out_ready	: in std_logic;
        Mod_prod_in_ready	: out std_logic
	);
end exponentiation_datapath;


architecture Behavioral of exponentiation_datapath is
    -- Registers from input and calc
    signal base_init, base_r, base_load, base_nxt : std_logic_vector(C_block_size-1 downto 0);
    signal mod_r                                  : std_logic_vector(C_block_size-1 downto 0);
    signal exp_r, exp_nxt                         : std_logic_vector(C_block_size-1 downto 0);
    signal result_r, result_nxt, result_nxt_i     : std_logic_vector(C_block_size-1 downto 0);

    -- Modprod: b * b mod n
    signal mod_prod_bb_in_valid        : std_logic;
    signal mod_prod_bb_in_ready        : std_logic;
    signal mod_prod_bb_out_valid       : std_logic;
    signal mod_prod_bb_out_ready       : std_logic;

    -- Modprod: result * base mod n
    signal mod_prod_rb_in_valid        : std_logic;
    signal mod_prod_rb_in_ready        : std_logic;
    signal mod_prod_rb_out_valid       : std_logic;
    signal mod_prod_rb_out_ready       : std_logic;
begin

    -- Mod Prod B^2 % n signal assignments:
    mod_prod_bb_in_valid    <= Mod_prod_in_valid;
    mod_prod_rb_in_valid    <= Mod_prod_in_valid;

    mod_prod_bb_out_ready   <= Mod_prod_out_ready;
    mod_prod_rb_out_ready   <= Mod_prod_out_ready;

    Mod_prod_done           <= mod_prod_bb_out_valid and mod_prod_rb_out_valid;-- add mod_prod_br later
    Mod_prod_in_ready       <= mod_prod_bb_in_ready and mod_prod_rb_in_ready;-- add mod_prod_br later


    check_calc_done: process(all) begin
        if (to_integer(unsigned(exp_r)) = 0) then
            Calc_done <= '1';
        else
            Calc_done <= '0';
        end if;
    end process;


    ----------------------- LOAD IN ------------------------------
    load_in_proc: process(clk, reset_n) begin
        if (reset_n = '0') then
            base_r <= (others => '0');
            base_init <= (others => '0');
            mod_r <= (others => '0');
            exp_r <= (others => '0');
            result_r <= (others => '0');
        
        elsif (rising_edge(clk)) then
            if (Load_in_reg = '1') then
                base_init <= Message;
                mod_r <= Modulus;
                exp_r <= Key;
                result_r <= std_logic_vector(to_unsigned(1, result_r'length));

            
            elsif (Load_calc_reg = '1') then
                base_r <= base_nxt;
                exp_r <= exp_nxt;
                result_r <= result_nxt;
            end if;

            if (First_mod_out_ready = '1') then
                base_r <= base_load;
            end if;
        end if;
    end process;


    --------------- FIRST MOD ------------------------------------
    u_first_mod: entity work.modulo_operation(Behavioral) port map (
        -- Utility
        reset_n => reset_n,
        clk => clk,
        -- Input/Output valid ready
        input_valid =>  First_mod_in_valid,
        input_ready =>  First_mod_in_ready,
        output_ready => First_mod_out_ready,
        output_valid => First_mod_done,
        -- Data
        A => base_init,
        modulus => mod_r,
        result => base_load
    );


    -- B^2 mod n
    u_b2_blakley: entity work.mod_prod(Blakley) port map (
        -- Utility
        reset_n => reset_n,
        clk => clk,
        -- Input/Output valid ready
        input_valid =>  mod_prod_bb_in_valid,
        input_ready =>  mod_prod_bb_in_ready,
        output_ready => mod_prod_bb_out_ready,
        output_valid => mod_prod_bb_out_valid,
        -- Data
        A => base_r,
        B => base_r,
        n => mod_r,
        C => base_nxt
    );

    -- Right shift
    exp_nxt <= '0' & exp_r(C_block_size-1 downto 1); -- exp >> 1

    u_rb_blakley: entity work.mod_prod(Blakley) port map (
        -- Utility
        reset_n => reset_n,
        clk => clk,
        -- Input/Output valid ready
        input_valid =>  mod_prod_rb_in_valid,
        input_ready =>  mod_prod_rb_in_ready,
        output_ready => mod_prod_rb_out_ready,
        output_valid => mod_prod_rb_out_valid,
        -- Data
        A => base_r,
        B => result_r,
        n => mod_r,
        C => result_nxt_i
    );

    -- Next result
    calc_nxt_result: process(exp_r, result_nxt_i, result_r) 
        variable is_exp_one : std_logic;
    begin
        is_exp_one := exp_r(0);

        if (is_exp_one = '1') then
            result_nxt <= result_nxt_i; -- From modprod
        else
            result_nxt <= result_r;
        end if;
    end process;

    load_out: process(all) begin
        if (Load_out_reg = '1') then
           Result <= result_r;
        else 
           Result <= (others => '0');
        end if;
    end process;

end Behavioral;