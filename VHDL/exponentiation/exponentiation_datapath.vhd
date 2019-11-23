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
		Load_calc_reg  : in std_logic; -- based on modprod out valid
        Calc_done    : out std_logic;
		Load_out_reg : in std_logic
        --Mod_prod_done	: out std_logic
	);
end exponentiation_datapath;


architecture Behavioral of exponentiation_datapath is
    -- Registers from input and calc
    signal base_r, base_load, base_nxt         : std_logic_vector(C_block_size-1 downto 0);
    signal mod_r                    : std_logic_vector(C_block_size-1 downto 0);
    signal exp_r, exp_nxt           : std_logic_vector(C_block_size-1 downto 0);
    signal result_r, result_nxt     : std_logic_vector(C_block_size-1 downto 0);

    -- Modprod: b * b mod n
    --signal mod_prod_bb_in_valid        : std_logic;
    --signal mod_prod_bb_in_ready        : std_logic;
    --signal mod_prod_bb_out_valid       : std_logic;
    --signal mod_prod_bb_out_ready       : std_logic;

    -- Modprod: result * base mod n
    --signal mod_prod_rb_in_valid        : std_logic;
    --signal mod_prod_rb_in_ready        : std_logic;
    --signal mod_prod_rb_out_valid       : std_logic;
    --signal mod_prod_rb_out_ready       : std_logic;

    --signal is_exp_one                  : std_logic;
begin



    check_calc_done: process(exp_r) begin
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
            mod_r <= (others => '0');
            exp_r <= (others => '0');
            result_r <= (others => '0');
        
        elsif (rising_edge(clk)) then
            if (Load_in_reg = '1') then
                --base_r <= Message; -- do 1 * message mod n first
                base_r <= base_load;
                mod_r <= Modulus;
                exp_r <= Key;
                result_r <= std_logic_vector(to_unsigned(1, result_r'length));
            
            elsif (Load_calc_reg = '1') then
                base_r <= base_nxt;
                exp_r <= exp_nxt;
                result_r <= result_nxt;

            end if;
        end if;
    end process;

    process(Message, Modulus) begin
        if (to_integer(unsigned(Message)) = 0 or to_integer(unsigned(Modulus)) = 0) then
            base_load <= (others => '0');
        else
            base_load <= std_logic_vector((unsigned(Message)) mod (unsigned(Modulus)));
        end if;
    end process;

    ----------------------- BASE REG ------------------------------
    --base_reg: process(clk, reset_n) begin
        --if (reset_n = '0') then
            --base_r <= (others => '0');
        --
        --elsif (rising_edge(clk)) then
            --if (Load_calc_reg = '1') then
              --base_r <= base_nxt;
            --end if;
        --end if;
    --end process;

    -- TODO: Implement Blakley
    -- base_nxt <= modprod(base, base, n);
    process(base_r, mod_r) begin
        if (to_integer(unsigned(base_r)) = 0 or to_integer(unsigned(mod_r)) = 0) then
            base_nxt <= (others => '0');
        else
            base_nxt <= std_logic_vector( ((unsigned(base_r)) * (unsigned(base_r)) mod (unsigned(mod_r)) ));
        end if;
    end process;


    ----------------------- EXP REG ------------------------------
    --exp_reg: process(clk, reset_n) begin
        --if (reset_n = '0') then
            --exp_r <= (others => '0');
        --
        --elsif (rising_edge(clk)) then
            --if (Load_calc_reg = '1') then
              --exp_r <= exp_nxt;
            --end if;
        --end if;
    --end process;

    -- Right shift
    exp_nxt <= '0' & exp_r(C_block_size-1 downto 1); -- exp >> 1


    ----------------------- RESULT REG ------------------------------
    --result_reg: process(clk, reset_n) begin
        --if (reset_n = '0') then
            --result_r <= (others => '0');
        --
        --elsif (rising_edge(clk)) then
            --if (Load_calc_reg = '1') then
              --result_r <= result_nxt;
            --end if;
        --end if;
    --end process;


    process(base_r, result_r, exp_r, mod_r) 
        variable is_exp_one : std_logic;
    begin
        is_exp_one := exp_r(0);

        if (is_exp_one = '1') then
            if (to_integer(unsigned(base_r)) = 0 or to_integer(unsigned(result_r)) = 0 or to_integer(unsigned(mod_r)) = 0 ) then
                result_nxt <= (others => '0');
            else
                result_nxt <= std_logic_vector( ((unsigned(base_r)) * (unsigned(result_r)) mod (unsigned(mod_r)) ));
            end if;

        else
            result_nxt <= result_r;
        end if;
    end process;
--

    load_out: process(result_r, Load_out_reg) begin
        if (Load_out_reg = '1') then
           Result <= result_r;
        else 
           Result <= (others => '0');
        end if;
    end process;

end Behavioral;