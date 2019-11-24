library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.state_type_pakage.all;

entity mod_exp is
    Port ( M, e, n : in STD_LOGIC_VECTOR (255 downto 0);
           C : out STD_LOGIC_VECTOR (255 downto 0);
           clk, reset_n : in STD_LOGIC;
           mod_exp_out_ready, mod_exp_in_valid : in STD_LOGIC;
           mod_exp_in_ready, mod_exp_out_valid : out STD_LOGIC);
end mod_exp;

architecture Behavioral of mod_exp is

signal data_out_valid : std_logic;

signal mod_prod_MM_data_in_ready : std_logic;
signal mod_prod_CM_data_in_ready : std_logic;
signal mod_prod_MM_data_out_valid : std_logic;
signal mod_prod_CM_data_out_valid : std_logic;
signal e_reg_control_logic        : std_logic_vector(255 downto 0);
signal state : state_type;
signal sub_state : sub_state_type;

begin

mod_exp_datapath: entity work.mod_exp_datapath port map(
    clk     => clk,
    reset_n => reset_n,
    M       => M,
    e       => e,
    n       => n,
    C       => C,
    data_out_valid => data_out_valid,
    state      => state,
    sub_state  => sub_state,
    mod_prod_MM_data_in_ready    => mod_prod_MM_data_in_ready,
    mod_prod_CM_data_in_ready    => mod_prod_CM_data_in_ready,
    mod_prod_MM_data_out_valid   => mod_prod_MM_data_out_valid,
    mod_prod_CM_data_out_valid   => mod_prod_CM_data_out_valid,
    e_reg_control_logic          => e_reg_control_logic
);

mod_exp_controller: entity work.mod_exp_controller port map(
    clk               => clk,
    reset_n           => reset_n,
    mod_exp_out_ready => mod_exp_out_ready,
    mod_exp_in_valid  => mod_exp_in_valid,
    mod_exp_in_ready  => mod_exp_in_ready,
    mod_exp_out_valid => data_out_valid,
    state      => state,
    sub_state  => sub_state,
    mod_prod_MM_data_in_ready    => mod_prod_MM_data_in_ready,
    mod_prod_CM_data_in_ready    => mod_prod_CM_data_in_ready,
    mod_prod_MM_data_out_valid   => mod_prod_MM_data_out_valid,
    mod_prod_CM_data_out_valid   => mod_prod_CM_data_out_valid,
    e_reg_control_logic          => e_reg_control_logic
);

mod_exp_out_valid <= data_out_valid;

end Behavioral;
