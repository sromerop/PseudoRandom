----------------------------------------------------------------------------------
-- CONTROL ADC
-- Es el encargado de enviar y recibir todas las se�ales que deben llegar
-- al ADC. Este bloque debe realizar 2 cosas:
-- En primer lugar, enviar el byte de petici�n por medio de las se�ales
-- CS0, SCLK y DIN. 
-- En segundo, recibir la respuesta a trav�s de la se�al DOUT y entregar el
-- valor digital que se reciba a la siguiente etapa. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_ADC is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           start_ADC : in  STD_LOGIC;	-- se�al que habilita el m�dulo
           DOUT : in  STD_LOGIC;	-- se�al serie que se recibe desde el ADC
           end_ADC : out  STD_LOGIC;	-- se�al que da por terminado la operaci�n del m�dulo
           CS0 : out  STD_LOGIC;	--  se�al de control para el ADC
           SCLK : out  STD_LOGIC;	-- se�al de control para el ADC
           DIN : out  STD_LOGIC;	-- se�al de petici�n par el ADC
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0));	-- �ltimo valor binario completo recibido desde el ADC
end control_ADC;

architecture Behavioral of control_ADC is

 -- Declaraci�n de las se�ales necesarias
signal en_cnt : STD_LOGIC := '0';	-- se�al que habilita el contador de 1 us
signal fin_de_cuenta : STD_LOGIC := '0';	-- se�al que indica que ha pasado 1 us
signal contador : STD_LOGIC_VECTOR  (5 downto 0) := "000000";	-- se�al que lleva la cuenta para 1 us
signal byte_peticion_ADC : STD_LOGIC_VECTOR (7 downto 0) := "00000000";	-- se�al que porta el byte de peticion
signal bit_DIN : STD_LOGIC_VECTOR (3 downto 0) := "0000";	-- se�al que cuenta los bits transmitidos
signal st : STD_LOGIC_VECTOR (1 downto 0) := "00";	-- se�al que indica el estado del aut�mata
signal dato_ADC : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";	-- se�al que porta la recepcion de bits
signal aux : STD_LOGIC := '0';	-- se�al que equivale a SCLK
signal salida : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";	-- se�al que equivale a valor_ADC

begin
 
 -- Procesos (contadores 1 y 2) y otras asignaciones de se�ales de la entidad

process(clk)	-- en este process se produce la cuenta de 1 us
	begin
		if clk'event and clk='1' then
			if en_cnt = '1' then
				fin_de_cuenta <= '0';
				contador <= contador + '1';
				if contador >= "110010" then -- valor m�ximo de la cuenta
					fin_de_cuenta <= '1';
					contador <= (others => '0');
				end if;
			end if;
		end if;
end process;

process (clk)	-- este process equivale a un biestable del que resulta SCLK
	begin
		if clk'event and clk='1' then
			if fin_de_cuenta = '1' then
				aux <= not(aux); 
			end if;
		end if;
end process;

process (Rst, clk)	-- en este process se entrega el byte de peticion, se reciben los datos serie y se envia el dato de salida
	begin
		if (Rst = '1') then -- Poner a cero todas las se�ales del proceso
			st <= "00";
			bit_DIN <= "0000";
			byte_peticion_ADC <= "00000000";
			dato_ADC <= "0000000000000000";
			end_ADC <= '0';	
		
		elsif clk'event and clk = '1' then
			
			end_ADC <= '0';	-- necesario para que la se�al dure s�lo un pulso de reloj
			
			CASE st IS
				
				when "00" => -- Reposo (Estado 00)
					
					en_cnt <= '0'; -- Inicializar contadores
					byte_peticion_ADC <= "10010111"; -- Precarga del byte de peticion
					if start_ADC = '1' then -- Selecci�n del canal 0 en modo bipolar (-1.3, 2.5V)
						st <= "01";
					end if;
			
				when "01" => -- Entrega de la peticion (Estado 01)
					en_cnt <= '1';
						if (fin_de_cuenta = '1' and aux = '1') then	-- Flanco de bajada de SCLK
							byte_peticion_ADC <= byte_peticion_ADC(6 downto 0) & '0'; -- Desplaza petici�n
							bit_DIN <= bit_DIN + "01";
							if bit_DIN >= "0111" then -- Se ha enviado la peticion completa
								st <= "10";
								bit_DIN <= (others => '0');
							end if;
						end if;
 
				when "10" => -- Recepcion de los datos serie (Estado 10)
					en_cnt <= '1';
					if (fin_de_cuenta = '1' and aux = '0') then -- Flanco de subida de SCLK
						dato_ADC <= dato_ADC(14 downto 0) & DOUT; -- Recepcion serie
					end if;
					if (fin_de_cuenta = '1' and aux = '1') then -- Flanco de bajada de SCLK
						bit_DIN <= bit_DIN + "01";
							if bit_DIN = "1111" then -- Se ha recibido el dato completo
								st <= "11"; 
								bit_DIN <= (others => '0');
							end if;
					end if;
 
				when "11" => -- Entrega del dato de salida, y final (Estado 11)
					st <= "00";
					salida <= dato_ADC(14 downto 3);	-- se pasan a valor_ADC los bits significativos del conversor
					end_ADC <= '1';
 
				when others =>
					st <= "00";
				
			END CASE;
	end if;
end process;

-- asignaci�n de salidas
SCLK <= aux;
DIN <= byte_peticion_ADC(7) when st = "01" else '0';	-- se va pasando por DIN el byte de peticion
CS0 <= '0' when (st = "01" or st = "10") else '1';
valor_ADC <= salida;

end Behavioral;