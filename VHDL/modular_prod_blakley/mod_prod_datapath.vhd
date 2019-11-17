library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity mod_prod_datapath is
    Port ( 
            -- Inputs
            reset_n         : in std_logic;
            clk             : in std_logic;
            A               : in std_logic_vector (255 downto 0);
            B               : in std_logic_vector (255 downto 0);
            n               : in std_logic_vector (255 downto 0);
            in_reg_enable   : in std_logic;
            out_reg_enable  : in std_logic;
            calc_enable     : in std_logic;
            -- Outputs
            C               : out std_logic_vector (255 downto 0)
         );
end mod_prod_datapath;

architecture Blakley of mod_prod_datapath is
    -- Registers for input
    signal A_r              :std_logic_vector(255 downto 0);
    signal B_r              :std_logic_vector(255 downto 0);
    signal n_r              :std_logic_vector(255 downto 0);

    -- Register that stores the result for each iteration
    signal R_r, R_nxt       :std_logic_vector(256 downto 0);

    signal a_bit            : std_logic := '0';
    signal a_idx_cntr       : unsigned(7 downto 0);


begin

    load_in: process(clk, reset_n) begin
        if (reset_n = '0') then
            A_r <= (others => '0');
            B_r <= (others => '0');
            n_r <= (others => '0');
        
        elsif (rising_edge(clk)) then
            if (in_reg_enable = '1') then
                A_r <= A;
                B_r <= B;
                n_r <= n;
            end if;
        end if;
    end process;

    -- The bit-selector of A input
    a_bit <= A_r(to_integer(unsigned(a_idx_cntr)));

    A_idx_counter: process(clk, reset_n) begin
        if (reset_n = '0' or in_reg_enable = '1') then
                a_idx_cntr <= to_unsigned(255, a_idx_cntr'length);
                
        elsif (rising_edge(clk)) then
            if (calc_enable = '1') then
                a_idx_cntr <= a_idx_cntr - 1;
            end if;
        end if;
    end process;


    calc: process(A_r, B_r, R_r, a_bit, n_r) 
        variable a_mul_b            : std_logic_vector(256 downto 0); -- +carry
        variable r_add_r            : std_logic_vector(256 downto 0); -- +carry
        variable R_1                : std_logic_vector(256 downto 0); -- +carry

        variable reduce_once        : std_logic_vector(256 downto 0); -- +carry
        variable reduce_twice       : std_logic_vector(256 downto 0); -- +carry
    begin

        -- First calculation: R = 2R + A_bit * B
        if (a_bit = '1') then
            a_mul_b := '0' & B_r;
        else
            a_mul_b := (others => '0');
        end if;

        r_add_r := R_r + R_r;
        R_1 := r_add_r + a_mul_b;

        -- Modulus part: R = R mod n
        reduce_once := R_1 - n_r;
        reduce_twice := R_1 - n_r - n_r;

        if (R_1 > (n_r + n_r)) then
            R_nxt <= reduce_twice;
        elsif (R_1 > n_r) then
            R_nxt <= reduce_once;
        else
            R_nxt <= R_1;
        end if;
    end process;

    R_reg: process(clk, reset_n) begin
        if (reset_n = '0' or in_reg_enable = '1') then 
            R_r <= (others => '0');

        elsif (rising_edge(clk)) then
            if (calc_enable = '1') then
                R_r <= R_nxt;
            end if;
        end if;
    end process;

    --result_reg: process (clk, reset_n) begin
        --if (reset_n = '0') then
            --C <= (others => '0');

        --elsif (rising_edge(clk)) then
            --if (out_reg_enable = '1') then
                --C <= R_r(255 downto 0);
            --end if;
        --end if;
    --end process;


    process (R_r, out_reg_enable) begin
        if (out_reg_enable = '1') then
            C <= R_r(255 downto 0);
        else
            C <= (others => '0');
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
architecture simple of mod_prod_datapath is
begin
    C <= std_logic_vector( ((unsigned(A)) * (unsigned(B)) mod (unsigned(n)) ));
end simple;