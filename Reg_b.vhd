----------------------------------------------------------------------------------
-- REGISTRO
-- Este registro contiene en binario el valor del c�digo introducido por el 
-- usuario, b. En su funcionalidad se incorpora tambi�n que el registro sea capaz
-- de variar su valor (en funci�n de lo que indiquen las se�ales que provienen de
-- la m�quina de estados de Moore), y que no se excedan los l�mites m�ximos 
-- y m�nimos permitidos (0-63). 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Reg_b is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           rst_b : in  STD_LOGIC;	-- entrada que resetea el registro
           en_b : in  STD_LOGIC;	-- entrada que habilita el registro
           sel : in  STD_LOGIC_VECTOR (1 downto 0);	-- entrada del selector
           b : out  STD_LOGIC_VECTOR (5 downto 0));	-- salida con el valor del c�digo introducido
end Reg_b;

architecture Behavioral of Reg_b is

signal s_Reg_b : STD_LOGIC_VECTOR(5 downto 0); -- declaracion de la se�al que sale del registro

begin

process (rst_b, clk)	-- En este process se modifica el valor de s_Reg_b dependiendo del valor de la entrada sel
begin
	if clk'event and clk='1' then
		if (rst_b = '1') then
			s_Reg_b <= "000000"; -- Asignaci�n del valor por defecto
		end if;
		if en_b = '1' then
			if ((sel = "00") and (s_Reg_b < "111111")) then
				s_Reg_b <= s_Reg_b + "01"; -- Incremento +1 de la se�al
			end if;
			if ((sel = "01") and (s_Reg_b > "000000")) then
				s_Reg_b <= s_Reg_b - "01"; -- Decremento -1 de la se�al
			end if;
			if ((sel = "10") and (s_Reg_b < "110110")) then
				s_Reg_b <= s_Reg_b + "01010"; -- Incremento +10 de la se�al
			end if;
			if ((sel = "11") and (s_Reg_b > "001001")) then
				s_Reg_b <= s_Reg_b - "01010"; -- Decremento -10 de la se�al
			end if;
		end if;
	end if;
end process; 

	b <= s_Reg_b; -- Asignaci�n a la salida bdel valor obtenido de Reg_b en el process

end Behavioral;