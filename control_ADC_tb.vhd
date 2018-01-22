--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL ADC
--------------------------------------------------------------------------------
library STD;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
 
ENTITY control_ADC_tb IS
END control_ADC_tb;
 
ARCHITECTURE behavior OF control_ADC_tb IS
 
    COMPONENT control_ADC
    PORT(clk : IN  std_logic;        -- señal de reloj 
         Rst : IN  std_logic;        -- señal de reset
         start_ADC : IN  std_logic;	-- señal que habilita el módulo
         DOUT : IN  std_logic;	-- señal serie que se recibe desde el ADC
         end_ADC : OUT  std_logic;	-- señal que da por terminado la operación del módulo
         CS0 : OUT  std_logic;	--  señal de control para el ADC
         SCLK : OUT  std_logic;	-- señal de control para el ADC
         DIN : OUT  std_logic;	-- señal de petición par el ADC
         valor_ADC : OUT  std_logic_vector(11 downto 0));	-- último valor binario completo recibido desde el ADC
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_ADC : std_logic := '0';
   signal DOUT : std_logic := '0';

 	--Outputs
   signal end_ADC : std_logic;
   signal CS0 : std_logic;
   signal SCLK : std_logic;
   signal DIN : std_logic;
   signal valor_ADC : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;         -- 50Mhz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   unit_control_ADC: control_ADC PORT MAP (
          clk => clk,
          Rst => Rst,
          start_ADC => start_ADC,
          DOUT => DOUT,
          end_ADC => end_ADC,
          CS0 => CS0,
          SCLK => SCLK,
          DIN => DIN,
          valor_ADC => valor_ADC
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

	-- start_ADC process
	start_ADC_process :process
   begin
		start_ADC <= '0';
		wait for 125us;
		start_ADC <= '1';
		wait for 20ns;
		start_ADC <= '0';
   end process;

   -- Stimulus process
   stim_proc: process
   begin	

		-- insert stimulus here 
		DOUT <='0';	-- valor cualquiera inicial
		rst<='1';	-- se ponen todas las señales a 0
		wait for 500 ns;
		rst <='0';	-- a la espera de start_ADC para empezar el proceso
		wait for 143 us;
		DOUT <='1';	-- se van metiendo valores a DOUT
		wait for 2 us;	-- 2 us es el valor del periodo de SCLK
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait;	
   end process;

END;