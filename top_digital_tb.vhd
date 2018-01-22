--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:01:30 11/30/2016
-- Design Name:   
-- Module Name:   C:/Documents and Settings/alumno/Mis documentos/VHDL2/VHDL2/top_digital_tb.vhd
-- Project Name:  VHDL2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_digital
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
library STD;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

ENTITY top_digital_tb IS
END top_digital_tb;
 
ARCHITECTURE behavior OF top_digital_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_digital
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
         DOUT : IN  std_logic;
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0);
         CS0 : OUT  std_logic;
         CS1 : OUT  std_logic;
         SCLK : OUT  std_logic;
         DIN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal pulsadores : std_logic_vector(3 downto 0);
   signal sw : std_logic_vector(5 downto 0) := (others => '0');
   signal DOUT : std_logic := '0';

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(6 downto 0);
   signal CS0 : std_logic;
   signal CS1 : std_logic;
   signal SCLK : std_logic;
   signal DIN : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   -- constant Rst_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_digital PORT MAP (
          clk => clk,
          Rst => Rst,
          Up0 => pulsadores(0),
          Down0 => pulsadores(1),
          Up1 => pulsadores(2),
          Down1 => pulsadores(3),
          sw => sw,
          DOUT => DOUT,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          Seg7 => Seg7,
          CS0 => CS0,
          CS1 => CS1,
          SCLK => SCLK,
          DIN => DIN
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	-- start_ADC process
	pulsadores_process :process
   begin
		pulsadores <= "0000";
		wait for 125us;
		pulsadores <= "0100";
		wait for 125us;
		pulsadores <= "0000";
		wait for 100ms;
		pulsadores <= "0001";
		wait for 125us;
		pulsadores <= "0000";
		wait for 100ms;
		pulsadores <= "0000";
   end process;
	
   -- Stimulus process
   stim_proc: process
   begin		
      
      -- insert stimulus here 
		sw <= "001011";
		rst<='1';
		wait for 500 ns;
		rst <='0';
		wait for 143 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait for 2 us;
		DOUT <='1';
		wait for 2 us;
		DOUT <='0';
		wait;
   end process;

END;
