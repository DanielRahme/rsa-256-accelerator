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
M <= std_logic_vector(to_unsigned(199412312,M'length));--x"23026c469918f5ea097f843dc5d5259192f9d3510415841ce834324f4c237ac7";
e <= std_logic_vector(to_unsigned(2123123123,M'length));--x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9";
n <= std_logic_vector(to_unsigned(1111111122,M'length));--x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
--(255 downto 4 => '0') & "0111";
--(255 downto 10 => '0') & "1110001110";
--std_logic_vector(to_unsigned(666,M'length));
-- generate a clock
clock: process begin 
clk <= '1'; wait for 50ns;
clk <= '0'; wait for 50ns;
end process;


valid: process begin 
mod_exp_in_valid <= '0'; wait for 500ns;
mod_exp_in_valid <= '1'; wait for 500ns;
mod_exp_in_valid <= '0'; wait;
end process;

READY: process begin 
mod_exp_out_ready <= '0';
wait until mod_exp_out_valid = '1';
wait for 500ns;
mod_exp_out_ready <= '1'; wait for 500ns;
mod_exp_out_ready<= '0'; wait;
end process;

reset_n <= '1';
end Behavioral;
