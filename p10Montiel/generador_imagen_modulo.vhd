library ieee;
use ieee.std_logic_1164.all;

entity generador_imagen_modulo is
  port (
    display_ena : in std_logic;
    row : in integer;
    column : in integer;
    sw1 : in std_logic; 
    sw2: in std_logic; 
    sw3: in std_logic; 
    sw4: in std_logic; 
    sw5: in std_logic; 
    sw6: in std_logic; 
    sw7: in std_logic; 
    sw8: in std_logic; 
    red : out std_logic_vector(3 downto 0);
    green : out std_logic_vector(3 downto 0);
    blue : out std_logic_vector(3 downto 0)
  );
end entity generador_imagen_modulo;

architecture Behavioral of generador_imagen_modulo is
    signal switch_activo : std_logic := '0'; -- Señal para controlar el switch activo.
    signal bloque_activo : integer := 0; -- Variable para mantener el bloque activo
begin
  process (display_ena, row, column, sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw8)
  begin
    if (display_ena = '1') then
      if switch_activo = '0' then  -- Si no hay switch activo, revisar cuáles están activos
        if sw1 = '1' then
          bloque_activo <= 1;
          switch_activo <= '1';
        elsif sw2 = '1' then
          bloque_activo <= 2;
          switch_activo <= '1';
        elsif sw3 = '1' then
          bloque_activo <= 3;
          switch_activo <= '1';
        elsif sw4 = '1' then
          bloque_activo <= 4;
          switch_activo <= '1';
        elsif sw5 = '1' then
          bloque_activo <= 6;
          switch_activo <= '1';
        elsif sw6 = '1' then
          bloque_activo <= 7;
          switch_activo <= '1';
        elsif sw7 = '1' then
          bloque_activo <= 8;
          switch_activo <= '1';
        elsif sw8 = '1' then
          bloque_activo <= 9;
          switch_activo <= '1';
        else
          bloque_activo <= 5; -- Ningún switch activo, activar bloque central.
			 switch_activo <= '1';
        end if;
      else  -- Si ya hay un switch activo, ignorar otros hasta que se desactive
        case bloque_activo is
		  
		  
          when 1 =>
            if sw1 = '0' then
              switch_activo <= '0'; 
            end if;
				
				
            
				-- 1
            if ((row > 10 and row < 30) and (column > 10 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 10 and row < 150) and (column > 10 and column < 30)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 120 and row < 150) and (column > 10 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 10 and row < 150) and (column > 50 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 30 and row < 120) and (column > 30 and column < 50)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 10 and row < 38) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 66 and row < 94) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 122 and row < 150) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;
				

          when 2 => 
            if sw2 = '0' then
              switch_activo <= '0';
            end if;
            -- 1
            if ((row > 170 and row < 190) and (column > 10 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 170 and row < 310) and (column > 10 and column < 30)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 280 and row < 310) and (column > 10 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 170 and row < 310) and (column > 50 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 190 and row < 280) and (column > 30 and column < 50)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 170 and row < 198) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 226 and row < 254) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 282 and row < 310) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 3 => 
            if sw3 = '0' then
              switch_activo <= '0'; 
            end if;
            -- 1
            if ((row > 330 and row < 350) and (column > 10 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 330 and row < 470) and (column > 10 and column < 30)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 440 and row < 470) and (column > 10 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 330 and row < 470) and (column > 50 and column < 70)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 350 and row < 440) and (column > 30 and column < 50)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 330 and row < 358) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 386 and row < 414) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 442 and row < 470) and (column > 70 and column < 100)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 4 =>
            if sw4 = '0' then
              switch_activo <= '0'; 
            end if;
            
            -- 1
            if ((row > 10 and row < 30) and (column > 223 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 10 and row < 150) and (column > 223 and column < 243)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 120 and row < 150) and (column > 223 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 10 and row < 150) and (column > 263 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 30 and row < 120) and (column > 243 and column < 263)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 10 and row < 38) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 66 and row < 94) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 122 and row < 150) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 5 => -- CENTRO DE PANTALLA
            if sw1 = '1' or sw2 = '1' or sw3 = '1' or sw4 = '1' or sw5 = '1' or sw6 = '1' or sw7 = '1' or sw8 = '1' then
              switch_activo <= '0'; 
            end if;
            
            -- 1
            if ((row > 170 and row < 190) and (column > 223 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 170 and row < 310) and (column > 223 and column < 243)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 280 and row < 310) and (column > 223 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 170 and row < 310) and (column > 263 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 190 and row < 280) and (column > 243 and column < 263)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 170 and row < 198) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 226 and row < 254) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 282 and row < 310) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 6 => -- SEXTO RECUADRO (Switch 5)
            if sw5 = '0' then
              switch_activo <= '0'; -- Reset del switch activo cuando se desactiva el switch 5
            end if;
            -- Bloque 6 de dibujo
            -- 1
            if ((row > 330 and row < 350) and (column > 223 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 330 and row < 470) and (column > 223 and column < 243)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 440 and row < 470) and (column > 223 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 330 and row < 470) and (column > 263 and column < 283)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 350 and row < 440) and (column > 243 and column < 263)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 330 and row < 358) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 386 and row < 414) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 442 and row < 470) and (column > 283 and column < 313)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;

          when 7 => 
            if sw6 = '0' then
              switch_activo <= '0'; 
            end if;
            -- Bloque 7
            -- 1
            if ((row > 10 and row < 30) and (column > 436 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 10 and row < 150) and (column > 436 and column < 453)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 120 and row < 150) and (column > 436 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 10 and row < 150) and (column > 476 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 30 and row < 120) and (column > 453 and column < 473)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 10 and row < 38) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 66 and row < 94) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 122 and row < 150) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;


          when 8 => 
            if sw7 = '0' then
              switch_activo <= '0'; 
            end if;
            
            -- 1
            if ((row > 170 and row < 190) and (column > 436 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 170 and row < 310) and (column > 436 and column < 453)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 280 and row < 310) and (column > 436 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 170 and row < 310) and (column > 476 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 190 and row < 280) and (column > 453 and column < 473)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 170 and row < 198) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 226 and row < 254) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 282 and row < 310) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;
				
				
          when 9 =>
            if sw8 = '0' then
              switch_activo <= '0';
            end if;
            
            -- 1
            if ((row > 330 and row < 350) and (column > 436 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 2  
				elsif ((row > 330 and row < 470) and (column > 436 and column < 453)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 3
				elsif  ((row > 440 and row < 470) and (column > 436 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				-- 4
				elsif  ((row > 330 and row < 470) and (column > 476 and column < 496)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1');
				 -- 5
				elsif  ((row > 350 and row < 440) and (column > 453 and column < 473)) then
              red <= (others => '1');
              green <= (others => '0');
              blue <= (others => '0'); 
				  
				 -- 6
				elsif  ((row > 330 and row < 358) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 7
				elsif ((row > 386 and row < 414) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
				  
				-- 8
				elsif ((row > 442 and row < 470) and (column > 496 and column < 526)) then
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '1'); 
            
            else
              red <= (others => '0');
              green <= (others => '0');
              blue <= (others => '0');
            end if;
				
          when others =>
            -- sin nada
            red <= (others => '1');
            green <= (others => '0');
            blue <= (others => '1');
        end case;
      end if;
    else
      -- Si display_ena cerrado
      red <= (others => '1');
      green <= (others => '1');
      blue <= (others => '0');
    end if;
  end process;
end architecture Behavioral;
