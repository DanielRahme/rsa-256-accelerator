-- mod exp , Vetle
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.state_type_pakage.all;

entity mod_exp_datapath is
    Port ( M, e, n : in STD_LOGIC_VECTOR (255 downto 0);
           C : out STD_LOGIC_VECTOR (255 downto 0);
           data_out_valid : in STD_LOGIC;
           clk, reset_n : in STD_LOGIC;
           
           --signal for control logic
           state : in state_type;
           sub_state : in sub_state_type;
           mod_prod_MM_data_in_ready : out std_logic;
           mod_prod_CM_data_in_ready : out std_logic;
           mod_prod_MM_data_out_valid : out std_logic;
           mod_prod_CM_data_out_valid : out std_logic;
           e_reg_control_logic        : out std_logic_vector( 255 downto 0)
           );
end mod_exp_datapath;

architecture Behavioral of mod_exp_datapath is
signal M_reg, e_reg, C_reg, n_reg : std_logic_vector (255 downto 0);
signal mod_prod_data_out_ready    : std_logic;
signal mod_prod_data_in_valid     : std_logic;  

signal mod_prod_MM_result : std_logic_vector (255 downto 0);
signal mod_prod_CM_result : std_logic_vector (255 downto 0);
signal mod_prod_MM_A : std_logic_vector (255 downto 0);
signal mod_prod_CM_A : std_logic_vector (255 downto 0);
signal mod_prod_MM_B : std_logic_vector (255 downto 0);
signal mod_prod_CM_B : std_logic_vector (255 downto 0);
signal prep_complete : std_logic;

begin

mod_prod_MM: entity work.mod_prod_blakley port map(
    clk     => clk,
    reset_n => reset_n,
    A       => mod_prod_MM_A,
    B       => mod_prod_MM_B,
    n       => n_reg,
    C  => mod_prod_MM_result,
    input_valid => mod_prod_data_in_valid,
    input_ready => mod_prod_MM_data_in_ready,
    output_valid => mod_prod_MM_data_out_valid,
    output_ready => mod_prod_data_out_ready
);


mod_prod_CM: entity work.mod_prod_blakley port map(
    clk     => clk,
    reset_n => reset_n,
    A       => mod_prod_CM_A,
    B       => mod_prod_CM_B,
    n       => n_reg,
    C  => mod_prod_CM_result,
    input_valid => mod_prod_data_in_valid,
    input_ready => mod_prod_CM_data_in_ready,
    output_valid => mod_prod_CM_data_out_valid,
    output_ready => mod_prod_data_out_ready
);

process (clk, reset_n) begin
    if reset_n = '0' then
        M_reg <= (others => '0');
        e_reg <= (others => '0');
        C_reg <= (others => '0');
        n_reg <= (255 downto 1 => '0') & '1';
        mod_prod_MM_A <= (others => '0');
        mod_prod_MM_B <= (others => '0');
        mod_prod_CM_A <= (others => '0');
        mod_prod_CM_B <= (others => '0');
    end if;
    if rising_edge(clk) then   
        if state = inital then        
            if sub_state = prepare then
                M_reg <= M;
                e_reg <= e;
                C_reg <= (255 downto 1 => '0') & '1';
                n_reg <= n;
            elsif sub_state = send_to_mod_prod then
                mod_prod_MM_A <= M_reg;
                mod_prod_MM_B <= (255 downto 1 => '0') & '1';
                mod_prod_CM_A <= (255 downto 1 => '0') & '1';
                mod_prod_CM_B <= (255 downto 1 => '0') & '1';
            elsif sub_state = recieve_from_mod_prod then
                M_reg <= mod_prod_MM_result;
            end if;
            
        elsif state = calculating then        
            if  sub_state = prepare then
                             
            elsif sub_state = send_to_mod_prod then
                mod_prod_MM_A <= M_reg;
                mod_prod_MM_B <= M_reg;
                mod_prod_CM_A <= C_reg;
                mod_prod_CM_B <= M_reg;
            elsif sub_state = recieve_from_mod_prod then
                e_reg <= '0' & e_reg(255 downto 1);  
                M_reg <= mod_prod_MM_result;
                if e_reg(0) = '1' then
                C_reg <= mod_prod_CM_result;
                end if;
            end if;
        
        elsif state = finished then        
            C_reg <= C_reg;                                       
        end if;
    end if; 
end process;

        mod_prod_data_in_valid <= '1';
        C <= C_reg;
        e_reg_control_logic <= e_reg;
end Behavioral;

--M %= n;
--	for (int i = 0; i < 32; i++){
--		if (e >> i & 1 == 1 ){
--			result = (result*M) % n;
--		}
--	M *= M % n;	
--	}
