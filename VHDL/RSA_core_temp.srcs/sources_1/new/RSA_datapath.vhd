----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2019 19:33:14
-- Design Name: 
-- Module Name: RSA_datapath - Behavioral
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

entity RSA_datapath is
    Port ( 
           --clock and reset
           clk :  in std_logic;
           reset_n : in std_logic;
           
           --DATA
           msgin_data : in STD_LOGIC_VECTOR (255 downto 0);
           key_e : in STD_LOGIC_VECTOR (255 downto 0);
           key_n : in STD_LOGIC_VECTOR (255 downto 0);
           msgout_data : out STD_LOGIC_VECTOR (255 downto 0);
           
           --Control_signal from RSA_control
           input_valid : in std_logic;
           input_ready : out std_logic;
           output_valid : out std_logic;
           output_ready : in std_logic;
           initial_start: in std_logic;
           e_idx_bit : in std_logic;
           right_to_left_data_out_valid : in std_logic
           
         );
           
end RSA_datapath;

architecture Behavioral of RSA_datapath is
        --intermediate signals
        signal dummy_256bit : std_logic_vector (255 downto 0);
        signal first_mod_out : std_logic_vector (255 downto 0);
        signal mod_exp_out: std_logic_vector (255 downto 0);
        signal mod_prod_out: std_logic_vector(255 downto 0);
        --register
        signal msg_r_nxt, msg_r: std_logic_vector (255 downto 0);
        signal result_r_nxt, result_r: std_logic_vector (255 downto 0);
        
begin
    --this dummy bits needs for the input of the first modular operation
    dummy_256bit <= x"0000000000000000000000000000000000000000000000000000000000000001";
    
    --first modular operation to inizialize the for loop
    first_mod : entity work.mod_prod_blakley(Behavioral) port map(
        
        --clock and reset
        clk        => clk,
        reset_n    => reset_n,
        --DATA input
        A               => msgin_data,
        B               => dummy_256bit,
        n               => key_n,
        C               => first_mod_out,
        
        --control input/output
        input_valid     => input_valid,
        input_ready     => input_ready,
        output_ready    => output_ready,
        output_valid    => output_valid
        
        
    );
    
    --Selecting first or other modular operation and
    --refresh msg_register
    first_mux: process(first_mod_out, mod_exp_out,initial_start) begin
        if (initial_start = '1') then
            msg_r_nxt <= mod_exp_out;
        else
            msg_r_nxt <= first_mod_out;
        end if;
     end process;
                   
    msg_register: process(clk,reset_n) begin
        if(reset_n = '0') then
            msg_r <= (others => '0');
                     
        elsif(rising_edge(clk)) then
            msg_r <= msg_r_nxt;
        end if;            
    end process;
    
    --Modular Exp
    modular_exp: entity work.mod_prod_blakley(Behavioral) port map(
           
        --clock and reset
        clk        => clk,
        reset_n    => reset_n,
        --DATA input/output
        A               => msg_r,
        B               => msg_r,
        n               => key_n,
        C               => mod_exp_out,
        --control input/output
        input_valid     => input_valid,
        input_ready     => input_ready,
        output_ready    => output_ready,
        output_valid    => output_valid
    );
    
    --Modular Product
    modular_prod: entity work.mod_prod_blakley(Behavioral) port map(
           
        --clock and reset
        clk        => clk,
        reset_n    => reset_n,
        --DATA input/output
        A               => msg_r,
        B               => result_r,
        n               => key_n,
        C               => mod_prod_out,
        --control input/output
        input_valid     => input_valid,
        input_ready     => input_ready,
        output_ready    => output_ready,
        output_valid    => output_valid
    );
    
    --result register, selecting if (e(i) == 1) 
    --e_idx_bit <= key_e(to_integer(unsigned(e_idx_cntr)));
ei_mux : process(e_idx_bit) begin
    if(e_idx_bit = '1') then
        result_r_nxt <= mod_prod_out;
    else
        result_r_nxt <= result_r;
    end if;
end process;
    
    result_register: process(clk, reset_n) begin
        if(reset_n ='0') then
            result_r <= result_r_nxt;
        elsif(rising_edge(clk)) then
            result_r  <= result_r_nxt;
        end if;
    end process;
    
    --data out
    data_out: process(result_r, right_to_left_data_out_valid) begin
        if right_to_left_data_out_valid = '0' then
            msgout_data <= result_r;
        else
            msgout_data <= (others => '0');
        end if;
    end process; 
    
end Behavioral;
