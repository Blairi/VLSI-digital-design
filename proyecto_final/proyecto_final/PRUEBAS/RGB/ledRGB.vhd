library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ledRGB is
    Port ( 
        reloj: in STD_LOGIC;
        ledR : out STD_LOGIC;  -- Componente Rojo
        ledG : out STD_LOGIC;  -- Componente Verde
        ledB : out STD_LOGIC   -- Componente Azul
    );
end ledRGB;

architecture Behavioral of ledRGB is
    signal relojCiclo : STD_LOGIC;  -- Señal de reloj para controlar el cambio de color

    component divisorRGB is
        Generic ( N : integer := 24);
        Port ( reloj : in std_logic;
               div_reloj : out std_logic);
    end component;

    -- Variable que almacena el estado del ciclo de color (0 = Rojo, 1 = Verde, 2 = Azul)
    signal colorStep: integer range 0 to 2 := 0;

begin
    -- Divisor para reducir la frecuencia del reloj y controlar el ciclo de cambio de color
    D1: divisorRGB generic map (23) port map (reloj, relojCiclo);

    -- Proceso que controla el ciclo de colores del LED RGB
    process (relojCiclo)
    begin
        if rising_edge(relojCiclo) then
            -- Ciclo de cambio entre Rojo, Verde y Azul
            case colorStep is
                when 0 =>
                    ledR <= '1';  -- Enciende Rojo
                    ledG <= '0';  -- Apaga Verde
                    ledB <= '0';  -- Apaga Azul
                    colorStep <= 1;  -- Siguiente paso es Verde
                when 1 =>
                    ledR <= '0';  -- Apaga Rojo
                    ledG <= '1';  -- Enciende Verde
                    ledB <= '0';  -- Apaga Azul
                    colorStep <= 2;  -- Siguiente paso es Azul
                when 2 =>
                    ledR <= '0';  -- Apaga Rojo
                    ledG <= '0';  -- Apaga Verde 
                    ledB <= '1';  -- Enciende Azul
                    colorStep <= 0;  -- Siguiente paso es Rojo
                when others =>
                    colorStep <= 0;  -- Reinicia el ciclo
            end case;
        end if;
    end process;

end Behavioral;
