--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DAC
--------------------------------------------------------------------------------
library STD;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

ENTITY control_DAC_tb IS
END control_DAC_tb;
 
ARCHITECTURE behavior OF control_DAC_tb IS 
 
    COMPONENT control_DAC
    PORT(clk : IN  std_logic;	-- señal de reloj
         Rst : IN  std_logic;	-- señal de reset
         start_DAC : IN  std_logic;	-- señal que habilita el módulo
         valor_DAC : IN  std_logic_vector(11 downto 0);	-- valor binario a enviar al DAC
         end_DAC : OUT  std_logic;		-- señal que da por terminado la operación del módulo
         CS1 : OUT  std_logic;	--  señal de control para el DAC
         SCLK : OUT  std_logic;	-- señal de control para el DAC
         DIN : OUT  std_logic);	 -- dato que se envía al DAC
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_DAC : std_logic := '0';
   signal valor_DAC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_DAC : std_logic;
   signal CS1 : std_logic;
   signal SCLK : std_logic;
   signal DIN : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;         -- 50Mhz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_DAC PORT MAP (
          clk => clk,
          Rst => Rst,
          start_DAC => start_DAC,
          valor_DAC => valor_DAC,
          end_DAC => end_DAC,
          CS1 => CS1,
          SCLK => SCLK,
          DIN => DIN
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	-- start_DAC process
	start_DAC_process :process
   begin
		start_DAC <= '0';
		wait for 125us;
		start_DAC <= '1';
		wait for 20ns;
		start_DAC <= '0';
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		

      -- insert stimulus here 
		valor_DAC <="111100001111";	-- un valor inicial cualquiera a observar
		rst<='1';	-- se ponen todas las señales a 0
		wait for 500 ns;
		rst <='0';	-- a la espera de start_DAC para empezar el proceso
		wait for 143 us;
		valor_DAC <="101010101011";	-- otro valor cualquiera a observar
      wait;
   end process;

END;