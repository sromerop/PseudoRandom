----------------------------------------------------------------------------------
-- CONTROL GLOBAL
-- Es el encargado de gestionar cu�ndo tiene que comenzar el
-- procesamiento de cada uno de los bloques que dependen de �l.
-- Utiliza un protocolo de comunicaci�n as�ncrona basado en una
-- se�al de inicio y otra se�al de fin (cada bloque comenzar� su
-- procesamiento cuando haya terminado el bloque inmediatamente anterior).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_global is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           end_ADC : in  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo ADC
           end_random : in  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo de encriptaci�n
           end_DAC : in  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo DAC
           start_ADC : out  STD_LOGIC;	-- se�al que habilita el m�dulo ADC
           start_random : out  STD_LOGIC;	-- se�al que habilita el m�dulo de encriptaci�n
           start_DAC : out  STD_LOGIC;	-- se�al que habilita el m�dulo DAC
           global_st : out  STD_LOGIC_VECTOR (1 downto 0));	-- se�al que indica el estado del aut�mata
end control_global;

architecture Behavioral of control_global is

-- Declaraci�n de las se�ales necesarias
signal contador : STD_LOGIC_VECTOR (12 downto 0) := "0000000000000";	-- se�al que lleva la cuenta para 125 us
signal cnt_125us : STD_LOGIC := '0';	-- se�al que indica que han pasado 125 us
signal s_global_st : STD_LOGIC_VECTOR (1 downto 0) := "00";	-- se�al que indica el estado del aut�mata

begin

process (clk)	-- este process cuenta 125 us
	begin
		if clk'event and clk='1' then
			cnt_125us <= '0';
			contador <= contador + '1';
			if contador >= "1100001101010" then -- valor m�ximo de la cuenta
				cnt_125us <= '1';
				contador <= (others => '0');
			end if;
		end if;
end process;

global_st <= s_global_st;
start_ADC <= cnt_125us;	-- debido a que cada 125 us se pasa al estado 01, activandose start_ADC
				
process(clk, s_global_st, Rst, end_ADC, end_random, end_DAC, cnt_125us)	-- en este process se va cambiando de estado en funci�n de que las entradas avisen de que se acaban los estados anteriores
	begin
		if Rst = '1' then -- Poner a cero las se�ales
			s_global_st <= "00";
			start_DAC <= '0';
			start_random <= '0';
		
		elsif clk'event and clk='1' then 
			start_DAC <= '0';	-- incializaci�n
			start_random <= '0';	-- incializaci�n

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
					else	-- si se acaba ADC (01), el estado siguente es encriptaci�n (11)
						start_random <= '1';
						s_global_st <= "11";
					end if;
				
				when "11" =>
				
					if (end_random = '0') then
						s_global_st <= "11";
					else	-- si se acaba encriptaci�n (11), el estado siguente es DAC (10)
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