-- Declaración de las bibliotecas estándar de IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;        -- Biblioteca para tipos de datos estándar de lógica
use IEEE.STD_LOGIC_ARITH.ALL;       -- Biblioteca para operaciones aritméticas (obsoleta)
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- Biblioteca para operaciones aritméticas sin signo (obsoleta)

-- Definición de la entidad 'PWM'
entity PWM is
    Port (
        reloj_pwm : in  STD_LOGIC;                    -- Señal de reloj de entrada para el PWM
        D         : in  STD_LOGIC_VECTOR (7 downto 0); -- Ancho de pulso (duty cycle) en 8 bits
        S         : out STD_LOGIC                      -- Señal PWM de salida
    );
end PWM;

-- Definición de la arquitectura 'Behavioral' para la entidad 'PWM'
architecture Behavioral of PWM is
begin
    -- Proceso principal que genera la señal PWM
    process (reloj_pwm)
        variable cuenta : integer range 0 to 255 := 0; -- Variable contador para el ciclo PWM, rango de 0 a 255
    begin
        -- Detecta un flanco de subida en la señal de reloj 'reloj_pwm'
        if reloj_pwm = '1' and reloj_pwm'event then
            -- Incrementa el contador y lo limita a 0-255 usando módulo 256
            cuenta := (cuenta + 1) mod 256;
            
            -- Compara el valor del contador con el ancho de pulso 'D'
            if cuenta < D then
                S <= '1'; -- Si el contador es menor que 'D', la señal PWM 'S' se establece en alto ('1')
            else
                S <= '0'; -- Si el contador es mayor o igual que 'D', la señal PWM 'S' se establece en bajo ('0')
            end if;
        end if;
    end process;
end Behavioral;
