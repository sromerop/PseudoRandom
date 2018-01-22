----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:11:19 12/06/2015 
-- Design Name: 
-- Module Name:    counter - arch_counter 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( pulse : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           q3, q2, q1, q0 : out  STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture arch_counter of counter is

begin

process(rst, clk)

variable centesimas, decimas, unidades, decenas: STD_LOGIC_VECTOR (3 downto 0):="0000";
variable agrupa: STD_LOGIC_VECTOR (7 downto 0):="00000000";--Cada vez que esta variable sea un periodo, suma una milesima
																				--Mi periodo es 500ns
																				--0.01ms/500ns=20

begin

if (rst = '1' or (pulse'event and pulse='1')) then
	
	centesimas:="0000";
	decimas:="0000";
	unidades:="0000";
	decenas:="0000";
	agrupa:="00000000";
	
elsif (clk'event and clk='1') then
		
		if pulse = '1' then
			agrupa:=agrupa+1;
			
			if agrupa="00010100" then
				agrupa:="00000000";
				centesimas:= centesimas+1;
			
				if centesimas="1010" then
					decimas:=decimas+1;
					centesimas:="0000";
				
					if decimas="1010" then
						decimas:="0000";
						unidades:=unidades+1;
					
						if unidades="1010" then
							unidades:="0000";
							decenas:=decenas+1;
						
						end if;
					end if;
				end if;
			end if;
		end if;
end if;

q3<=decenas;
q2<=unidades;
q1<=decimas;
q0<=centesimas;

end process;

end arch_counter;

