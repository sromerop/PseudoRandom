----------------------------------------------------------------------------------
-- ENTIDAD JERÁRQUICA TOP
-- Versión final del fichero jerarquía del subsistema digital.
-- Contiene los bloques de control de pulsadores, control de displays,
-- control del ADC, control del DAC, control global y encriptación.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity top_digital is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           Rst : in  STD_LOGIC;	-- entrada del reset
           Up0 : in  STD_LOGIC;	-- pulsador que incrementa 1
           Down0 : in  STD_LOGIC;	-- pulsador que decrementa 1
           Up1 : in  STD_LOGIC;	-- pulsador que incrementa 10
			  Down1 : in  STD_LOGIC;	-- pulsador que decrementa 1
			  DOUT : in  STD_LOGIC;	-- señal serie que se recibe desde el ADC
			  sw : in  STD_LOGIC_VECTOR (5 downto 0);	-- código predefinido de cifrado, especificado por los interruptores			  DOUT : in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;	-- salida encargada de activar el display de las unidades
           Disp1 : out  STD_LOGIC;	-- salida encargada de activar el display de las decenas
           Disp2 : out  STD_LOGIC;	-- salida encargada de activar el display de las centenas
           Disp3 : out  STD_LOGIC;	-- salida encargada de activar el display de los millares
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);	-- salida con el valor del digito de BCD a 7 segmentos
			  CS0 : out  STD_LOGIC;	--  señal de control para el ADC
			  CS1 : out  STD_LOGIC;	--  señal de control para el DAC
           SCLK : out  STD_LOGIC;	-- señal de control para el DAC
           DIN : out  STD_LOGIC);	 -- dato que se envía al DAC
end top_digital;

architecture Behavioral of top_digital is

component control_pulsadores is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           Rst : in  STD_LOGIC;	-- entrada del reset
           Up0 : in  STD_LOGIC;	-- pulsador que incrementa 1
           Down0 : in  STD_LOGIC;	-- pulsador que decrementa 1
           Up1 : in  STD_LOGIC;	-- pulsador que incrementa 10
           Down1 : in  STD_LOGIC;	-- pulsador que decrementa 10
           b : out  STD_LOGIC_VECTOR (5 downto 0));	-- salida con el valor del código introducido
end component;

component control_displays is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- entrada con el valor del código introducido
           Disp0 : out  STD_LOGIC;	-- salida encargada de activar el display de las unidades
           Disp1 : out  STD_LOGIC;	-- salida encargada de activar el display de las decenas
           Disp2 : out  STD_LOGIC;	-- salida encargada de activar el display de las centenas
           Disp3 : out  STD_LOGIC;	-- salida encargada de activar el display de los millares
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	-- salida con el valor del digito de BCD a 7 segmentos
end component;

component control_ADC is
    Port ( clk : in  STD_LOGIC;	-- señal de reloj
           Rst : in  STD_LOGIC;	-- señal de reset
           start_ADC : in  STD_LOGIC;	-- señal que habilita el módulo
           DOUT : in  STD_LOGIC;	-- señal serie que se recibe desde el ADC
           end_ADC : out  STD_LOGIC;	-- señal que da por terminado la operación del módulo
           CS0 : out  STD_LOGIC;	--  señal de control para el ADC
           SCLK : out  STD_LOGIC;	-- señal de control para el ADC
           DIN : out  STD_LOGIC;	-- señal de petición par el ADC
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0));	-- último valor binario completo recibido desde el ADC
end component;

component control_DAC is
    Port ( clk : in  STD_LOGIC;	-- señal de reloj
           Rst : in  STD_LOGIC;	-- señal de reset
           start_DAC : in  STD_LOGIC;	-- señal que habilita el módulo
           valor_DAC : in  STD_LOGIC_VECTOR (11 downto 0);	-- valor binario a enviar al DAC
           end_DAC : out  STD_LOGIC;		-- señal que da por terminado la operación del módulo
           CS1 : out  STD_LOGIC;	--  señal de control para el DAC
           SCLK : out  STD_LOGIC;	-- señal de control para el DAC
           DIN : out  STD_LOGIC);	 -- dato que se envía al DAC
end component;


component control_global is
    Port ( clk : in  STD_LOGIC;	-- señal de reloj
           Rst : in  STD_LOGIC;	-- señal de reset
           end_ADC : in  STD_LOGIC;		-- señal que da por terminado la operación del módulo ADC
           end_random : in  STD_LOGIC;		-- señal que da por terminado la operación del módulo de encriptación
           end_DAC : in  STD_LOGIC;		-- señal que da por terminado la operación del módulo DAC
           start_ADC : out  STD_LOGIC;	-- señal que habilita el módulo ADC
           start_random : out  STD_LOGIC;	-- señal que habilita el módulo de encriptación
           start_DAC : out  STD_LOGIC;	-- señal que habilita el módulo DAC
           global_st : out  STD_LOGIC_VECTOR (1 downto 0));	-- señal que indica el estado del autómata
end component;

component pseudo_random is
    Port ( clk : in  STD_LOGIC;	-- señal de reloj
           Rst : in  STD_LOGIC;	-- señal de reset
           start_random : in  STD_LOGIC;	-- señal que habilita el módulo
           sw : in  STD_LOGIC_VECTOR (5 downto 0);	-- código predefinido de cifrado, especificado por los interruptores
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- código introducido por el usuario a través de los pulsadores
           valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);	-- último valor binario completo recibido desde el ADC
           end_random : out  STD_LOGIC;		-- señal que da por terminado la operación del módulo
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0));	-- valor binario a enviar al DAC
end component;

-- señales auxiliares para realizar el port map
signal b : STD_LOGIC_VECTOR(5 downto 0);
signal start_ADC, start_DAC, start_random, end_ADC, end_DAC, end_random : STD_LOGIC;
signal valor_ADC, valor_DAC: STD_LOGIC_VECTOR(11 downto 0);
signal global_st : STD_LOGIC_VECTOR(1 downto 0);
signal DIN_ADC, DIN_DAC, SCLK_ADC, SCLK_DAC : STD_LOGIC;	-- para la salida compartida

begin

	with global_st select DIN <=	-- como la salida es compartida se multiplexa en función del estado del autómata
		DIN_ADC when "01",
		DIN_DAC when "10",
		'0' when others; 
		
	with global_st select SCLK <=	-- como la salida es compartida se multiplexa en función del estado del autómata
		SCLK_ADC when "01",
		SCLK_DAC when "10",
		'0' when others;
 
	U1 : control_pulsadores port map (clk, Rst, Up0, Down0, Up1, Down1, b);
	U2 : control_displays port map (clk, b, Disp0, Disp1, Disp2, Disp3, Seg7);
	U3 : control_ADC port map (clk, Rst, start_ADC, DOUT, end_ADC, CS0, SCLK_ADC, DIN_ADC, valor_ADC);
	U4 : control_DAC port map (clk, Rst, start_DAC, valor_DAC, end_DAC, CS1, SCLK_DAC, DIN_DAC);
	U5 : control_global port map (clk, Rst, end_ADC, end_random, end_DAC, start_ADC, start_random, 
			start_DAC, global_st);
	U6 : pseudo_random port map (clk, Rst, start_random, sw, b, valor_ADC, end_random, valor_DAC);

end Behavioral;