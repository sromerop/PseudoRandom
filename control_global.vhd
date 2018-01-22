----------------------------------------------------------------------------------
-- CONTROL GLOBAL
-- Es el encargado de gestionar cuándo tiene que comenzar el
-- procesamiento de cada uno de los bloques que dependen de él.
-- Utiliza un protocolo de comunicación asíncrona basado en una
-- señal de inicio y otra señal de fin (cada bloque comenzará su
-- procesamiento cuando haya terminado el bloque inmediatamente anterior).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_global is
    Port ( clk : in  STD_LOGIC;	-- señal de reloj
           Rst : in  STD_LOGIC;	-- señal de reset
           end_ADC : in  STD_LOGIC;		-- señal que da por terminado la operación del módulo ADC
           end_random : in  STD_LOGIC;		-- señal que da por terminado la operación del módulo de encriptación
           end_DAC : in  STD_LOGIC;		-- señal que da por terminado la operación del módulo DAC
           start_ADC : out  STD_LOGIC;	-- señal que habilita el módulo ADC
           start_random : out  STD_LOGIC;	-- señal que habilita el módulo de encriptación
           start_DAC : out  STD_LOGIC;	-- señal que habilita el módulo DAC
           global_st : out  STD_LOGIC_VECTOR (1 downto 0));	-- señal que indica el estado del autómata
end control_global;

architecture Behavioral of control_global is

-- Declaración de las señales necesarias
signal contador : STD_LOGIC_VECTOR (12 downto 0) := "0000000000000";	-- señal que lleva la cuenta para 125 us
signal cnt_125us : STD_LOGIC := '0';	-- señal que indica que han pasado 125 us
signal s_global_st : STD_LOGIC_VECTOR (1 downto 0) := "00";	-- señal que indica el estado del autómata

begin

process (clk)	-- este process cuenta 125 us
	begin
		if clk'event and clk='1' then
			cnt_125us <= '0';
			contador <= contador + '1';
			if contador >= "1100001101010" then -- valor máximo de la cuenta
				cnt_125us <= '1';
				contador <= (others => '0');
			end if;
		end if;
end process;

global_st <= s_global_st;
start_ADC <= cnt_125us;	-- debido a que cada 125 us se pasa al estado 01, activandose start_ADC
				
process(clk, s_global_st, Rst, end_ADC, end_random, end_DAC, cnt_125us)	-- en este process se va cambiando de estado en función de que las entradas avisen de que se acaban los estados anteriores
	begin
		if Rst = '1' then -- Poner a cero las señales
			s_global_st <= "00";
			start_DAC <= '0';
			start_random <= '0';
		
		elsif clk'event and clk='1' then 
			start_DAC <= '0';	-- incialización
			start_random <= '0';	-- incialización

			CASE s_global_st IS
			
				when "00" =>
					
					if (cnt_125us = '0') then
						s_global_st <= "00";
					else	-- si han pasado 125 us, se acaba reposo (01), el estado siguente es ADC (01)
						s_global_st <= "01";
					end if;
				
				when "01" =>
					
					if (end_ADC = '0') then
						s_global_st <= "01";
					else	-- si se acaba ADC (01), el estado siguente es encriptación (11)
						start_random <= '1';
						s_global_st <= "11";
					end if;
				
				when "11" =>
				
					if (end_random = '0') then
						s_global_st <= "11";
					else	-- si se acaba encriptación (11), el estado siguente es DAC (10)
						start_DAC <= '1';
						s_global_st <= "10";
					end if;
					
				when "10" =>
					
					if (end_DAC = '0') then
						s_global_st <= "10";
					else	-- si se acaba DAC (01), el estado siguente es reposo (00)
						s_global_st <= "00";
					end if;
				
				when others => 
					s_global_st <= "00";
						
			END CASE;
		end if;
end process;

end Behavioral;