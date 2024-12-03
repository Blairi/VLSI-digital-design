LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SensorObstaculo IS
  PORT (
    clk : IN STD_LOGIC;
    eco : IN STD_LOGIC;
    dispa : OUT STD_LOGIC;
    obstaculo : OUT STD_LOGIC
  );
END SensorObstaculo;

ARCHITECTURE Behavioral OF SensorObstaculo IS
  SIGNAL cuenta : unsigned(16 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros : unsigned(16 DOWNTO 0) := (OTHERS => '0');
  SIGNAL espera : STD_LOGIC := '0';
  SIGNAL eco_pasado : STD_LOGIC := '0';
  SIGNAL eco_sinc : STD_LOGIC := '0';
  SIGNAL eco_nsinc : STD_LOGIC := '0';

BEGIN
  -- Proceso para manejar el trigger y la recepción del eco
  Trigger : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF espera = '0' THEN
        IF cuenta = 500 THEN
          dispa <= '0';
          espera <= '1';
          cuenta <= (OTHERS => '0');
        ELSE
          dispa <= '1';
          cuenta <= cuenta + 1;
        END IF;
      ELSIF eco_pasado = '0' AND eco_sinc = '1' THEN
        cuenta <= (OTHERS => '0');
        centimetros <= (OTHERS => '0');
      ELSIF eco_pasado = '1' AND eco_sinc = '0' THEN
        -- Calcular distancia en cm
        centimetros <= cuenta / 58; -- Conversión del tiempo del eco a distancia
        cuenta <= (OTHERS => '0');
        espera <= '0';
      ELSE
        cuenta <= cuenta + 1;
      END IF;

      -- Actualizar señales de sincronización del eco
      eco_pasado <= eco_sinc;
      eco_sinc <= eco_nsinc;
      eco_nsinc <= eco;
    END IF;
  END PROCESS;

  -- Proceso para activar la señal "obstaculo" si la distancia es menor a 13 cm
  DetectarObstaculo : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF centimetros < 13 THEN
        obstaculo <= '1'; -- Activar obstaculo
      ELSE
        obstaculo <= '0'; -- Desactivar obstaculo
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
