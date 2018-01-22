----------------------------------------------------------------------------------------------------------------------------------------------------------
-- TEST BENCH DE CONTADOR 100 MS
-- Se trata del test bench proporcionado por los profesores en Moodle.
----------------------------------------------------------------------------------------------------------------------------------------------------------

library STD;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
 
entity contador_100ms_tb is
end contador_100ms_tb;
 
architecture behavior of contador_100ms_tb is 

    constant clk_period     : time :=  20 ns;         -- 50Mhz
    constant rst_pulse      : time := 500 ns;
	 
	 component contador_100ms is
    Port ( clk       : in  STD_LOGIC;        -- señal de reloj 
	        rst_cnt   : in STD_LOGIC;         -- reset del contador
	        en_cnt    : in STD_LOGIC;         -- enable 
           cnt_100ms : out  STD_LOGIC );     -- fin de cuenta
    end component;

    
    -- 1. Inputs    
    signal rst                  : std_logic;
    signal clk                  : std_logic;
    signal enable_cnt           : std_logic;

    -- 2. Outputs    
    signal end_count_100ms      : std_logic;

    -- 3. Constants
    constant c_1us              : integer := 50;        -- Timing:  1 us = 50 x 20ns;

	
begin

    contador : entity work.contador_100ms
        port map    (  
            clk                 => clk,
            rst_cnt             => rst,
	         en_cnt              => enable_cnt, 
            cnt_100ms           => end_count_100ms );    
                 

				 
    -- clk process 
    clk_process : process
    begin
        clk <= '1', '0' after clk_period/2;     -- (clk_pulse = 20 ns)
        wait for clk_period;
    end process clk_process;

    -- reset process
    rst_process : process
    begin
        rst <= '1', '0' after rst_pulse;        -- (rst_pulse = 500 ns)      
        wait;
    end process;

	
	
    p_send : process
    begin
        enable_cnt <= '0';                           -- initialization
        wait for   2*c_1us*clk_period;               -- wait (2us)

        enable_cnt <= '1';                           
        wait for   5*c_1us*clk_period;               -- count (5us) => 500 Tclks

        enable_cnt <= '0';                           
        wait for   1*c_1us*clk_period;               -- wait (1us)
        
        enable_cnt <= '1';                           
        wait for 105*1000*c_1us*clk_period;          -- count 105ms (must generate 1 output pulse) 

        enable_cnt <= '0';                           -- stop & end
	    wait;
    end process p_send;

end behavior;