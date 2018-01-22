--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
library STD;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

ENTITY pseudo_random_tb IS
END pseudo_random_tb;
 
ARCHITECTURE behavior OF pseudo_random_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pseudo_random
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_random : IN  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
         b : IN  std_logic_vector(5 downto 0);
         valor_ADC : IN  std_logic_vector(11 downto 0);
         end_random : OUT  std_logic;
         valor_DAC : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_random : std_logic := '0';
   signal sw : std_logic_vector(5 downto 0) := (others => '0');
   signal b : std_logic_vector(5 downto 0) := (others => '0');
   signal valor_ADC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_random : std_logic;
   signal valor_DAC : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	constant Rst_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pseudo_random PORT MAP (
          clk => clk,
          Rst => Rst,
          start_random => start_random,
          sw => sw,
          b => b,
          valor_ADC => valor_ADC,
          end_random => end_random,
          valor_DAC => valor_DAC
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	-- start_random process
	start_random_process :process
   begin
		start_random <= '0';
		wait for 125us;
		start_random <= '1';
		wait for 20ns;
		start_random <= '0';
   end process;
	
   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here 
		
		rst<='1';
		wait for 500 ns;
		rst <='0';
		wait for 143 us;
		valor_ADC <="011100001111";
		b <= "001100";
		sw <= "001100";
		wait for 50 us;
		rst<='1';
		wait for 500 ns;
		rst <='0';
		wait for 143 us;
		valor_ADC <="011100001111";
		b <= "001100";
		sw <= "001000";
      wait;
   end process;

END;