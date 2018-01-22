

-- Simular 500 us


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_main IS
END test_main;
 
ARCHITECTURE behavior OF test_main IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_digital
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         up0 : IN  std_logic;
         down0 : IN  std_logic;
         up1 : IN  std_logic;
         down1 : IN  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
         dout : IN  std_logic;
         disp0 : OUT  std_logic;
         disp1 : OUT  std_logic;
         disp2 : OUT  std_logic;
         disp3 : OUT  std_logic;
         seg7 : OUT  std_logic_vector(6 downto 0);
         cs0 : OUT  std_logic;
         cs1 : OUT  std_logic;
         sclk : OUT  std_logic;
         din : OUT  std_logic
--         leds : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal up0 : std_logic := '0';
   signal down0 : std_logic := '0';
   signal up1 : std_logic := '0';
   signal down1 : std_logic := '0';
   signal valor_switches : std_logic_vector(5 downto 0) := (others => '0');
   signal dout : std_logic := '0';

 	--Outputs
   signal disp0 : std_logic;
   signal disp1 : std_logic;
   signal disp2 : std_logic;
   signal disp3 : std_logic;
   signal seg7 : std_logic_vector(6 downto 0);
   signal cs_adc : std_logic;
   signal cs_dac : std_logic;
   signal sclk_adc_dac : std_logic;
   signal din_adc_dac : std_logic;
   signal leds : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_digital PORT MAP (
          clk => clk,
          rst => rst,
          up0 => up0,
          down0 => down0,
          up1 => up1,
          down1 => down1,
          sw => valor_switches,
          dout => dout,
          disp0 => disp0,
          disp1 => disp1,
          disp2 => disp2,
          disp3 => disp3,
          seg7 => seg7,
          cs0 => cs_adc,
          cs1 => cs_dac,
          sclk => sclk_adc_dac,
          din => din_adc_dac
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- reset signal generation
   rst <= '1', '0' after 500 ns;


 -- DOUT generation (ADC response)
   DOUT_response: process
	  variable adc_value : std_logic_vector(11 downto 0);
	  variable dout_value : std_logic_vector(15 downto 0);
   begin		
		dout <= '0';
      wait for 1 ns;

      -- PRIMER DATO ADC
      wait until CS_adc'event and CS_adc = '0';
		adc_value := x"f0f";   							-- VALOR: "1111 0000 1111"
		dout_value := '0' & adc_value & "000";    -- construye la trama de 16 bits 
      for i in 0 to 7 loop
  		  dout <= '0';
        wait until sclk_adc_dac'event and sclk_adc_dac = '0';   -- espera la peticion
		end loop;
      for i in 15 downto 0 loop
		  dout <= dout_value(i);
        wait until sclk_adc_dac'event and sclk_adc_dac = '0';   -- entrega 1 bit
		end loop;

      -- SEGUNDO DATO ADC
      wait until CS_adc'event and CS_adc = '0';
		adc_value := x"335";   						   -- VALOR: "0011 0011 0101"
		dout_value := '0' & adc_value & "000";    -- construye la trama
      for i in 0 to 7 loop
  		  dout <= '0';
        wait until sclk_adc_dac'event and sclk_adc_dac= '0';   -- espera la peticion
		end loop;
      for i in 15 downto 0 loop
		  dout <= dout_value(i);
        wait until sclk_adc_dac'event and sclk_adc_dac = '0';   -- entrega 1 bit
		end loop;

      -- TERCER DATO ADC
      wait until CS_adc'event and CS_adc = '0';
		adc_value := x"b5d";   							-- VALOR: "1011 0101 1101"
		dout_value := '0' & adc_value & "000";    -- construye la trama
      for i in 0 to 7 loop
  		  dout <= '0';
        wait until sclk_adc_dac'event and sclk_adc_dac = '0';   -- espera la peticion
		end loop;
      for i in 15 downto 0 loop
		  dout <= dout_value(i);
        wait until sclk_adc_dac'event and sclk_adc_dac = '0';   -- entrega 1 bit
		end loop;

		dout<='0';
		wait for 50 us;
		
      wait;
   end process;

 valor_switches<="010101" after 220 us,"000000" after 350 us;
 
    
END;
