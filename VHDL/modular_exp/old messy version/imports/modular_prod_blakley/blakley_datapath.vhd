----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 19:34:10
-- Design Name: 
-- Module Name: blakley_datapath - Behavioral
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

entity blakley_datapath is
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
end blakley_datapath;

architecture Behavioral of blakley_datapath is
    signal sum1             : std_logic_vector(255 downto 0); -- NO CARRY
    signal p_r, p_r_nxt     : std_logic_vector(255 downto 0);
    signal b_idx_bit        : std_logic;
    signal b_idx_cntr       : unsigned(7 downto 0);

    signal A_r              :std_logic_vector(255 downto 0);
    signal B_r              :std_logic_vector(255 downto 0);
    signal n_r              :std_logic_vector(255 downto 0);

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

    -- The bit-selector of B input
    b_idx_bit <= B_r(to_integer(unsigned(b_idx_cntr)));

    B_idx_counter: process(clk, reset_n) begin
        if (reset_n = '0') then
            b_idx_cntr <= (others => '0');

        elsif (rising_edge(clk)) then
            b_idx_cntr <= b_idx_cntr + 1;
        end if;
    end process;


    -- Addition: A + 2P
    sum: process(A_r, b_idx_bit, p_r) begin
        if (b_idx_bit = '1') then -- if calc enable
            sum1 <= std_logic_vector(unsigned(A_r) + unsigned((p_r(254 downto 0) & '0'))); -- A + 2*p

        else
            sum1 <= (p_r(254 downto 0) & '0'); -- 2*p
        end if;
    end process;

    p_register: process(clk, reset_n) begin
        if (reset_n = '0') then 
            p_r <= (others => '0');

        elsif (rising_edge(clk)) then
            --if (calc_enable = '1') then
                p_r <= p_r_nxt;
            --end if;
        end if;
    end process;


    -- Modulus by subtraction. Maximum 2 subtractions needed
    -- If sum > n then no modulus
    -- If sum < n then sum - n
    -- If sum < 2n then sum - 2n (NOT conditionally checked)
    modulus: process(sum1, n) begin
        if (sum1 > n_r) then 
            p_r_nxt <= sum1;

        elsif (sum1 < n_r) then
            p_r_nxt <= std_logic_vector(unsigned(sum1) - unsigned(n_r));

        else
            p_r_nxt <= sum1 - (n_r(254 downto 0) & '0'); -- p_next <= sum - 2n
        end if;
    end process;

    result_reg: process (clk, reset_n) begin
        if (reset_n = '0') then
            C <= (others => '0');

        elsif (rising_edge(clk)) then
            if (out_reg_enable = '1') then
                C <= p_r_nxt;
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
architecture simple of blakley_datapath is
begin
    C <= std_logic_vector( ((unsigned(A)) * (unsigned(B)) mod (unsigned(n)) ));
end simple;