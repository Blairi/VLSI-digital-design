library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlador_servo_ultrasonico is
    Port (
        clk         : in  STD_LOGIC;      -- Señal de reloj
        sensor_eco  : in  STD_LOGIC;      -- Señal del sensor ultrasónico (eco)
        sensor_disp : out STD_LOGIC;      -- Señal del sensor ultrasónico (trigger)
        control     : out STD_LOGIC;      -- Señal PWM de salida para controlar el servomotor
        display     : out STD_LOGIC_VECTOR(6 downto 0);  -- Señal para el display de 7 segmentos
        debug_pini  : out STD_LOGIC;      -- Señal de depuración para verificar Pini
        debug_pfin  : out STD_LOGIC       -- Señal de depuración para verificar Pfin
    );
end controlador_servo_ultrasonico;

architecture Behavioral of controlador_servo_ultrasonico is

    -- Definir los límites de distancia en centímetros
    constant LIMITE_INFERIOR: natural := 13;  -- 13 cm
    constant LIMITE_SUPERIOR: natural := 19;  -- 19 cm

    -- Señales internas para la distancia medida por el sensor ultrasónico
    signal centimetros: unsigned(15 downto 0) := (others => '0');
    signal activar_servo : STD_LOGIC;

    -- Declaración de señales para el servomotor
    signal Pini_sig, Pfin_sig : STD_LOGIC;

    -- Señales de depuración
    signal debug_pini_sig, debug_pfin_sig : STD_LOGIC;

    -- Contador para simulación de eco
    signal cuenta: unsigned(15 downto 0) := (others => '0');
    signal eco_activo: std_logic := '0';

    -- Instanciamos el componente del servomotor
    component servomotor
        Port (
            reloj_sv : in  STD_LOGIC;
            Pini     : in  STD_LOGIC;
            Pfin     : in  STD_LOGIC;
            control  : out STD_LOGIC
        );
    end component;

begin

    -- Proceso para simular el sensor ultrasónico (o usar la lógica correcta del eco)
    sensor_ultrasonico: process(clk)
    begin
        if rising_edge(clk) then
            -- Simulación de eco (o reemplazar por la lógica real de eco)
            if eco_activo = '1' then
                if cuenta = 0 then
                    cuenta <= to_unsigned(200, 16);  -- Valor de cuenta simulado (equivalente a una distancia de prueba)
                    centimetros <= to_unsigned(14, 16); -- Distancia simulada de 14 cm
                else
                    cuenta <= cuenta - 1;
                end if;
            end if;

            -- Actualiza el display con la distancia medida
            display <= std_logic_vector(to_unsigned(to_integer(centimetros), 7));
        end if;
    end process;

    -- Lógica para activar o desactivar el servomotor según la distancia
    process(centimetros)
    begin
        -- Convertir 'centimetros' a natural para la comparación
        if (to_integer(centimetros) >= LIMITE_INFERIOR) and (to_integer(centimetros) <= LIMITE_SUPERIOR) then
            activar_servo <= '1';  -- Activa el servomotor si la distancia está en el rango
        else
            activar_servo <= '0';  -- Desactiva el servomotor si la distancia está fuera del rango
        end if;
    end process;

    -- Asignación de las señales Pini y Pfin
    Pini_sig <= '1' when activar_servo = '0' else '0';  -- Mueve a 0 grados si 'activar_servo' es 0
    Pfin_sig <= '1' when activar_servo = '1' else '0';  -- Mueve a 180 grados si 'activar_servo' es 1

    -- Instanciación del componente del servomotor
    U_servomotor: servomotor
        Port map (
            reloj_sv => clk,
            Pini     => Pini_sig,
            Pfin     => Pfin_sig,
            control  => control
        );

    -- Señales de depuración para Pini y Pfin
    debug_pini <= Pini_sig;
    debug_pfin <= Pfin_sig;

end Behavioral;
