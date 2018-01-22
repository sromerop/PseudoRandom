----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:45 12/06/2015 
-- Design Name: 
-- Module Name:    CP - arch_CP 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CP is
    Port ( pulse : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           decenas : out  STD_LOGIC_VECTOR (3 downto 0);
           unidades : out  STD_LOGIC_VECTOR (3 downto 0);
           decimas : out  STD_LOGIC_VECTOR (3 downto 0);
           centesimas : out  STD_LOGIC_VECTOR (3 downto 0));
end CP;

architecture arch_CP of CP is

	component counter
		Port ( pulse : in  STD_LOGIC;
				rst : in  STD_LOGIC;
				clk : in  STD_LOGIC;
				q3, q2, q1, q0 : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component registro
		Port ( clk : in  STD_LOGIC;
				rst : in  STD_LOGIC;
				data : in  STD_LOGIC_VECTOR (3 downto 0);
				q : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;

	signal cuenta3, cuenta2, cuenta1, cuenta0 : STD_LOGIC_VECTOR (3 downto 0);

begin

	U1 : counter port map (pulse, rst, clk, cuenta3, cuenta2, cuenta1, cuenta0);
	U2 : registro port map (pulse, rst, cuenta3, decenas);
	U3 : registro port map (pulse, rst, cuenta2, unidades);
	U4 : registro port map (pulse, rst, cuenta1, decimas);
	U5 : registro port map (pulse, rst, cuenta0, centesimas);

end arch_CP;

