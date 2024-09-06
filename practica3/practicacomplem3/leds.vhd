library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity leds is
    Port ( 
        reloj: in STD_LOGIC;
        switch: in STD_LOGIC; -- Selector de módulo
        led0 : out STD_LOGIC;
        led1 : out STD_LOGIC;
        led2 : out STD_LOGIC;
        led3 : out STD_LOGIC;
        led4 : out STD_LOGIC;
        led5 : out STD_LOGIC;
        led6 : out STD_LOGIC;
        led7 : out STD_LOGIC;
        led8 : out STD_LOGIC;
        led9 : out STD_LOGIC
    );
end leds;

architecture Behavioral of leds is
    signal relojPWM : STD_LOGIC;
    signal relojCiclo : STD_LOGIC;

    -- Intensidades para el módulo 1
    signal a0 : STD_LOGIC_VECTOR (7 downto 0);
    signal a1 : STD_LOGIC_VECTOR (7 downto 0);
    signal a2 : STD_LOGIC_VECTOR (7 downto 0);
    signal a3 : STD_LOGIC_VECTOR (7 downto 0);
    signal a4 : STD_LOGIC_VECTOR (7 downto 0);
    signal a5 : STD_LOGIC_VECTOR (7 downto 0);
    signal a6 : STD_LOGIC_VECTOR (7 downto 0);
    signal a7 : STD_LOGIC_VECTOR (7 downto 0);
    signal a8 : STD_LOGIC_VECTOR (7 downto 0);
    signal a9 : STD_LOGIC_VECTOR (7 downto 0);

    -- Dirección de desplazamiento del módulo 1
    signal direccionModulo1: std_logic := '1';

    -- Intensidad del módulo 2
    signal intensidad : unsigned(7 downto 0) := to_unsigned(25, 8);  -- Intensidad inicial al 10%
    type intensidad_array is array(0 to 7) of unsigned(7 downto 0);
    constant INTENSIDADES: intensidad_array := (
        to_unsigned(25, 8),  -- 10%
        to_unsigned(51, 8),  -- 20%
        to_unsigned(76, 8),  -- 30%
        to_unsigned(102, 8), -- 40%
        to_unsigned(127, 8), -- 50%
        to_unsigned(153, 8), -- 60%
        to_unsigned(178, 8), -- 70%
        to_unsigned(204, 8)  -- 80%
    );
    signal direccionModulo2: std_logic := '1';

    component divisor is Generic ( N : integer := 24);
        Port ( reloj : in std_logic;
               div_reloj : out std_logic);
    end component;

    component PWM is
        Port ( reloj_pwm : in STD_LOGIC;
               D : in STD_LOGIC_VECTOR (7 downto 0);
               S : out STD_LOGIC);
    end component;

    signal currentSwitchState : std_logic := '0';  -- Estado actual del switch

begin
    -- Divisor para el reloj
    D1: divisor generic map (10) port map (reloj, relojPWM);
    D2: divisor generic map (23) port map (reloj, relojCiclo);

    -- PWM para cada LED
    P0: PWM port map (relojPWM, a0, led0);
    P1: PWM port map (relojPWM, a1, led1);
    P2: PWM port map (relojPWM, a2, led2);
    P3: PWM port map (relojPWM, a3, led3);
    P4: PWM port map (relojPWM, a4, led4);
    P5: PWM port map (relojPWM, a5, led5);
    P6: PWM port map (relojPWM, a6, led6);
    P7: PWM port map (relojPWM, a7, led7);
    P8: PWM port map (relojPWM, a8, led8);
    P9: PWM port map (relojPWM, a9, led9);

    process (relojCiclo)
        variable Cuenta : integer range 0 to 255 := 0;
        variable Cuenta2 : integer range 0 to 7 := 0;  -- Índice para el módulo 2
    begin
        if rising_edge(relojCiclo) then
            if switch /= currentSwitchState then
                -- Si el switch ha cambiado, reseteamos el estado
                if switch = '0' then
                    -- Reiniciamos las señales del módulo 1
                    a0 <= X"00";
                    a1 <= X"19";
                    a2 <= X"33";
                    a3 <= X"4C";
                    a4 <= X"66";
                    a5 <= X"80";
                    a6 <= X"99";
                    a7 <= X"B3";
                    a8 <= X"CC";
                    a9 <= X"E6";
                    direccionModulo1 <= '1';
                else
                    -- Reiniciamos las señales del módulo 2
                    Cuenta2 := 0;
                    intensidad <= INTENSIDADES(Cuenta2);
                    direccionModulo2 <= '1';
                end if;
                currentSwitchState <= switch;
            else
                if switch = '0' then
                    -- Módulo 1: Desplazamiento de intensidad de LEDs
                    if direccionModulo1 = '1' then
                        a0 <= a9;
                        a1 <= a0;
                        a2 <= a1;
                        a3 <= a2;
                        a4 <= a3;
                        a5 <= a4;
                        a6 <= a5;
                        a7 <= a6;
                        a8 <= a7;
                        a9 <= a8;

                        if a9 = X"00" then
                            direccionModulo1 <= '0';
                        end if;
                    else
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

                        if a0 = X"E6" then
                            direccionModulo1 <= '1';
                        end if;
                    end if;
                else
                    -- Módulo 2: Cambio de intensidad de todos los LEDs al mismo tiempo
                    if direccionModulo2 = '1' then
                        if Cuenta2 < 7 then
                            Cuenta2 := Cuenta2 + 1;
                        else
                            direccionModulo2 <= '0';
                        end if;
                    else
                        if Cuenta2 > 0 then
                            Cuenta2 := Cuenta2 - 1;
                        else
                            direccionModulo2 <= '1';
                        end if;
                    end if;
                    intensidad <= INTENSIDADES(Cuenta2);
                    a0 <= std_logic_vector(intensidad);
                    a1 <= std_logic_vector(intensidad);
                    a2 <= std_logic_vector(intensidad);
                    a3 <= std_logic_vector(intensidad);
                    a4 <= std_logic_vector(intensidad);
                    a5 <= std_logic_vector(intensidad);
                    a6 <= std_logic_vector(intensidad);
                    a7 <= std_logic_vector(intensidad);
                    a8 <= std_logic_vector(intensidad);
                    a9 <= std_logic_vector(intensidad);
                end if;
            end if;
        end if;
    end process;

end Behavioral;