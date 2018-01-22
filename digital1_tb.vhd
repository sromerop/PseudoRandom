----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Name:    tb_digital1
-- Project Name:   CELT 2015-2016
-- Target Device:  Basys2 
--
-- Description:    testbench for component digital1.vhd
-- Version: v1.0
----------------------------------------------------------------------------------------------------------------------------------------------------------

library STD;
use std.textio.all;

library ieee;                                  -- INCLUIR ESTAS LIBRERIAS EN TODOS LOS FICHEROS VHDL
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
 
entity digital1_tb is
--        
end digital1_tb;
 
architecture behavior of digital1_tb is 

    constant clk_period     : time := 20 ns;         -- 50Mhz
    constant rst_pulse      : time := 5 us;

    component digital1 is
    Port (  Rst : in  STD_LOGIC;                   -- Reset para el registro Reg_f (switch 0)
            clk   : in  STD_LOGIC;                   -- Reloj de la FPGA
			
            Up0 : in  STD_LOGIC;                   -- Pulsador 0
            Down0: in  STD_LOGIC;                   -- Pulsador 1
            Up1 : in  STD_LOGIC;                   -- Pulsador 2
            Down1 : in  STD_LOGIC;                   -- Pulsador 3
			
            Disp0 : out  STD_LOGIC;                  -- Salida para activar display 1  
            Disp1 : out  STD_LOGIC;                  -- Salida para activar display 2
            Disp2 : out  STD_LOGIC;                  -- Salida para activar display 3 
            Disp3 : out  STD_LOGIC;                -- Salida para activar display 4 
				Seg7  : out  STD_LOGIC_VECTOR (6 downto 0));  -- Salida de 7 segmentos para los displays
    end component;

    
    -- 1. Inputs    
    signal rst                  : std_logic := '0';
    signal clk                  : std_logic := '0';
    signal pulsadores           : std_logic_vector(3 downto 0);

    -- 2. Outputs
    signal seg_7                : std_logic_vector(6 downto 0);
    signal disp_1               : std_logic;
    signal disp_2               : std_logic;
    signal disp_3               : std_logic;
    signal disp_4               : std_logic;

    -- 3. Constants
    constant c_100ms            : integer := 5000000;
    constant c_5ms              : integer :=  250000;

	
begin

----- *** DESCOMENTAR PARA SIMULAR EL COMPONENTE 'digital1' ***
unit_digital1 : entity work.digital1
       port map    (  
           Rst                 => rst,
           clk                 => clk,
           Up0                 => pulsadores(0),
           Down0               => pulsadores(1),
           Up1                 => pulsadores(2),
           Down1               => pulsadores(3),
           Seg7                => seg_7,
           Disp0               => disp_1,
           Disp1               => disp_2,
           Disp2               => disp_3,
           Disp3               => disp_4
       );    

				 
    -- clk process 
    clk_process : process
    begin
        clk <= '1', '0' after clk_period/2;     -- (clk_pulse = 20 ns)
        wait for clk_period;
    end process clk_process;

    -- reset process
    rst_process : process
    begin
        rst <= '1', '0' after rst_pulse;        -- (rst_pulse = 5 ms)      
        wait;
    end process;

	
	
    p_send : process
    begin
        pulsadores <= "0000";
        wait for   2*c_100ms*clk_period;             -- wait 200ms         

        pulsadores <= "0001";                        -- glitch
        wait for       c_5ms*clk_period;             -- glitch (5ms)
        pulsadores <= "0000";                        -- nothing
        wait for   3*c_100ms*clk_period;             -- wait 300ms
        
	     pulsadores <= "0001";                        -- up0
        wait for  3*c_100ms*clk_period;             -- add 1 for 300 ms (+1)
        pulsadores <= "0010";                        -- down0
        wait for 3*c_100ms*clk_period;             -- subtract 1 for 300 ms (-1)
			
        pulsadores <= "0100";                        -- down1
        wait for  3*c_100ms*clk_period;             -- subtract 10 for 300 ms (+10)
        pulsadores <= "1000";                        -- up1
        wait for 3*c_100ms*clk_period;             -- add 10 for 300 ms (-10)
			
	     wait;
    end process p_send;

end behavior;