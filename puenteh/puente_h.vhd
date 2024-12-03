library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity puente_h is
    Port(
        sw1 : in std_logic;  -- Switch 1 para controlar la polaridad
        sw2 : in std_logic;  -- Switch 2 para controlar la polaridad
        in1 : out std_logic; -- Entrada 1 del puente H
        in2 : out std_logic  -- Entrada 2 del puente H
    );
end puente_h;

architecture Behavioral of puente_h is
begin
    process(sw1, sw2)
    begin
        -- Control del puente H
        if (sw1 = '1' and sw2 = '0') then
            -- Polaridad: dirección 1
            in1 <= '1';
            in2 <= '0';
        elsif (sw1 = '0' and sw2 = '1') then
            -- Polaridad: dirección 2
            in1 <= '0';
            in2 <= '1';
        else
            -- Ambos switches en la misma posición: motor apagado
            in1 <= '0';
            in2 <= '0';
        end if;
    end process;
end Behavioral;
