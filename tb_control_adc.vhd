--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:09:46 10/25/2016
-- Design Name:   
-- Module Name:   C:/VHDL_examples/control_adc/tb_control_adc.vhd
-- Project Name:  control_adc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cont_adc
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_control_adc IS
END tb_control_adc;
 
ARCHITECTURE behavior OF tb_control_adc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_adc
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         dout_serie_ADC : IN  std_logic;
         end_ADC : OUT  std_logic;
         cs_ADC : OUT  std_logic;
         cclk_ADC : OUT  std_logic;
         din_serie_ADC : OUT  std_logic;
         valor_ADC : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal dout_serie_ADC : std_logic := '0';

 	--Outputs
   signal end_ADC : std_logic;
   signal cs_ADC : std_logic;
   signal cclk_ADC : std_logic;
   signal din_serie_ADC : std_logic;
   signal valor_ADC : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_ADC_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_adc PORT MAP (
          rst => rst,
          clk => clk,
          dout_serie_ADC => dout_serie_ADC,
          end_ADC => end_ADC,
          cs_ADC => cs_ADC,
          cclk_ADC => cclk_ADC,
          din_serie_ADC => din_serie_ADC,
          valor_ADC => valor_ADC
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   

   -- Stimulus process
   stim_proc: process
   begin		
      
      dout_serie_ADC <='0';
		rst<='1';
		wait for 500 ns;
		rst <='0';
		wait for 143 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='0';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='0';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='0';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='0';
		wait for 2 us;
		dout_serie_ADC <='1';
		wait for 2 us;
		dout_serie_ADC <='0';
		wait;
   end process;

END;
