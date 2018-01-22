----------------------------------------------------------------------------------
-- ENCRIPTACI�N
-- Es el encargado de comparar el c�digo predefinido de cifrado
-- (fijado en los interruptores) con el c�digo introducido por
-- el usuario (generado mediante los pulsadores).
-- En caso de que sean iguales, la se�al de entrada se transmitir�
-- a la salida.
-- En caso de que no lo sean, se entrega al DAC la salida de un
-- generador pseudo-aleatorio de 16 bits. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity pseudo_random is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           start_random : in  STD_LOGIC;	-- se�al que habilita el m�dulo
           sw : in  STD_LOGIC_VECTOR (5 downto 0);	-- c�digo predefinido de cifrado, especificado por los interruptores
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- c�digo introducido por el usuario a trav�s de los pulsadores
           valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);	-- �ltimo valor binario completo recibido desde el ADC
           end_random : out  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0));	-- valor binario a enviar al DAC
end pseudo_random;

architecture Behavioral of pseudo_random is
 
-- Declaraci�n de las se�ales necesarias
signal registro : STD_LOGIC_VECTOR (15 downto 0) := "0000000010000001";	-- representa el registro de desplazamiento
signal aux : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";	-- para sumarle el offset a la entrada de datos
signal semilla : STD_LOGIC;	-- valor inicial para el registro

begin

aux <= valor_ADC + 2048;	-- suma del offset necesario
semilla <= (((registro(15) XOR registro(13)) XOR registro(12)) XOR registro(10));	-- registro de desplazamiento

process (Rst, clk)	-- en este process se comparan los c�digos y se asignan las salidas
	begin
		if Rst = '1' then 
			valor_DAC <= "000000000000";
		elsif clk'event and clk='1' then
			end_random <= '0';
			if start_random = '1' then 
				if (b = sw) then -- si coinciden los valores, la salida es igual a la entrada
					valor_DAC <= aux;
					end_random <= '1';
				else	-- si no coinciden, se genera una secuencia pseudoaleatoria
					valor_DAC <= registro (11 downto 0);
					end_random <= '1';
				end if;
			end if;
		end if;
end process;

process (clk)	-- process que sirve para que los valores del registro est�n en continuo cambio
	begin
	if clk'event and clk='1' then
		registro <= registro(14 downto 0) & semilla;
	end if;
end process;

end Behavioral;