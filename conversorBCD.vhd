----------------------------------------------------------------------------------
-- CONVERSOR BCD
-- Es el módulo que se encarga de convertir la señal b (representada
-- en binario y con valores entre 0 y 63) al formato BCD.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity conversorBCD is
    Port ( --clk : in  STD_LOGIC;	-- entrada del reloj, no es necesaria, se quita para evitar posibles errores
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- entrada con el valor del código introducido
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);	-- dígito que corresponde a las unidades
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);	-- dígito que corresponde a las decenas
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);	-- dígito que corresponde a las centenas
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));	-- dígito que corresponde a los millares
end conversorBCD;

architecture Behavioral of conversorBCD is

begin

process (b) -- En este process se obtiene el valor de las unidades y las decenas del valor de entrada b

	VARIABLE resto : STD_LOGIC_VECTOR (5 downto 0);	-- variable auxiliar para realizar el algoritmo

begin
	D1 <= (others => '0'); -- VALORES POR DEFECTO
	resto := b; 

	if b >= conv_std_logic_vector(10, 6) then	-- conv_std_logic_vector(x, y) convierte el valor x a binario con y bits
		D1 <= "0001"; 
		resto := b - conv_std_logic_vector(10, 6); -- resto = b - 10
	end if;
	
	if b >= conv_std_logic_vector(20, 6) then
		D1 <= "0010"; 
		resto := b - conv_std_logic_vector(20, 6); -- resto = b - 20
	end if;
	
	if b >= conv_std_logic_vector(30, 6) then
		D1 <= "0011"; 
		resto := b - conv_std_logic_vector(30, 6); -- resto = b - 30
	end if;
	
	if b >= conv_std_logic_vector(40, 6) then
		D1 <= "0100"; 
		resto := b - conv_std_logic_vector(40, 6); -- resto = b - 40
	end if;
	
	if b >= conv_std_logic_vector(50, 6) then
		D1 <= "0101"; 
		resto := b - conv_std_logic_vector(50, 6); -- resto = b - 50
	end if;
	
	if b >= conv_std_logic_vector(60, 6) then
		D1 <= "0110"; 
		resto := b - conv_std_logic_vector(60, 6); -- resto = b - 60
	end if;
	
	D0 <= resto(3 downto 0); -- Asignacion de salida a las unidades
										--D1 corresponde a las decenas y se asigna dentro del process
	
end process; 

	D2 <= "0000";	-- D2 y D3 corresponderían a centenas y millares
	D3 <= "0000";	-- pero por la limitación de 0 a 63, los mantenemos a 0
end Behavioral;