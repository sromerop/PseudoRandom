----------------------------------------------------------------------------------
-- AUTÓMATA DE MOORE
-- Máquina de estados de Moore que controla elfuncionamiento del módulo. Recibe 
-- las señales de los pulsadores y el interruptor, gestiona la cuenta de 100 ms,
-- y controla el valor del registro Reg_b. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity MooreFSM is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           Up0 : in  STD_LOGIC;	-- pulsador que incrementa 1
           Down0 : in  STD_LOGIC; 	-- pulsador que decrementa 1
           Up1 : in  STD_LOGIC;	-- pulsador que incrementa 10
           Down1 : in  STD_LOGIC;	-- pulsador que decrementa 10
           Rst : in  STD_LOGIC;	-- entrada del reset
           cnt_100ms : in  STD_LOGIC;	-- entrada proveniente del contador_100ms
           rst_cnt : out  STD_LOGIC;	-- salida que resetea el contador
           en_cnt : out  STD_LOGIC;	-- salida que habilita el contador
           rst_b : out  STD_LOGIC;	-- salida que resetea el registro
           en_b : out  STD_LOGIC;	-- salida que habilita el registro
           sel : out  STD_LOGIC_VECTOR (1 downto 0));	-- salida del selector
end MooreFSM;

architecture Behavioral of MooreFSM is

type state_type is (Reset, Main, Up0a, Up0b, Up1a, Up1b, Down0a, Down0b, Down1a, Down1b);	-- Estados del autómata
signal state_actual : state_type := Main;	-- Estado actual inicial
signal state_siguiente : state_type := Main;	-- Estado siguiente inicial
 
begin -- Implementación de la arquitectura

process (clk) -- En este process se indica cuando se producen los cambios de estado
begin
	if(clk'event and clk = '1') then		-- los cambios de estado se producen en cada flanco de subida de reloj
		state_actual <= state_siguiente;
	end if;
end process;

process (state_actual, Rst, Up0, Down0, Up1, Down1, cnt_100ms) -- Cambios de estado según el valor de las entradas
begin
		
		CASE state_actual IS
			
			when Reset => -- Desde Reset se pasa directamente a Main
				state_siguiente <= Main;
			
			when Main => -- En Main, si Rst es 1, cambia a estado Reset, si no, según este pulsado un pulsador u otro vamos a su respectivo estado
				if (Rst='1') then
					state_siguiente <= Reset;
				elsif (Up0='1') then
					state_siguiente <= Up0a;
				elsif (Down0='1') then
					state_siguiente <= Down0a;
				elsif (Up1='1') then
					state_siguiente <= Up1a;
				elsif (Down1='1') then
					state_siguiente <= Down1a;
				else
					state_siguiente <= Main;
				end if;
			
			when Up0a => -- En Up0a, si no han pasado 100 ms, seguimos en el estado; si pasan, cambia a Up0b
				if (cnt_100ms='1') then
					state_siguiente <= Up0b;
				else
					state_siguiente <= Up0a;
				end if;
			
			when Up0b => -- En Up0b, se pasa directamente a Main
				state_siguiente <= Main;	

			when Up1a => -- En Up1a, si no han pasado 100 ms, seguimos en el estado; si pasan, cambia a Up1b
				if (cnt_100ms='1') then
					state_siguiente <= Up1b;
				else
					state_siguiente <= Up1a;
				end if;
			
			when Up1b => -- En Up1b, se pasa directamente a Main		
				state_siguiente <= Main;
			
			when Down0a => -- En Down0a, si no han pasado 100 ms, seguimos en el estado; si pasan, cambia a Down0b
				if (cnt_100ms='1') then
					state_siguiente <= Down0b;
				else
					state_siguiente <= Down0a;
				end if;
			
			when Down0b => -- En Down0b, se pasa directamente a Main
				state_siguiente <= Main;
			
			when Down1a => -- En Down1a, si no han pasado 100 ms, seguimos en el estado; si pasan, cambia a Down1b
				if (cnt_100ms='1') then
					state_siguiente <= Down1b;
				else
					state_siguiente <= Down1a;
				end if;
			
			when Down1b => -- En Down1b, se pasa directamente a Main
				state_siguiente <= Main;
				
			when others => 
				state_siguiente <= Main;
						
		END CASE;
end process;

process (state_actual)	-- En este process se declara el valor de las salidas en cada estado
begin	
		rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '1'; en_cnt <= '0';	-- valores por defecto
		
		CASE state_actual IS
			
			when Reset =>
				rst_b <= '1'; en_b <= '0'; sel <= "00"; rst_cnt <= '1'; en_cnt <= '0';	--en Reset, valores por defecto, cambiando únicamente rst_b a 1
			
			when Main =>
				rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '1'; en_cnt <= '0';	-- en Main, valores por defecto
			
			when Up0a =>
				rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '0'; en_cnt <= '1';	-- en Up0a, valores por defecto, cambiando rst_cnt a 0 y en_cnt a 1
				
			when Up0b =>
				rst_b <= '0'; en_b <= '1'; sel <= "00"; rst_cnt <= '1'; en_cnt <= '0';	-- en Up0b, valores por defecto, cambiando únicamente en_b a 1
			
			when Up1a =>
				rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '0'; en_cnt <= '1';	-- en Up1a, valores por defecto, cambiando rst_cnt a 0 y en_cnt a 1
			
			when Up1b =>
				rst_b <= '0'; en_b <= '1'; sel <= "10"; rst_cnt <= '1'; en_cnt <= '0';	-- en Up1b, valores por defecto, cambiando en_b a 1 y sel a 10
			
			when Down0a =>
				rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '0'; en_cnt <= '1';	-- en Down0a, valores por defecto, cambiando rst_cnt a 0 y en_cnt a 1
			
			when Down0b =>
				rst_b <= '0'; en_b <= '1'; sel <= "01"; rst_cnt <= '1'; en_cnt <= '0';	-- en Down0b, valores por defecto, cambiando en_b a 1 y sel a 01
				
			when Down1a =>
				rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '0'; en_cnt <= '1';	-- en Down1a, valores por defecto, cambiando rst_cnt a 0 y en_cnt a 1
			
			when Down1b =>
				rst_b <= '0'; en_b <= '1'; sel <= "11"; rst_cnt <= '1'; en_cnt <= '0';	-- en Down1b, valores por defecto, cambiando en_b a 1 y sel a 11
			
			when others => 
				rst_b <= '0'; en_b <= '0'; sel <= "00"; rst_cnt <= '1'; en_cnt <= '0';
			
		END CASE;
end process;

end Behavioral;