----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 19:00:36
-- Design Name: 
-- Module Name: mod_exp_datapath - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_exp_datapath is
    Port ( M,e,n : in STD_LOGIC_VECTOR (255 downto 0);
           clk,reset_n : in STD_LOGIC;
           data_out_valid: in STD_LOGIC;
           init: in STD_LOGIC;
           C : out STD_LOGIC_VECTOR (255 downto 0));
end mod_exp_datapath;

architecture Behavioral of mod_exp_datapath is
signal M_reg, M_i, e_reg, C_reg : STD_LOGIC_VECTOR (255 downto 0);
signal M_nxt, e_nxt, C_nxt : STD_LOGIC_VECTOR (255 downto 0);

begin

modprod_C : entity work.mod_prod_temp port map(
    A        => M_reg,
    B        => C_reg,
    n        => n,
    mod_prod => C_nxt,
    clk      => clk,
    reset_n  => reset_n);
    
modprod_M : entity work.mod_prod_temp port map(
    A        => M_reg,
    B        => M_i,
    n        => n,
    mod_prod => M_nxt,
    clk      => clk,
    reset_n  => reset_n);
    
es: process (clk,reset_n) begin
    if reset_n = '0' then
        e_reg <= (others => '0');
    end if;
    if rising_edge(clk) then
        if init = '1' then
            e_nxt <= e;
        else
            e_nxt <= '0' & e_reg(255 downto 1);
        end if;
    end if;
end process;


nxt: process (clk,reset_n) begin
    if reset_n = '0' then
        M_nxt <= (others => '0');
        e_nxt <= (others => '0');
        C_nxt <= (others => '0');
    end if;
    if rising_edge(clk) then
        if init = '1' then
            M_reg <= M;
            C_reg <= (255 downto 1 => '0') & '1';
        else
            if e(0) = '1' then
                C_reg <= C_nxt;
            end if;
        M_reg <= M_nxt;
        e_reg <= e_nxt;
        end if;
    end if;
end process;

output: process (clk,reset_n) begin
    if reset_n = '0' then
        C_reg <= (others => '0');
    end if;
    if rising_edge(clk) and (data_out_valid = '1') then
        C <= C_reg;
    end if;
end process;

inital: process(clk) begin
if rising_edge(clk) and (init = '1') then

end if;
end process;

Mi: process (init,M_reg) begin
    if init = '1' then
    M_i <= (255 downto 1 => '0') & '1';
    else 
    M_i <= M_reg;
    end if;
end process;


end Behavioral;
