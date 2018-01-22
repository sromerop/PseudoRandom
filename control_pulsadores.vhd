----------------------------------------------------------------------------------
-- CONTROL DE PULSADORES
-- Fichero TOP del módulo, que describe la conexión de módulos MooreFSM, Reg_b
-- y contador_100ms; y se encarga del control de los pulsadores.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity control_pulsadores is
    Port ( clk : in  STD_LOGIC;	-- entrada del reloj
           Rst : in  STD_LOGIC;	-- entrada del reset
           Up0 : in  STD_LOGIC;	-- pulsador que incrementa 1
           Down0 : in  STD_LOGIC;	-- pulsador que decrementa 1
           Up1 : in  STD_LOGIC;	-- pulsador que incrementa 10
           Down1 : in  STD_LOGIC;	-- pulsador que decrementa 10
           b : out  STD_LOGIC_VECTOR (5 downto 0));	-- salida con el valor del código introducido
end control_pulsadores;

architecture Behavioral of control_pulsadores is

component MooreFSM
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
	end component;
	
component contador_100ms
	Port ( clk : in  STD_LOGIC;	-- entrada del reloj
          rst_cnt : in  STD_LOGIC;	-- entrada del reset del contador
          en_cnt : in  STD_LOGIC;	-- entrada que habilita el contador
          cnt_100ms : out  STD_LOGIC);	-- salida de contador_100ms
end component;
	
component Reg_b
	Port ( clk : in  STD_LOGIC;	-- entrada del reloj
          rst_b : in  STD_LOGIC;	-- entrada que resetea el registro
          en_b : in  STD_LOGIC;	-- entrada que habilita el registro
          sel : in  STD_LOGIC_VECTOR (1 downto 0);	-- entrada del selector
          b : out  STD_LOGIC_VECTOR (5 downto 0));	-- salida con el valor del código introducido
end component;
	
	-- señales auxiliares para realizar el port map
	signal  cnt_100ms, rst_cnt, en_cnt, rst_b, en_b: STD_LOGIC;
	signal sel : STD_LOGIC_VECTOR (1 downto 0);

begin

	U1 : MooreFSM port map (clk, Up0, Down0, Up1, Down1, Rst, cnt_100ms, rst_cnt, en_cnt, rst_b, en_b, sel);
	U2 : contador_100ms port map (clk, rst_cnt, en_cnt, cnt_100ms);
	U3 : Reg_b port map (clk, rst_b, en_b, sel, b);
	
end Behavioral;