
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mod_prod is
    Port (
           reset_n      : in std_logic;
           clk          : in std_logic;
           A            : in std_logic_vector (255 downto 0);
           B            : in std_logic_vector (255 downto 0);
           n            : in std_logic_vector (255 downto 0);
           input_valid  : in std_logic;
           input_ready  : out std_logic;

           output_ready : in std_logic;
           output_valid : out std_logic;
           C            : out std_logic_vector (255 downto 0)
           );
end mod_prod;

architecture Blakley of mod_prod is
    signal in_reg_enable : std_logic;
    signal out_reg_enable : std_logic;
    signal calc_enable : std_logic;
    signal calc_done : std_logic;
begin

    -- Instatiate controller module
    u_mod_prod_controller: entity work.mod_prod_controller(Blakley) port map (
        reset_n => reset_n,
        clk => clk,
        input_valid => input_valid,
        input_ready => input_ready,
        output_ready => output_ready,
        output_valid => output_valid,

        -- Control singals to datapath
        calc_enable => calc_enable,
        in_reg_enable => in_reg_enable,
        calc_done => calc_done,
        out_reg_enable => out_reg_enable
    );

    -- Instatiate datapath module
    u_mod_prod_datapath: entity work.mod_prod_datapath(Blakley) port map (
        reset_n => reset_n,
        clk => clk,

        -- The data
        A => A,
        B => B,
        C => C,
        n => n,

        -- Control singals
        in_reg_enable => in_reg_enable,
        out_reg_enable => out_reg_enable,
        calc_done => calc_done,
        calc_enable => calc_enable
    );

end Blakley;


--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
-- Simple straight forward implementation
--------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
--architecture simple of mod_prod is
--    signal in_reg_enable : std_logic;
--    signal out_reg_enable : std_logic;
--    signal calc_enable : std_logic;
--
--begin
--
--    -- Instatiate controller module
--    u_simple_controller: entity work.mod\_prod_controller(simple) 
--    port map (
--        reset_n => reset_n,
--        clk => clk,
--        input_valid => input_valid,
--        input_ready => input_ready,
--        output_ready => output_ready,
--        output_valid => output_valid,
--
--        -- Control singals to datapath
--        in_reg_enable => in_reg_enable,
--        out_reg_enable => out_reg_enable,
--        calc_enable => calc_enable
--    );
--
--
--
--    -- Instatiate datapath module
--    u_simple_datapath: entity work.mod\_prod_datapath(simple) 
--    port map (
--        reset_n => reset_n,
--        clk => clk,
--
--        -- The data
--        A => A,
--        B => B,
--        C => C,
--        n => n,
--
--        -- Control singals
--        in_reg_enable => in_reg_enable,
--        out_reg_enable => out_reg_enable,
--        calc_enable => calc_enable
--    );
--
--end simple;