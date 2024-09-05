library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity leds is
	Port ( reloj: in STD_LOGIC;
		-- agregamos 2 led mas
		led0 : out STD_LOGIC;
		led1 : out STD_LOGIC;
		led2 : out STD_LOGIC;
		led3 : out STD_LOGIC;
		led4 : out STD_LOGIC;
		led5 : out STD_LOGIC;
		led6 : out STD_LOGIC;
		led7 : out STD_LOGIC;
		led8 : out STD_LOGIC;
		led9 : out STD_LOGIC);
end Leds;

architecture Behavioral of Leds is
	
	-- CAMBIO
	-- Dirección de desplazamiento (1 para derecha a izquierda, 0 para izquierda a derecha)
	signal direccionModulo1: std_logic := '1';
	signal direccionModulo2: std_logic := '1';
	
	component divisor is Generic ( N : integer := 24);
		Port ( reloj : in std_logic;
			div_reloj : out std_logic);
	end component;

	component PWM is
		Port ( reloj_pwm : in STD_LOGIC;
			-- cambiamos el vector de 8 -> 10
			D : in STD_LOGIC_VECTOR (7 downto 0);
			S : out STD_LOGIC);
	end component;
	
	signal relojPWM : STD_LOGIC;
	signal relojCiclo : STD_LOGIC;
	
	-- El porcentaje es incorrecto, ya que se debe  calcular en base a l rango de la cuenta, es decir,
	--Sacar el 10% de 255, el 20% de  255 y pasarlo a hexadecimal
	signal a0 : STD_LOGIC_VECTOR (7 downto 0) := X"00"; -- agregamos led 0 -> intensidad % 10
	signal a1 : STD_LOGIC_VECTOR (7 downto 0) := X"05";
	signal a2 : STD_LOGIC_VECTOR (7 downto 0) := X"0A";
	signal a3 : STD_LOGIC_VECTOR (7 downto 0) := X"14";
	signal a4 : STD_LOGIC_VECTOR (7 downto 0) := X"1E";
	signal a5 : STD_LOGIC_VECTOR (7 downto 0) := X"28";
	signal a6 : STD_LOGIC_VECTOR (7 downto 0) := X"32";
	signal a7 : STD_LOGIC_VECTOR (7 downto 0) := X"3C";
	signal a8 : STD_LOGIC_VECTOR (7 downto 0) := X"46";
	signal a9 : STD_LOGIC_VECTOR (7 downto 0) := X"50"; -- agregamos led 9 -> intensidad % 100
	
	begin
		N1: divisor generic map (10) port map (reloj, relojPWM);
		N2: divisor generic map (23) port map (reloj, relojCiclo);
		
		-- mapeamos el led 0 a la signal 0
		P0: PWM port map (relojPWM, a0, led0);
		P1: PWM port map (relojPWM, a1, led1);
		P2: PWM port map (relojPWM, a2, led2);
		P3: PWM port map (relojPWM, a3, led3);
		P4: PWM port map (relojPWM, a4, led4);
		P5: PWM port map (relojPWM, a5, led5);
		P6: PWM port map (relojPWM, a6, led6);
		P7: PWM port map (relojPWM, a7, led7);
		P8: PWM port map (relojPWM, a8, led8);
		-- mapeamos el led 9 a la signal 9
		P9: PWM port map (relojPWM, a9, led9);
		
	process (relojCiclo)
		variable Cuenta : integer range 0 to 255 := 0;
		
		begin
			if relojCiclo='1' and relojCiclo'event then
--				a0 <= a9;
--				a1 <= a0;
--				a2 <= a1;
--				a3 <= a2;
--				a4 <= a3;
--				a5 <= a4;
--				a6 <= a5;
--				a7 <= a6;
--				a8 <= a7;
--				a9 <= a8;
				
				a9 <= a0;
				a8 <= a9;
				a7 <= a8;
				a6 <= a7;
				a5 <= a6;
				a4 <= a5;
				a3 <= a4;
				a2 <= a3;
				a1 <= a2;
				a0 <= a1;
			end if;
	end process;
	
end Behavioral;