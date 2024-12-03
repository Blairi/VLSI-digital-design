-- Declaración de las bibliotecas estándar de IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- Biblioteca para tipos de datos estándar de lógica

-- Definición de la entidad 'servomotor'
entity servomotor is     
    Port (
        reloj_sv   : in  STD_LOGIC;     -- Señal de reloj de entrada
        Pini       : in  STD_LOGIC;     -- Señal para posición inicial (0 grados)
        Pfin       : in  STD_LOGIC;     -- Señal para posición final (180 grados)
        control    : out STD_LOGIC      -- Señal PWM de salida para controlar el servomotor
    ); 
end servomotor;

-- Definición de la arquitectura 'Behavioral' para la entidad 'servomotor'
architecture Behavioral of servomotor is

    -- Declaración del componente 'divisor' utilizado para dividir la frecuencia del reloj
    component divisor is
        Port (
            reloj     : in std_logic;  -- Señal de reloj de entrada
            div_reloj : out std_logic  -- Señal de reloj dividida de salida
        );    
    end component;

    -- Declaración del componente 'PWM' utilizado para generar la señal PWM
    component PWM is       
        Port (
            reloj_pwm : in  STD_LOGIC;                    -- Señal de reloj para el PWM
            D         : in  STD_LOGIC_VECTOR (7 downto 0);-- Ancho de pulso (duty cycle) en 8 bits
            S         : out STD_LOGIC                     -- Señal PWM de salida
        );    
    end component;

    -- Declaración de señales internas
    signal reloj_serv   : STD_LOGIC;                          -- Señal de reloj dividida para el servomotor
    signal ancho        : STD_LOGIC_VECTOR (7 downto 0) := X"0F"; -- Ancho de pulso inicial (1.5 ms, posición neutra)

begin    
    -- Instanciación del componente 'divisor' (U1)
    U1: divisor port map (
        reloj     => reloj_sv,    -- Conexión de la señal de reloj de entrada
        div_reloj => reloj_serv   -- Conexión de la señal de reloj dividida de salida
    );   

    -- Instanciación del componente 'PWM' (U2)
    U2: PWM port map (
        reloj_pwm => reloj_serv,  -- Conexión de la señal de reloj dividida
        D         => ancho,       -- Conexión del ancho de pulso (duty cycle)
        S         => control      -- Conexión de la señal PWM de salida
    );    
    	
    -- Proceso para controlar el servomotor en base a las señales Pini y Pfin
    process (reloj_serv, Pini, Pfin)
    begin       
        -- Detección del flanco de subida en 'reloj_serv'
        if rising_edge(reloj_serv) then
            if Pini = '1' then
                ancho <= X"07"; -- 1 ms (Posición inicial, 0 grados)
            elsif Pfin = '1' then
                ancho <= X"1F"; -- 2 ms (Posición final, 180 grados)
            end if;
        end if;
    end process;

end Behavioral;
