library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM is
	Port ( reloj_pwm : in STD_LOGIC;
		D : in STD_LOGIC_VECTOR (7 downto 0);
		S : out STD_LOGIC);
end PWM;

architecture Behavioral of PWM is
begin

	process (reloj_pwm)
		variable cuenta : integer range 0 to 255 := 0;
		
		begin
			if reloj_pwm ='1' and reloj_pwm 'event then
			
				cuenta := (cuenta + 1) mod 256;
				
				if cuenta < D then
					S <= '1';
				else
					S <= '0';
				end if;
				
			end if;
		end process;
	
end behavioral;