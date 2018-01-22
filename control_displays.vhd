----------------------------------------------------------------------------------
-- CONTROL DISPLAYS
-- Fichero TOP del módulo de control de los displays, que describe de forma
-- jerárquica la conexión de los módulos conversorBCD, contador_5ms y
-- visualizacion.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_displays is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- entrada con el valor del código introducido
           Disp0 : out  STD_LOGIC;	-- salida encargada de activar el display de las unidades
           Disp1 : out  STD_LOGIC;	-- salida encargada de activar el display de las decenas
           Disp2 : out  STD_LOGIC;	-- salida encargada de activar el display de las centenas
           Disp3 : out  STD_LOGIC;	-- salida encargada de activar el display de los millares
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	-- salida con el valor del digito de BCD a 7 segmentos
end control_displays;

architecture Behavioral of control_displays is

component conversorBCD is
   Port ( --clk : in  STD_LOGIC;	-- entrada del reloj, no es necesaria, se quita para evitar posibles errores
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- entrada con el valor del código introducido
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);	-- dígito que corresponde a las unidades
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);	-- dígito que corresponde a las decenas
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);	-- dígito que corresponde a las centenas
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));	-- dígito que corresponde a los millares
end component;

component contador_5ms is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           cnt_5ms : out  STD_LOGIC);	-- salida de contador_5ms
end component;

component visualizacion is
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
end component;

	-- señales auxiliares para realizar el port map
	signal cnt_5ms : STD_LOGIC;
	signal Digito0, Digito1, Digito2, Digito3 : STD_LOGIC_VECTOR (3 downto 0);

begin

	U1 : conversorBCD port map (b, Digito0, Digito1, Digito2, Digito3);
	U2 : contador_5ms port map (clk, cnt_5ms);
	U3 : visualizacion port map (clk, cnt_5ms, Digito0, Digito1, Digito2, Digito3, Disp0, Disp1, Disp2, Disp3, Seg7);

end Behavioral;