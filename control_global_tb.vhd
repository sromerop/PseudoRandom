--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:08:11 12/01/2016
-- Design Name:   
-- Module Name:   C:/Users/pablo/Desktop/olikujyhtgrfd/celt/control_global_tb.vhd
-- Project Name:  celt
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_global
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
 
ENTITY control_global_tb IS
END control_global_tb;
 
ARCHITECTURE behavior OF control_global_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_global
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         end_ADC : IN  std_logic;
         end_random : IN  std_logic;
         end_DAC : IN  std_logic;
         start_ADC : OUT  std_logic;
         start_random : OUT  std_logic;
         start_DAC : OUT  std_logic;
         global_st : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal end_ADC : std_logic := '0';
   signal end_random : std_logic := '0';
   signal end_DAC : std_logic := '0';

 	--Outputs
   signal start_ADC : std_logic;
   signal start_random : std_logic;
   signal start_DAC : std_logic;
   signal global_st : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant Rst_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_global PORT MAP (
          clk => clk,
          Rst => Rst,
          end_ADC => end_ADC,
          end_random => end_random,
          end_DAC => end_DAC,
          start_ADC => start_ADC,
          start_random => start_random,
          start_DAC => start_DAC,
          global_st => global_st
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
      -- insert stimulus here 
		end_ADC  <= '0';
		end_random <= '0';
   	end_DAC <= '0';
		rst<='1';
		wait for 500 ns;
		rst <='0';
		wait for 143 us;
		end_ADC  <= '1';
		end_random <= '0';
   	end_DAC <= '0';
		wait for 143 us;
		end_ADC  <= '0';
		end_random <= '1';
		end_DAC <= '0';
		wait for 143 us;
   	end_DAC <= '1';
		end_ADC  <= '0';
		end_random <= '0';
	
	
      wait;
   end process;

END;
