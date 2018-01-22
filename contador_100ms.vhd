----------------------------------------------------------------------------------
-- CONTADOR DE 100 MS
-- Contador que genera una señal que se activa con cada cuenta de 100 ms.
-- Cada vez que se realiza una pulsación, el autómata de Moore desactiva la señal
-- de reset del contador y habilita la cuenta. De esta forma, cuando se activa
-- la señal salida, el módulo indica que han pasado 100 ms. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity contador_100ms is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           rst_cnt : in  STD_LOGIC;	-- entrada del reset del contador
           en_cnt : in  STD_LOGIC;	-- entrada que habilita el contador
           cnt_100ms : out  STD_LOGIC);	-- salida de contador_100ms
end contador_100ms;

architecture Behavioral of contador_100ms is

signal contador : STD_LOGIC_VECTOR(22 downto 0) := "00000000000000000000000"; -- declaracion de la señal

begin

process (clk, rst_cnt)	-- En este process se indica la cuenta del contador
	begin
		if rst_cnt='1' then -- Cuando se activa la entrada del reset, la salida se pone a 0
			cnt_100ms <= '0';
			contador <= (others => '0');
		elsif clk'event and clk='1' then
			cnt_100ms <= '0';
			if en_cnt='1' then
				contador <= contador + '1';
				if contador >= "10011000100101101000000" then -- valor máximo de la cuenta
					cnt_100ms <= '1';									-- se pone la salida a 1
					contador <= (others => '0');
				end if;
			end if;
		end if;
end process;

end Behavioral;