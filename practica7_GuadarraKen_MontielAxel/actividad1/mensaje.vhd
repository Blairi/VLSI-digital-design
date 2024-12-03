LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mensaje IS
  PORT (
    clk : IN STD_LOGIC;
    dispa : OUT STD_LOGIC;
    eco : IN STD_LOGIC;
    segmentos, segmentos1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    segmentos2, segmentos3, segmentos4, segmentos5 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
  );
END mensaje;

ARCHITECTURE Behavioral OF mensaje IS
  SIGNAL cuenta : unsigned(16 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros : unsigned(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros_unid : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros_dece : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sal_unid : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sal_dece : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL digito1 : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL digito : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL eco_pasado : STD_LOGIC := '0';
  SIGNAL eco_sinc : STD_LOGIC := '0';
  SIGNAL eco_nsinc : STD_LOGIC := '0';
  SIGNAL espera : STD_LOGIC := '0';
  SIGNAL siete_seg_cuenta : unsigned(15 DOWNTO 0) := (OTHERS => '0');

BEGIN
  siete_seg : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF siete_seg_cuenta(siete_seg_cuenta'high) = '1' THEN
        digito <= sal_unid;
      ELSE
        digito1 <= sal_dece;
      END IF;
      siete_seg_cuenta <= siete_seg_cuenta + 1;
    END IF;
  END PROCESS;

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
        centimetros_unid <= (OTHERS => '0');
        centimetros_dece <= (OTHERS => '0');
      ELSIF eco_pasado = '1' AND eco_sinc = '0' THEN
        sal_unid <= centimetros_unid;
        sal_dece <= centimetros_dece;
      ELSIF cuenta = 2900 - 1 THEN
        IF centimetros_unid = 9 THEN
          centimetros_unid <= (OTHERS => '0');
          centimetros_dece <= centimetros_dece + 1;
        ELSE
          centimetros_unid <= centimetros_unid + 1;
        END IF;
        centimetros <= centimetros + 1;
        cuenta <= (OTHERS => '0');
        IF centimetros = 3448 THEN
          espera <= '0';
        END IF;	
      ELSE
        cuenta <= cuenta + 1;
      END IF;
      eco_pasado <= eco_sinc;
      eco_sinc <= eco_nsinc;
      eco_nsinc <= eco;
    END IF;
  END PROCESS;

  Decodificador : PROCESS (digito)
  BEGIN
    IF digito = X"0" THEN
      segmentos <= X"81";
    ELSIF digito = X"1" THEN
      segmentos <= X"F3";
    ELSIF digito = X"2" THEN
      segmentos <= X"49";
    ELSIF digito = X"3" THEN
      segmentos <= X"61";
    ELSIF digito = X"4" THEN
      segmentos <= X"33";
    ELSIF digito = X"5" THEN
      segmentos <= X"25";
    ELSIF digito = X"6" THEN
      segmentos <= X"05";
    ELSIF digito = X"7" THEN
      segmentos <= X"F1";
    ELSIF digito = X"8" THEN
      segmentos <= X"01";
    ELSIF digito = X"9" THEN
      segmentos <= X"21";
    ELSIF digito = X"a" THEN
      segmentos <= X"11";
    ELSIF digito = X"b" THEN
      segmentos <= X"07";
    ELSIF digito = X"c" THEN
      segmentos <= X"8D";
    ELSIF digito = X"d" THEN
      segmentos <= X"43";
    ELSIF digito = X"e" THEN
      segmentos <= X"0D";
    ELSE
      segmentos <= X"1D";
    END IF;
  END PROCESS;
  
  Decodificador1 : PROCESS (digito1)
  BEGIN
    IF digito1 = X"0" THEN
      segmentos1 <= X"81";
    ELSIF digito1 = X"1" THEN
      segmentos1 <= X"F3";
    ELSIF digito1 = X"2" THEN
      segmentos1 <= X"49";
    ELSIF digito1 = X"3" THEN
      segmentos1 <= X"61";
    ELSIF digito1 = X"4" THEN
      segmentos1 <= X"33";
    ELSIF digito1 = X"5" THEN
      segmentos1 <= X"25";
    ELSIF digito1 = X"6" THEN
      segmentos1 <= X"05";
    ELSIF digito1 = X"7" THEN
      segmentos1 <= X"F1";
    ELSIF digito1 = X"8" THEN
      segmentos1 <= X"01";
    ELSIF digito1 = X"9" THEN
      segmentos1 <= X"21";
    ELSIF digito1 = X"a" THEN
      segmentos1 <= X"11";
    ELSIF digito1 = X"b" THEN
      segmentos1 <= X"07";
    ELSIF digito1 = X"c" THEN
      segmentos1 <= X"8D";
    ELSIF digito1 = X"d" THEN
      segmentos1 <= X"43";
    ELSIF digito1 = X"e" THEN
      segmentos1 <= X"0D";
    ELSE
      segmentos1 <= X"1D";
    END IF;
  END PROCESS;
  
Stop : PROCESS (clk)
BEGIN
  IF rising_edge(clk) THEN
    -- Condición para mostrar "SlSl" en los displays
    IF (sal_dece = X"1" AND (sal_unid >= X"3" OR sal_unid >= X"4" OR sal_unid >= X"5" OR sal_unid >= X"6" OR sal_unid >= X"7" OR sal_unid >= X"8" OR sal_unid >= X"9")) THEN
      segmentos5 <= "0100100"; -- S
      segmentos4 <= "1111001"; -- l
      segmentos3 <= "0100100"; -- S
      segmentos2 <= "1111001"; -- l
    ELSE 
      -- Si la condición no se cumple, apagar los displays
      segmentos5 <= "1111111"; -- Display apagado
      segmentos4 <= "1111111"; -- Display apagado
      segmentos3 <= "1111111"; -- Display apagado
      segmentos2 <= "1111111"; -- Display apagado
    END IF;
  END IF;
END PROCESS;



END Behavioral;