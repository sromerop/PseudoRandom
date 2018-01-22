----------------------------------------------------------------------------------
-- VISUALIZACIÓN
-- Es el módulo encargado de mostrar los datos en los displays. Puesto que la
-- señal de datos (Seg7) es compartida, es necesario activar cada 5 ms, cada uno 
-- de los displays y poner los datos correspondientes en el bus Seg7. 
-- También es necesario convertir los datos de BCD a 7 segmentos. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity visualizacion is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           cnt_5ms : in  STD_LOGIC;	-- entrada proveniente del contador_5ms, para refrescar los displays
           Digito0 : in  STD_LOGIC_VECTOR (3 downto 0);	-- dígito en BCD que corresponde a las unidades del valor
           Digito1 : in  STD_LOGIC_VECTOR (3 downto 0);	-- dígito en BCD que corresponde a las decenas del valor
           Digito2 : in  STD_LOGIC_VECTOR (3 downto 0);	-- dígito en BCD que corresponde a las centenas del valor
           Digito3 : in  STD_LOGIC_VECTOR (3 downto 0);	-- dígito en BCD que corresponde a los millares del valor
           Disp0 : out  STD_LOGIC;	-- salida encargada de activar el display de las unidades
           Disp1 : out  STD_LOGIC;	-- salida encargada de activar el display de las decenas
           Disp2 : out  STD_LOGIC;	-- salida encargada de activar el display de las centenas
           Disp3 : out  STD_LOGIC;	-- salida encargada de activar el display de los millares
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	-- salida con el valor del digito de BCD a 7 segmentos
end visualizacion;

architecture Behavioral of visualizacion is

signal sel : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- señal que se encarga de activar un display u otro
signal digitoBCD : STD_LOGIC_VECTOR(3 downto 0); -- señal que usamos para pasar de BCD a 7 segmentos

begin

process (clk) -- en este process se cambia el valor de sel cada 5 ms
begin
 if clk'event and clk='1' then	-- en cada flanco de subida del reloj
	if cnt_5ms = '1' then			-- cuando la entrada cnt_5ms está activada
		sel <= sel + "01";
	end if;
 end if;
end process; 

process (sel, Digito0, Digito1, Digito2, Digito3) -- process en el que se activa un display u otro dependiendo del valor de sel
	begin
		digitoBCD <= digito0; -- asignación por defecto
		Disp0 <= '1'; -- por defecto (activas a nivel bajo)
		Disp1 <= '1'; 
		Disp2 <= '1'; 
		Disp3 <= '1'; 
			
			CASE sel IS
				
				when "00" => 
					Disp0 <= '0';
					digitoBCD <= Digito0;
				
				when "01" =>
					Disp1 <= '0';
					digitoBCD <= Digito1;
				
				when "10" =>
					Disp2 <= '1';
					digitoBCD <= Digito2;
				
				when "11" =>
					Disp3 <= '1';
					digitoBCD <= Digito3;
				
				when others => Disp0 <= '1';
		
	END CASE;
end process; 
with digitoBCD select Seg7 <= -- with select para indicar el valor de Seg7 dependiendo del valor de digitoBCD (activas a nivel bajo)
 "1000000" when "0000",
 "1111001" when "0001",
 "0100100" when "0010",
 "0110000" when "0011",
 "0011001" when "0100",
 "0010010" when "0101",
 "0000010" when "0110",
 "1111000" when "0111",
 "0000000" when "1000",
 "0011000" when "1001",
 "1111111" when others; 

end Behavioral;