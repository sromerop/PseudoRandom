----------------------------------------------------------------------------------
-- CONTROL ADC
-- Es el encargado de enviar y recibir todas las señales que deben llegar
-- al ADC. Este bloque debe realizar 2 cosas:
-- En primer lugar, enviar el byte de petición por medio de las señales
-- CS0, SCLK y DIN. 
-- En segundo, recibir la respuesta a través de la señal DOUT y entregar el
-- valor digital que se reciba a la siguiente etapa. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_ADC is
    Port ( clk : in  STD_LOGIC;	-- señal de reloj
           Rst : in  STD_LOGIC;	-- señal de reset
           start_ADC : in  STD_LOGIC;	-- señal que habilita el módulo
           DOUT : in  STD_LOGIC;	-- señal serie que se recibe desde el ADC
           end_ADC : out  STD_LOGIC;	-- señal que da por terminado la operación del módulo
           CS0 : out  STD_LOGIC;	--  señal de control para el ADC
           SCLK : out  STD_LOGIC;	-- señal de control para el ADC
           DIN : out  STD_LOGIC;	-- señal de petición par el ADC
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0));	-- último valor binario completo recibido desde el ADC
end control_ADC;

architecture Behavioral of control_ADC is

 -- Declaración de las señales necesarias
signal en_cnt : STD_LOGIC := '0';	-- señal que habilita el contador de 1 us
signal fin_de_cuenta : STD_LOGIC := '0';	-- señal que indica que ha pasado 1 us
signal contador : STD_LOGIC_VECTOR  (5 downto 0) := "000000";	-- señal que lleva la cuenta para 1 us
signal byte_peticion_ADC : STD_LOGIC_VECTOR (7 downto 0) := "00000000";	-- señal que porta el byte de peticion
signal bit_DIN : STD_LOGIC_VECTOR (3 downto 0) := "0000";	-- señal que cuenta los bits transmitidos
signal st : STD_LOGIC_VECTOR (1 downto 0) := "00";	-- señal que indica el estado del autómata
signal dato_ADC : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";	-- señal que porta la recepcion de bits
signal aux : STD_LOGIC := '0';	-- señal que equivale a SCLK
signal salida : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";	-- señal que equivale a valor_ADC

begin
 
 -- Procesos (contadores 1 y 2) y otras asignaciones de señales de la entidad

process(clk)	-- en este process se produce la cuenta de 1 us
	begin
		if clk'event and clk='1' then
			if en_cnt = '1' then
				fin_de_cuenta <= '0';
				contador <= contador + '1';
				if contador >= "110010" then -- valor máximo de la cuenta
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
		if (Rst = '1') then -- Poner a cero todas las señales del proceso
			st <= "00";
			bit_DIN <= "0000";
			byte_peticion_ADC <= "00000000";
			dato_ADC <= "0000000000000000";
			end_ADC <= '0';	
		
		elsif clk'event and clk = '1' then
			
			end_ADC <= '0';	-- necesario para que la señal dure sólo un pulso de reloj
			
			CASE st IS
				
				when "00" => -- Reposo (Estado 00)
					
					en_cnt <= '0'; -- Inicializar contadores
					byte_peticion_ADC <= "10010111"; -- Precarga del byte de peticion
					if start_ADC = '1' then -- Selección del canal 0 en modo bipolar (-1.3, 2.5V)
						st <= "01";
					end if;
			
				when "01" => -- Entrega de la peticion (Estado 01)
					en_cnt <= '1';
						if (fin_de_cuenta = '1' and aux = '1') then	-- Flanco de bajada de SCLK
							byte_peticion_ADC <= byte_peticion_ADC(6 downto 0) & '0'; -- Desplaza petición
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

-- asignación de salidas
SCLK <= aux;
DIN <= byte_peticion_ADC(7) when st = "01" else '0';	-- se va pasando por DIN el byte de peticion
CS0 <= '0' when (st = "01" or st = "10") else '1';
valor_ADC <= salida;

end Behavioral;