library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlElevador is
    Port (
        reloj : in std_logic;
        reset : in std_logic;
        A1 : in std_logic;
        A2 : in std_logic;
        A3 : in std_logic;
        S : out std_logic;
        SUBIR1 : out std_logic;
        SUBIR2 : out std_logic;
        BAJAR1 : out std_logic;
        BAJAR2 : out std_logic
    );
end ControlElevador;

architecture Behavioral of ControlElevador is
    -- Definimos los estados
    type estado_type is (PISO1, PISO2, PISO3);
    signal estado_actual, estado_siguiente : estado_type;

begin
    -- Proceso para la transición de estados
    process (reloj, reset)
    begin
        if reset = '1' then
            estado_actual <= PISO1;  -- El elevador comienza en el piso 1
        elsif rising_edge(reloj) then
            estado_actual <= estado_siguiente;
        end if;
    end process;

    -- Lógica de la máquina de estados
    process (estado_actual, A1, A2, A3)
    begin
        -- Valores por defecto para las salidas
        S <= '0';
        SUBIR1 <= '0';
        SUBIR2 <= '0';
        BAJAR1 <= '0';
        BAJAR2 <= '0';

        case estado_actual is
            when PISO1 =>
                if A1 = '1' then
                    S <= '1';  -- Mantenerse en el piso 1
                    estado_siguiente <= PISO1;
                elsif A2 = '1' then
                    SUBIR1 <= '1';  -- Subir al piso 2
                    estado_siguiente <= PISO2;
                elsif A3 = '1' then
                    SUBIR2 <= '1';  -- Subir al piso 3
                    estado_siguiente <= PISO3;
                else
                    estado_siguiente <= PISO1;
                end if;
            
            when PISO2 =>
                if A2 = '1' then
                    S <= '1';  -- Mantenerse en el piso 2
                    estado_siguiente <= PISO2;
                elsif A1 = '1' then
                    BAJAR1 <= '1';  -- Bajar al piso 1
                    estado_siguiente <= PISO1;
                elsif A3 = '1' then
                    SUBIR1 <= '1';  -- Subir al piso 3
                    estado_siguiente <= PISO3;
                else
                    estado_siguiente <= PISO2;
                end if;
            
            when PISO3 =>
                if A3 = '1' then
                    S <= '1';  -- Mantenerse en el piso 3
                    estado_siguiente <= PISO3;
                elsif A2 = '1' then
                    BAJAR1 <= '1';  -- Bajar al piso 2
                    estado_siguiente <= PISO2;
                elsif A1 = '1' then
                    BAJAR2 <= '1';  -- Bajar al piso 1
                    estado_siguiente <= PISO1;
                else
                    estado_siguiente <= PISO3;
                end if;
            
            when others =>
                estado_siguiente <= PISO1;  -- Estado por defecto
        end case;
    end process;

end Behavioral;
