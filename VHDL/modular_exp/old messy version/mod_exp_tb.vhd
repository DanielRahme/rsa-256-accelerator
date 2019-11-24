library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

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
M <= x"1059393059295030105939305929503010593930592950301059393059295030";--x"23026c469918f5ea097f843dc5d5259192f9d3510415841ce834324f4c237ac7";
e <= x"1050395671943674105939305929503010593930592950301059393059295030";--x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9";
n <= x"5000395671999321105939305929503010593930592950301059393059295030";--x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
--(255 downto 10 => '0') & "1110001110";
--std_logic_vector(to_unsigned(666,M'length));
-- generate a clock
clock: process begin 
clk <= '1'; wait for 50ns;
clk <= '0'; wait for 50ns;
end process;

--reset_test: process begin
--reset_n <= '1'; wait for 10us;
--reset_n <= '0'; wait for 200ns;
--reset_n <= '1'; wait;
--end process;
reset_n <= '1';
end Behavioral;
