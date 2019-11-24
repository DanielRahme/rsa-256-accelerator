-- mod exp , Vetle
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_exp_datapath is
    Port ( M, n, e: in STD_LOGIC_VECTOR (255 downto 0);
           C : out STD_LOGIC_VECTOR (255 downto 0);
           e0 : out STD_LOGIC;
           init : in STD_LOGIC;
           calculate : in STD_LOGIC;
           mod_prod_out_ready : in STD_LOGIC;
           mod_prod_MM_out_valid : out STD_LOGIC;
           clk, reset_n : in STD_LOGIC);
end mod_exp_datapath;

architecture Behavioral_v2 of mod_exp_datapath is

signal M_reg, C_reg, n_reg : std_logic_vector (255 downto 0);
signal e_reg : std_logic_vector (256 downto 0);

signal mod_prod_MM_data_out_valid : std_logic;
signal mod_prod_CM_data_out_valid : std_logic;
signal mod_prod_MM_data_in_ready  : std_logic;
signal mod_prod_CM_data_in_ready  : std_logic;
signal mod_prod_MM_data_out_ready : std_logic;
signal mod_prod_CM_data_out_ready : std_logic;
signal mod_prod_MM_data_in_valid  : std_logic;
signal mod_prod_CM_data_in_valid  : std_logic;

signal mod_prod_MM_result : std_logic_vector (255 downto 0);
signal mod_prod_CM_result : std_logic_vector (255 downto 0);
signal mod_prod_MM_A : std_logic_vector (255 downto 0);
signal mod_prod_CM_A : std_logic_vector (255 downto 0);
signal mod_prod_MM_B : std_logic_vector (255 downto 0);
signal mod_prod_CM_B : std_logic_vector (255 downto 0);

begin

mod_prod_MM: entity work.mod_prod(blakley) port map(
    clk     => clk,
    reset_n => reset_n,
    A       => mod_prod_MM_A,
    B       => mod_prod_MM_B,
    n       => n_reg,
    C       => mod_prod_MM_result,
    input_valid => mod_prod_MM_data_in_valid,
    input_ready => mod_prod_MM_data_in_ready,
    output_valid => mod_prod_MM_data_out_valid,
    output_ready => mod_prod_MM_data_out_ready
);


mod_prod_CM: entity work.mod_prod(blakley) port map(
    clk     => clk,
    reset_n => reset_n,
    A       => mod_prod_CM_A,
    B       => mod_prod_CM_B,
    n       => n_reg,
    C  => mod_prod_CM_result,
    input_valid => mod_prod_CM_data_in_valid,
    input_ready => mod_prod_CM_data_in_ready,
    output_valid => mod_prod_CM_data_out_valid,
    output_ready => mod_prod_CM_data_out_ready
);

mod_prod_MM_data_out_ready <= mod_prod_out_ready; 
mod_prod_CM_data_out_ready <= mod_prod_out_ready;
mod_prod_MM_out_valid <= mod_prod_MM_data_out_valid;
C <= C_reg;
n_reg <= n;
e0 <= or_reduce(e_reg);

MM_in : process(reset_n,init,mod_prod_MM_data_in_ready,calculate) begin
    if reset_n = '0' then
        mod_prod_MM_A <= (255 downto 0 => '0');
        mod_prod_MM_B <= (255 downto 0 => '0');
        mod_prod_MM_data_in_valid <= '0';
    end if;     
    if calculate = '1' and init = '1'  then
        mod_prod_MM_data_in_valid <= '1';
        mod_prod_MM_A <= M_reg;
        mod_prod_MM_B <= (255 downto 1 => '0') & '1';
    elsif calculate = '1' and init = '0'  then
        mod_prod_MM_data_in_valid <= '1';
        mod_prod_MM_A <= M_reg;
        mod_prod_MM_B <= M_reg;
    else
        mod_prod_MM_data_in_valid <= '0';
        mod_prod_MM_A <= (255 downto 0 => '0');
        mod_prod_MM_B <= (255 downto 0 => '0');
    end if;
end process;

CM_in : process(reset_n,mod_prod_CM_data_in_ready,calculate) begin
    if reset_n = '0' then
        mod_prod_CM_A <= (255 downto 0 => '0');
        mod_prod_CM_B <= (255 downto 0 => '0');
    end if;
    if calculate = '1' then
        mod_prod_CM_data_in_valid <= '1';
        mod_prod_CM_A <= M_reg;
        mod_prod_CM_B <= C_reg;
    else
        mod_prod_CM_data_in_valid <= '0';
        mod_prod_CM_A <= (255 downto 0 => '0');
        mod_prod_CM_B <= (255 downto 0 => '0');
    end if;

end process;

MM_out : process (reset_n,clk) begin
    if reset_n = '0' then
        M_reg <= (255 downto 0 => '0');
    end if;
    if rising_edge(clk) then
        if init = '1' and mod_prod_MM_data_out_valid = '0' then
            M_reg <= M;
        elsif init = '1' and mod_prod_MM_data_out_valid = '1' then
            M_reg <= mod_prod_MM_result;
        elsif init = '0' and mod_prod_MM_data_out_valid = '1' then
            M_reg <= mod_prod_MM_result;
        else
            M_reg <= M_reg;
        end if;
    end if;
end process;

CM_out : process (reset_n,clk) begin
    if reset_n = '0' then
        C_reg <= (255 downto 1 => '0') & '1';
    end if;
    if rising_edge(clk) then
        if init = '1' then
            C_reg <= (255 downto 1 => '0') & '1';
        elsif mod_prod_CM_data_out_valid = '1' and e_reg(0) = '1'then
            C_reg <= mod_prod_CM_result;
        else
            C_reg <= C_reg;
        end if;
    end if;
end process;

exponent : process (reset_n,clk) begin
    if reset_n = '0' then
        e_reg <= (256 downto 0 => '0');
    elsif rising_edge(clk) then
        if init = '1' then
            e_reg <= e & '0';
        elsif init = '0' and mod_prod_MM_data_in_ready = '1' and mod_prod_MM_data_in_valid = '1'  then
            e_reg <= '0' & e_reg(256 downto 1); 
        end if;
    end if;
end process; 

--mod_prod_MM_data_in_ready
--mod_prod_MM_data_in_valid

end Behavioral_v2;

--M %= n;
--	for (int i = 0; i < 32; i++){
--		if (e >> i & 1 == 1 ){
--			result = (result*M) % n;
--		}
--	M *= M % n;	
--	}
