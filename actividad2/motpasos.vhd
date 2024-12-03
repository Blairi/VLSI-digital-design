library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity MotPasos is
    port ( 
        reloj : in STD_LOGIC;                 -- Señal de reloj
        UD : in STD_LOGIC;                    -- Dirección (1 = adelante, 0 = atrás)
        rst : in STD_LOGIC;                   -- Señal de reset
        FH : in STD_LOGIC_VECTOR(1 downto 0); 
        led : out STD_LOGIC_VECTOR(3 downto 0); -- Salida para LEDs (refleja el estado del motor)
        MOT : out STD_LOGIC_VECTOR(3 downto 0); -- Salida para el motor paso a paso
        display : out STD_LOGIC_VECTOR(6 downto 0)  -- Salida para el display de 7 segmentos
    );
end MotPasos;

architecture behavioral of MotPasos is
    -- Declaración de señales internas
    signal contador_reloj : std_logic_vector(23 downto 0);  -- Contador para dividir el reloj
    signal reloj_dividido : std_logic;  -- Señal de reloj dividida
    type estado is (sm0, sm1, sm2, sm3);  -- Tipos de estado para la máquina de estados
    signal estado_actual, estado_siguiente : estado;  -- Estado presente y siguiente
    signal secuencia_motor : std_logic_vector(3 downto 0);  -- Control de las bobinas del motor
    signal contador_vueltas : std_logic_vector(3 downto 0) := "0000";  -- Contador de vueltas
    signal direccion_anterior : std_logic := '0';  -- Señal para detectar cambio de dirección
    signal contador_pasos : std_logic_vector(10 downto 0) := (others => '0');  -- Contador de pasos
begin

    -- Proceso para dividir el reloj
    process (reloj, rst)
    begin
        if rst = '0' then
            contador_reloj <= (others => '0');  -- Reinicia el contador si reset está activo
        elsif reloj'event and reloj = '1' then
            if contador_reloj = "101111101011110000" then  -- Valor para dividir el reloj
                contador_reloj <= (others => '0');  -- Reinicia el contador al llegar al límite
            else
                contador_reloj <= contador_reloj + 1;  -- Incrementa el contador en cada pulso
            end if;
        end if;
    end process;

    -- Generar la señal de reloj dividida
    reloj_dividido <= '1' when contador_reloj = "101111101011110000" else '0';  

    -- Máquina de estados para controlar el motor
    process (reloj_dividido, rst)
    begin
        if rst = '0' then
            estado_actual <= sm0;  -- Estado inicial
            contador_vueltas <= "0000";  -- Reinicia el contador de vueltas
            direccion_anterior <= '0';  -- Reinicia la dirección
            contador_pasos <= (others => '0');  -- Reinicia el contador de pasos
        elsif reloj_dividido'event and reloj_dividido = '1' then
            -- Detecta si cambia la dirección
            if UD /= direccion_anterior then
                contador_vueltas <= "0000";  -- Reinicia el contador de vueltas
                direccion_anterior <= UD;  -- Actualiza la dirección
                contador_pasos <= (others => '0');  -- Reinicia el contador de pasos
                estado_actual <= sm0;  -- Reinicia el estado
            else
                estado_actual <= estado_siguiente;  -- Transición de estado

                -- Si se alcanza el número máximo de pasos
                if contador_pasos = "11111111111" then  -- 2047 pasos
                    contador_pasos <= (others => '0');  -- Reinicia el contador de pasos
                    if contador_vueltas < "1001" then  -- Hasta 9 vueltas
                        contador_vueltas <= contador_vueltas + 1;  -- Incrementa el contador de vueltas
                    else
                        estado_actual <= sm0;  -- Reinicia la secuencia al llegar a 9 vueltas
                        contador_vueltas <= "0000";  -- Reinicia el contador de vueltas
                        direccion_anterior <= '0';  -- Reinicia la dirección
                        contador_pasos <= (others => '0');  -- Reinicia el contador de pasos
                    end if;
                else
                    contador_pasos <= contador_pasos + 1;  -- Incrementa el contador de pasos
                end if;
            end if;
        end if;
    end process;

    -- Proceso para definir las transiciones de estados
    process (estado_actual, UD)
    begin
        case (estado_actual) is
            when sm0 => 
                if UD = '1' then  -- Avanza a sm1 si UD es 1 (adelante)
                    estado_siguiente <= sm1;
                else  -- Retrocede a sm3 si UD es 0 (atrás)
                    estado_siguiente <= sm3;
                end if;
            when sm1 => 
                if UD = '1' then
                    estado_siguiente <= sm2;
                else
                    estado_siguiente <= sm0;
                end if;
            when sm2 => 
                if UD = '1' then
                    estado_siguiente <= sm3;
                else
                    estado_siguiente <= sm1;
                end if;
            when sm3 => 
                if UD = '1' then
                    estado_siguiente <= sm0;
                else
                    estado_siguiente <= sm2;
                end if;
            when others => 
                estado_siguiente <= sm0;  -- Estado por defecto
        end case;
    end process;

    -- Secuencia de activación de las bobinas del motor
    process (estado_actual)
    begin
        case estado_actual is
            when sm0 => secuencia_motor <= "1000";  -- Paso 1: Activar bobina A
            when sm1 => secuencia_motor <= "0100";  -- Paso 2: Activar bobina B
            when sm2 => secuencia_motor <= "0010";  -- Paso 3: Activar bobina C
            when sm3 => secuencia_motor <= "0001";  -- Paso 4: Activar bobina D
            when others => secuencia_motor <= "0000";  -- Apagar todas las bobinas
        end case;
    end process;

    -- Decodificador para el display de 7 segmentos (muestra el número de vueltas)
    process (contador_vueltas)
    begin
        case contador_vueltas is
            when "0000" => display <= "1000000";  -- Muestra 0
            when "0001" => display <= "1111001";  -- Muestra 1
            when "0010" => display <= "0100100";  -- Muestra 2
            when "0011" => display <= "0110000";  -- Muestra 3
            when "0100" => display <= "0011001";  -- Muestra 4
            when "0101" => display <= "0010010";  -- Muestra 5
            when "0110" => display <= "0000010";  -- Muestra 6
            when "0111" => display <= "1111000";  -- Muestra 7
            when "1000" => display <= "0000000";  -- Muestra 8
            when "1001" => display <= "0010000";  -- Muestra 9
            when others => display <= "1111111";  -- Display apagado
        end case;
    end process;

    -- Asignación de salidas
    MOT <= secuencia_motor;  -- Salida del motor
    led <= secuencia_motor;  -- Salida de los LEDs (igual al estado del motor)

end behavioral;
