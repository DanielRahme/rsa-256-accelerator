library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mod_exp_tb is
--  Port ( );
end mod_exp_tb;

architecture Behavioral of mod_exp_tb is

 signal M, e, n :      STD_LOGIC_VECTOR (255 downto 0);
 signal C :            STD_LOGIC_VECTOR (255 downto 0);
 signal clk, reset_n : STD_LOGIC;
 signal mod_exp_out_ready, mod_exp_in_valid :  STD_LOGIC;
 signal mod_exp_in_ready, mod_exp_out_valid :  STD_LOGIC;

begin

-- needs to be updated to fit the actual mod_exp
mod_ex: entity work.mod_exp port map(
    M       => M,
    e       => e,
    n       => n,
    C       => C,
    clk     => clk,
    reset_n => reset_n,
    mod_exp_out_ready => mod_exp_out_ready,
    mod_exp_in_valid  => mod_exp_in_valid,
    mod_exp_in_ready  => mod_exp_in_ready,
    mod_exp_out_valid => mod_exp_out_valid
);
M <= (255 downto 15 => '0') & "111100111111101";
e <= (255 downto 15 => '0') & "111000000111111";
n <= (255 downto 15 => '0') & "010100101010101";
-- generate a clock
clock: process begin 
clk <= '1'; wait for 50ns;
clk <= '0'; wait for 50ns;
end process;

reset_test: process begin
reset_n <= '0'; wait for 1000ns;
reset_n <= '1'; wait for 10us;
reset_n <= '0'; wait for 100ns;
reset_n <= '1'; wait;
end process;

--reset_n <= '1';

end Behavioral;
