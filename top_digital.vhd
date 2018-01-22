----------------------------------------------------------------------------------
-- ENTIDAD JER�RQUICA TOP
-- Versi�n final del fichero jerarqu�a del subsistema digital.
-- Contiene los bloques de control de pulsadores, control de displays,
-- control del ADC, control del DAC, control global y encriptaci�n.
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
			  DOUT : in  STD_LOGIC;	-- se�al serie que se recibe desde el ADC
			  sw : in  STD_LOGIC_VECTOR (5 downto 0);	-- c�digo predefinido de cifrado, especificado por los interruptores			  DOUT : in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;	-- salida encargada de activar el display de las unidades
           Disp1 : out  STD_LOGIC;	-- salida encargada de activar el display de las decenas
           Disp2 : out  STD_LOGIC;	-- salida encargada de activar el display de las centenas
           Disp3 : out  STD_LOGIC;	-- salida encargada de activar el display de los millares
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);	-- salida con el valor del digito de BCD a 7 segmentos
			  CS0 : out  STD_LOGIC;	--  se�al de control para el ADC
			  CS1 : out  STD_LOGIC;	--  se�al de control para el DAC
           SCLK : out  STD_LOGIC;	-- se�al de control para el DAC
           DIN : out  STD_LOGIC);	 -- dato que se env�a al DAC
end top_digital;

architecture Behavioral of top_digital is

component control_pulsadores is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           Rst : in  STD_LOGIC;	-- entrada del reset
           Up0 : in  STD_LOGIC;	-- pulsador que incrementa 1
           Down0 : in  STD_LOGIC;	-- pulsador que decrementa 1
           Up1 : in  STD_LOGIC;	-- pulsador que incrementa 10
           Down1 : in  STD_LOGIC;	-- pulsador que decrementa 10
           b : out  STD_LOGIC_VECTOR (5 downto 0));	-- salida con el valor del c�digo introducido
end component;

component control_displays is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- entrada con el valor del c�digo introducido
           Disp0 : out  STD_LOGIC;	-- salida encargada de activar el display de las unidades
           Disp1 : out  STD_LOGIC;	-- salida encargada de activar el display de las decenas
           Disp2 : out  STD_LOGIC;	-- salida encargada de activar el display de las centenas
           Disp3 : out  STD_LOGIC;	-- salida encargada de activar el display de los millares
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	-- salida con el valor del digito de BCD a 7 segmentos
end component;

component control_ADC is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           start_ADC : in  STD_LOGIC;	-- se�al que habilita el m�dulo
           DOUT : in  STD_LOGIC;	-- se�al serie que se recibe desde el ADC
           end_ADC : out  STD_LOGIC;	-- se�al que da por terminado la operaci�n del m�dulo
           CS0 : out  STD_LOGIC;	--  se�al de control para el ADC
           SCLK : out  STD_LOGIC;	-- se�al de control para el ADC
           DIN : out  STD_LOGIC;	-- se�al de petici�n par el ADC
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0));	-- �ltimo valor binario completo recibido desde el ADC
end component;

component control_DAC is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           start_DAC : in  STD_LOGIC;	-- se�al que habilita el m�dulo
           valor_DAC : in  STD_LOGIC_VECTOR (11 downto 0);	-- valor binario a enviar al DAC
           end_DAC : out  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo
           CS1 : out  STD_LOGIC;	--  se�al de control para el DAC
           SCLK : out  STD_LOGIC;	-- se�al de control para el DAC
           DIN : out  STD_LOGIC);	 -- dato que se env�a al DAC
end component;


component control_global is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           end_ADC : in  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo ADC
           end_random : in  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo de encriptaci�n
           end_DAC : in  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo DAC
           start_ADC : out  STD_LOGIC;	-- se�al que habilita el m�dulo ADC
           start_random : out  STD_LOGIC;	-- se�al que habilita el m�dulo de encriptaci�n
           start_DAC : out  STD_LOGIC;	-- se�al que habilita el m�dulo DAC
           global_st : out  STD_LOGIC_VECTOR (1 downto 0));	-- se�al que indica el estado del aut�mata
end component;

component pseudo_random is
    Port ( clk : in  STD_LOGIC;	-- se�al de reloj
           Rst : in  STD_LOGIC;	-- se�al de reset
           start_random : in  STD_LOGIC;	-- se�al que habilita el m�dulo
           sw : in  STD_LOGIC_VECTOR (5 downto 0);	-- c�digo predefinido de cifrado, especificado por los interruptores
           b : in  STD_LOGIC_VECTOR (5 downto 0);	-- c�digo introducido por el usuario a trav�s de los pulsadores
           valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);	-- �ltimo valor binario completo recibido desde el ADC
           end_random : out  STD_LOGIC;		-- se�al que da por terminado la operaci�n del m�dulo
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0));	-- valor binario a enviar al DAC
end component;

-- se�ales auxiliares para realizar el port map
signal b : STD_LOGIC_VECTOR(5 downto 0);
signal start_ADC, start_DAC, start_random, end_ADC, end_DAC, end_random : STD_LOGIC;
signal valor_ADC, valor_DAC: STD_LOGIC_VECTOR(11 downto 0);
signal global_st : STD_LOGIC_VECTOR(1 downto 0);
signal DIN_ADC, DIN_DAC, SCLK_ADC, SCLK_DAC : STD_LOGIC;	-- para la salida compartida

begin

	with global_st select DIN <=	-- como la salida es compartida se multiplexa en funci�n del estado del aut�mata
		DIN_ADC when "01",
		DIN_DAC when "10",
		'0' when others; 
		
	with global_st select SCLK <=	-- como la salida es compartida se multiplexa en funci�n del estado del aut�mata
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