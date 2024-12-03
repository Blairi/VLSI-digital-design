-- Declaración de las bibliotecas estándar de IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;        -- Biblioteca para tipos de datos estándar de lógica
use IEEE.STD_LOGIC_ARITH.ALL;       -- Biblioteca para operaciones aritméticas (obsoleta)
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- Biblioteca para operaciones aritméticas sin signo (obsoleta)

-- Definición de la entidad 'divisor'
entity divisor is
    Port (
        reloj     : in  STD_LOGIC;     -- Señal de reloj de entrada
        div_reloj : out STD_LOGIC      -- Señal de reloj dividida de salida
    );
end divisor;

-- Definición de la arquitectura 'behavioral' para la entidad 'divisor'
architecture behavioral of divisor is
begin
    -- Proceso principal que divide la frecuencia del reloj de entrada
    process (reloj)
        constant N      : integer := 11;                 -- Constante que determina la división del reloj
        variable cuenta  : STD_LOGIC_VECTOR (27 downto 0) := X"0000000"; -- Contador de 28 bits inicializado a 0
    begin
        -- Detecta un flanco de subida en la señal de reloj 'reloj'
        if rising_edge(reloj) then
            cuenta := cuenta + 1; -- Incrementa el contador en cada flanco de subida
        end if;

        -- Asigna el valor del bit en la posición 'N' del contador a 'div_reloj'
        div_reloj <= cuenta(N);
    end process;
end Behavioral;

-- Comentarios sobre el período de la señal de salida en función del valor de N para un reloj de 50 MHz:
-- 27 ~ 5.37s, 26 ~ 2.68s, 25 ~ 1.34s, 24 ~ 671ms, 23 ~ 336 ms
-- 22 ~ 168 ms, 21 ~ 83.9 ms, 20 ~ 41.9 ms, 19 ~ 21 ms, 18 ~ 10.5 ms
-- 17 ~ 5.24 ms, 16 ~ 2.62 ms, 15 ~ 1.31 ms, 14 ~ 655 us, 13 ~ 328 us
-- 12 ~ 164 us, 11 ~ 81.9 us, 10 ~ 41 us, 9 ~ 20.5 us, 8 ~ 10.2 us
