library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity MotPasos is
    port ( 
        reloj : in STD_LOGIC;                
        UD : in STD_LOGIC;                    
        rst : in STD_LOGIC;                   
        FH : in STD_LOGIC_VECTOR(1 downto 0); 
        led : out STD_LOGIC_VECTOR(3 downto 0); 
        MOT : out STD_LOGIC_VECTOR(3 downto 0)  
    );
end MotPasos;

architecture behavioral of MotPasos is
    signal div : std_logic_vector(17 downto 0);  
    signal clks : std_logic;
    type est is (sm0, sm1, sm2, sm3);         
    signal pres_S, esta_next : est;              
    signal motor : std_logic_vector(3 downto 0); 
begin

    -- Proceso de división de frecuencia
    process (reloj, rst)
    begin
        if rst = '0' then
            div <= (others => '0');  
        elsif reloj'event and reloj = '1' then 
            -- Usar "101111101011110000" (195312 en decimal) para dividir la frecuencia
            if div = "101111101011110000" then  
                div <= (others => '0');  
            else
                div <= div + 1; 
            end if;
        end if;
    end process;

    -- Generación de la señal clks basada en el contador
    clks <= '1' when div = "101111101011110000" else '0';  

    -- Máquina de estados que controla el motor
    process (clks, rst)
    begin
        if rst = '0' then
            pres_S <= sm0;  
        elsif rising_edge(clks) then  
            pres_S <= esta_next ;  
        end if;
    end process;

    -- Lógica de transición de estados basada en la dirección (UD)
    process (pres_S, UD)
    begin
        case (pres_S) is
            when sm0 => 
                if UD = '1' then  
                    esta_next  <= sm1;
                else  
                    esta_next  <= sm3;
                end if;
            when sm1 => 
                if UD = '1' then
                    esta_next  <= sm2;
                else
                    esta_next  <= sm0;
                end if;
            when sm2 => 
                if UD = '1' then
                    esta_next  <= sm3;
                else
                    esta_next  <= sm1;
                end if;
            when sm3 => 
                if UD = '1' then
                    esta_next  <= sm0;
                else
                    esta_next  <= sm2;
                end if;
            when others => 
                esta_next  <= sm0; 
        end case;
    end process;

    -- Proceso para controlar las bobinas del motor con la nueva secuencia
    process (pres_S)
    begin
        case pres_S is
            when sm0 => motor <= "1000";  -- Paso 1: Activar bobina A
            when sm1 => motor <= "0100";  -- Paso 2: Activar bobina B
            when sm2 => motor <= "0010";  -- Paso 3: Activar bobina C
            when sm3 => motor <= "0001";  -- Paso 4: Activar bobina D
            when others => motor <= "0000";  -- Valor por defecto: apagar todas las bobinas
        end case;
    end process;

    -- Asignación de salidas para el motor y los LEDs
    MOT <= motor;  
    led <= motor;  -- Los LEDs reflejan el estado de las bobinas para debug

end behavioral;
