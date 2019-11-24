library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mod_exp is
    Port ( M, e, n : in STD_LOGIC_VECTOR (255 downto 0);
           C : out STD_LOGIC_VECTOR (255 downto 0);
           clk, reset_n : in STD_LOGIC;
           mod_exp_out_ready, mod_exp_in_valid : in STD_LOGIC;
           mod_exp_in_ready, mod_exp_out_valid : out STD_LOGIC);
end mod_exp;

architecture Behavioral of mod_exp is

signal data_out_valid : std_logic;

begin

mod_exp_datapath: entity work.mod_exp_datapath port map(
    clk     => clk,
    reset_n => reset_n,
    M       => M,
    e       => e,
    n       => n,
    C       => C,
    data_out_valid => data_out_valid
);

mod_exp_controller: entity work.mod_exp_controller port map(
    clk               => clk,
    reset_n           => reset_n,
    mod_exp_out_ready => mod_exp_out_ready,
    mod_exp_in_valid  => mod_exp_in_valid,
    mod_exp_in_ready  => mod_exp_in_ready,
    mod_exp_out_valid => data_out_valid
);

mod_exp_out_valid <= data_out_valid;

end Behavioral;
