library ieee;
use ieee.std_logic_1164.all;

entity generador_imagen_modulo is
  port (
    display_ena : in std_logic;
    row : in integer;
    column : in integer;
    switch1 : in std_logic; -- Valor predeterminado
    switch2 : in std_logic; -- Valor predeterminado
    switch3 : in std_logic; -- Valor predeterminado
    switch4 : in std_logic; -- Valor predeterminado
    switch5 : in std_logic; -- Valor predeterminado
    switch6 : in std_logic; -- Valor predeterminado
    switch7 : in std_logic; -- Valor predeterminado
    switch8 : in std_logic; -- Valor predeterminado
    red : out std_logic_vector(3 downto 0);
    green : out std_logic_vector(3 downto 0);
    blue : out std_logic_vector(3 downto 0)
  );
end entity generador_imagen_modulo;

architecture Behavioral of generador_imagen_modulo is
    signal switch_activo : std_logic := '0'; -- Señal para controlar el switch activo.
    signal bloque_activo : integer := 0; -- Variable para mantener el bloque activo
begin
  process (display_ena, row, column, switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8)
  begin
    if (display_ena = '1') then
      if switch_activo = '0' then  -- Si no hay switch activo, revisar cuáles están activos
        if switch1 = '1' then
          bloque_activo <= 1;
          switch_activo <= '1';
        elsif switch2 = '1' then
          bloque_activo <= 2;
          switch_activo <= '1';
        elsif switch3 = '1' then
          bloque_activo <= 3;
          switch_activo <= '1';
        elsif switch4 = '1' then
          bloque_activo <= 4;
          switch_activo <= '1';
        elsif switch5 = '1' then
          bloque_activo <= 6;
          switch_activo <= '1';
        elsif switch6 = '1' then
          bloque_activo <= 7;
          switch_activo <= '1';
        elsif switch7 = '1' then
          bloque_activo <= 8;
          switch_activo <= '1';
        elsif switch8 = '1' then
          bloque_activo <= 9;
          switch_activo <= '1';
        else
          bloque_activo <= 5; -- Ningún switch activo, activar bloque central.
			 switch_activo <= '1';
        end if;
      else  -- Si ya hay un switch activo, ignorar otros hasta que se desactive
        case bloque_activo is
          when 1 => -- PRIMER RECUADRO (Switch 1)
            if switch1 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 1
            end if;
				
            -- Bloque 1 de dibujo
            if ((row > 71 and row < 107) and (column > 36 and column < 71)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 18 and row < 53) and (column > 89 and column < 124)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 53 and row < 124) and (column > 71 and column < 142)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 124 and row < 142) and (column > 71 and column < 89)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 124 and row < 142) and (column > 124 and column < 142)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 2 => -- SEGUNDO RECUADRO (Switch 2)
            if switch2 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 2
            end if;
            -- Bloque 2 de dibujo
            if ((row > 71 and row < 107) and (column > 249 and column < 284)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 18 and row < 53) and (column > 302 and column < 337)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 53 and row < 124) and (column > 284 and column < 355)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 124 and row < 142) and (column > 284 and column < 302)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 124 and row < 142) and (column > 337 and column < 355)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 3 => -- TERCER RECUADRO (Switch 3)
            if switch3 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 3
            end if;
            -- Bloque 3 de dibujo
            if ((row > 71 and row < 107) and (column > 462 and column < 497)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 18 and row < 53) and (column > 515 and column < 550)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 53 and row < 124) and (column > 497 and column < 568)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 124 and row < 142) and (column > 497 and column < 515)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 124 and row < 142) and (column > 550 and column < 568)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 4 => -- CUARTO RECUADRO (Switch 4)
            if switch4 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 4
            end if;
            -- Bloque 4 de dibujo
            if ((row > 231 and row < 267) and (column > 36 and column < 71)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 178 and row < 213) and (column > 89 and column < 124)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 213 and row < 284) and (column > 71 and column < 142)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 284 and row < 302) and (column > 71 and column < 89)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 284 and row < 302) and (column > 124 and column < 142)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 5 => -- QUINTO RECUADRO (Sin ningún switch activo)
            if switch1 = '1' or switch2 = '1' or switch3 = '1' or switch4 = '1' or switch5 = '1' or switch6 = '1' or switch7 = '1' or switch8 = '1' then
              switch_activo <= '0'; -- Reset del switch activo si algún switch se activa después
            end if;
            -- Bloque 5 de dibujo (Centro)
            if ((row > 231 and row < 267) and (column > 249 and column < 284)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 178 and row < 213) and (column > 302 and column < 337)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 213 and row < 284) and (column > 284 and column < 355)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 284 and row < 302) and (column > 284 and column < 302)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 284 and row < 302) and (column > 337 and column < 355)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 6 => -- SEXTO RECUADRO (Switch 5)
            if switch5 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 5
            end if;
            -- Bloque 6 de dibujo
            if ((row > 231 and row < 267) and (column > 462 and column < 497)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 178 and row < 213) and (column > 515 and column < 550)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 213 and row < 284) and (column > 497 and column < 568)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 284 and row < 302) and (column > 497 and column < 515)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 284 and row < 302) and (column > 550 and column < 568)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 7 => -- SEPTIMO RECUADRO (Switch 6)
            if switch6 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 6
            end if;
            -- Bloque 7 de dibujo
            if ((row > 391 and row < 427) and (column > 36 and column < 71)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 338 and row < 373) and (column > 89 and column < 124)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 373 and row < 444) and (column > 71 and column < 142)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 444 and row < 462) and (column > 71 and column < 89)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 444 and row < 462) and (column > 124 and column < 142)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 8 => -- OCTAVO RECUADRO (Switch 7)
            if switch7 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 7
            end if;
            -- Bloque 8 de dibujo
            if ((row > 391 and row < 427) and (column > 249 and column < 284)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 338 and row < 373) and (column > 302 and column < 337)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 373 and row < 444) and (column > 284 and column < 355)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 444 and row < 462) and (column > 284 and column < 302)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 444 and row < 462) and (column > 337 and column < 355)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 9 => -- NOVENO RECUADRO (Switch 8)
            if switch8 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 8
            end if;
            -- Bloque 9 de dibujo
            if ((row > 391 and row < 427) and (column > 462 and column < 497)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 338 and row < 373) and (column > 515 and column < 550)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
            elsif ((row > 373 and row < 444) and (column > 497 and column < 568)) then
              red <= (others => '1');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 444 and row < 462) and (column > 497 and column < 515)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            elsif ((row > 444 and row < 462) and (column > 550 and column < 568)) then
              red <= (others => '0');
              green <= (others => '1');
              blue <= (others => '0');
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when others =>
            -- En caso de error o estado indefinido
            red <= (others => '1');
            green <= (others => '0');
            blue <= (others => '0');
        end case;
      end if;
    else
      -- Si display_ena está desactivado
      red <= (others => '0');
      green <= (others => '1');
      blue <= (others => '0');
    end if;
  end process;
end architecture Behavioral;
