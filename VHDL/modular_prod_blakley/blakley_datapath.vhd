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
            reset_n : in std_logic;
            clk : in std_logic;
            A : in std_logic_vector (255 downto 0);
            B : in std_logic_vector (255 downto 0);
            n : in std_logic_vector (255 downto 0);
            C : out std_logic_vector (255 downto 0);
            in_reg_enable : in std_logic;
            out_reg_enable : in std_logic;
            calc_enable : in std_logic;
            B_bit_index : in std_logic_vector (7 downto 0));
end blakley_datapath;

architecture Behavioral of blakley_datapath is
    signal sum1 : std_logic_vector(255 downto 0); -- NO CARRY
    signal p_r, p_r_nxt  : std_logic_vector(255 downto 0);
    signal B_idx : std_logic;


begin
    B_idx <= B(to_integer(unsigned(B_bit_index)));

    process(A, B_idx, p_r) begin
        if (B_idx = '1') then
            sum1 <= std_logic_vector(unsigned(A) + unsigned((p_r(254 downto 0) & '0'))); -- A + 2*p
        else
            sum1 <= (p_r(254 downto 0) & '0'); -- 2*p
        end if;
    end process;

    p_register : process(clk, reset_n) begin
        if (reset_n = '0') then 
            p_r <= (others => '0');

        elsif (rising_edge(clk)) then
            --if (out_reg_enable = '1') then
                p_r <= p_r_nxt;
            --end if;
        end if;
    end process;


    comparator : process(sum1, n) begin
        if (sum1 > n) then 
            p_r_nxt <= sum1;

        elsif (sum1 < n) then
            p_r_nxt <= std_logic_vector(unsigned(sum1) - unsigned(n));

        else
            p_r_nxt <= sum1 - (n(254 downto 0) & '0');
        end if;
    end process;

    C <= p_r_nxt;

end Behavioral;
