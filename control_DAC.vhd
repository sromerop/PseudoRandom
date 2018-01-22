----------------------------------------------------------------------------------
-- CONTROL DAC
-- Es el encargado de generar todas las se�ales digitales que necesita
-- el DAC para realizar la conversi�n
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_DAC is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           start_DAC : in  STD_LOGIC;	-- se�al que habilita el m�dulo
           valor_DAC : in  STD_LOGIC_VECTOR (11 downto 0);	-- valor binario a enviar al DAC
           end_DAC : out  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo
           CS1 : out  STD_LOGIC;	--  se�al de control para el DAC
           SCLK : out  STD_LOGIC;	-- se�al de control para el DAC
           DIN : out  STD_LOGIC);	 -- dato que se env�a al DAC
end control_DAC;

architecture Behavioral of control_DAC is

 -- Declaraci�n de las se�ales necesarias
signal en_cnt : STD_LOGIC := '0';	-- se�al que habilita el contador de 1 us
signal fin_de_cuenta : STD_LOGIC := '0';	-- se�al que indica que ha pasado 1 us
signal contador : STD_LOGIC_VECTOR  (5 downto 0) := "000000";	-- se�al que lleva la cuenta para 1 us
signal byte_transmision_DAC : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";	-- se�al que porta el byte de transmisi�n
signal bit_DIN : STD_LOGIC_VECTOR (3 downto 0) := "0000";	-- se�al que cuenta los bits transmitidos
signal st : STD_LOGIC_VECTOR (1 downto 0) := "00";	-- se�al que indica el estado del aut�mata
signal aux : STD_LOGIC := '0';	-- se�al que equivale a SCLK

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

process (Rst, clk)	-- en este process se entrega los bytes de transmisi�n y se envia el dato de salida
	begin
		if (Rst = '1') then -- Poner a cero todas las se�ales del proceso
			st <= "00";
			bit_DIN <= "0000";
			byte_transmision_DAC <= "0000000000000000";
			end_DAC <= '0';
			
		elsif clk'event and clk = '1' then
			
			end_DAC <= '0';	-- necesario para que la se�al dure s�lo un pulso de reloj
			
			CASE st IS
				
				when "00" => -- Reposo (Estado 00)
					
					en_cnt <= '0'; -- Inicializar contadores
					byte_transmision_DAC <= "000" & valor_DAC & '0';
					if start_DAC = '1' then 
						st <= "01";
					end if;
			
				when "01" => -- Entrega de la peticion (Estado 01)
					en_cnt <= '1';
					if (fin_de_cuenta = '1' and aux = '1') then -- Flanco de bajada de SCLK
						byte_transmision_DAC <= byte_transmision_DAC(14 downto 0) & '0';	-- desplaza transmision
						bit_DIN <= bit_DIN + "01";
						if bit_DIN >= "1111" then -- Se ha enviado la peticion completa
							st <= "11"; 
							bit_DIN <= (others => '0');
						end if;
					end if;
 
				when "11" => -- Entrega del dato de salida, y final (Estado 11)
					st <= "00";
					end_DAC <= '1';
 
				when others =>
					st <= "00";
				
			END CASE;
	end if;
end process;

-- asignaci�n de salidas
SCLK <= aux;
CS1 <= '0' when (st = "01") else '1';
DIN <= byte_transmision_DAC(15) when st = "01" else '0';	-- se va pasando por DIN el byte de transmisi�n

end Behavioral;