----------------------------------------------------------------------------------
-- CONTADOR 5 MS
-- Para multiplexar los datos de los 4 dígitos para utilizar los 4 displays a
-- la vez, hace falta una señal para que la visualización sea correcta. Se ha
-- seleccionado T = 5ms, de forma que cada display se refresque cada 20 ms. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity contador_5ms is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           cnt_5ms : out  STD_LOGIC);	-- salida de contador_5ms
end contador_5ms;

architecture Behavioral of contador_5ms is

signal contador : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000"; -- declaracion de la señal

begin

process (clk)	-- En este process se indica la cuenta del contador
	begin
		if clk'event and clk='1' then
			cnt_5ms <= '0';
			contador <= contador + '1';
			if contador >= "111101000010010000" then -- valor máximo de la cuenta
				cnt_5ms <= '1';									-- se pone la salida a 1
				contador <= (others => '0');
			end if;
		end if;
end process;

end Behavioral;