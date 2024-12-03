LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SONICOS IS
  PORT (
    clk : IN STD_LOGIC;
    diparador : OUT STD_LOGIC;
    eco : IN STD_LOGIC;
    segmentos, segmentos1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    segmentos2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    control_servomorsito : OUT STD_LOGIC;
    sw_motorsito : IN STD_LOGIC 
  );
END SONICOS;

ARCHITECTURE Behavioral OF SONICOS IS
  COMPONENT divisor IS
    PORT (
      reloj : IN STD_LOGIC;
      div_reloj : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT PWM IS
    PORT (
      reloj_pwm : IN STD_LOGIC;
      D : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      S : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL clk_servo : STD_LOGIC;
  SIGNAL servo_pos : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"07";
  SIGNAL wait_time : unsigned(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL servo_wait : unsigned(3 DOWNTO 0) := (OTHERS => '0');

  SIGNAL cuenta : unsigned(16 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros : unsigned(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros_unid : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL centimetros_dece : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sal_unid : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sal_dece : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL digito1 : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL digito2 : unsigned(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL eco_pasado : STD_LOGIC := '0';
  SIGNAL eco_sinc : STD_LOGIC := '0';
  SIGNAL eco_nsinc : STD_LOGIC := '0';
  SIGNAL waitAccion : STD_LOGIC := '0';
  SIGNAL dis_cuenta : unsigned(15 DOWNTO 0) := (OTHERS => '0');
  TYPE servo_state_type IS (IDLE, MOVERSE, WAIT_RETURN, SW_SERVO);
  SIGNAL servo_state : servo_state_type := IDLE;
  
BEGIN
  U1: divisor PORT MAP (clk, clk_servo);

  U2: PWM PORT MAP (clk_servo, servo_pos, control_servomorsito);
  
  siete_seg : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF dis_cuenta(dis_cuenta'high) = '1' THEN
        digito2 <= sal_unid;
      ELSE
        digito1 <= sal_dece;
      END IF;
      dis_cuenta <= dis_cuenta + 1;
    END IF;
  END PROCESS;

  Trigger : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF waitAccion = '0' THEN
        IF cuenta = 500 THEN
          diparador <= '0';
          waitAccion <= '1';
          cuenta <= (OTHERS => '0');
        ELSE
          diparador <= '1';
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
          waitAccion <= '0';
        END IF;	
      ELSE
        cuenta <= cuenta + 1;
      END IF;
      eco_pasado <= eco_sinc;
      eco_sinc <= eco_nsinc;
      eco_nsinc <= eco;
    END IF;
  END PROCESS;

  Servo_Control1: PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      CASE servo_state IS
        WHEN IDLE =>
          IF (sal_dece=X"1" and (sal_unid=X"3" or  sal_unid=X"4" or  sal_unid=X"5" or  sal_unid=X"6" or  sal_unid=X"7" or  sal_unid=X"8" or  sal_unid=X"9" ) ) THEN
            servo_pos <= X"1F"; -- 180 grados
            servo_state <= MOVERSE;
            wait_time <= (OTHERS => '0');
          ELSIF sw_motorsito = '1' AND servo_wait > 0 THEN
            servo_state <= SW_SERVO;
          END IF;
          
        WHEN MOVERSE =>
          IF (sal_dece /= X"1" OR sal_unid < X"5" OR sal_unid > X"8") THEN
            wait_time <= wait_time + 1;
            IF wait_time = 550000000 THEN -- 11 s
              servo_pos <= X"07"; -- 0 grados
              servo_state <= WAIT_RETURN;
              wait_time <= (OTHERS => '0');
              servo_wait <= servo_wait + 1;
              IF servo_wait = 5 THEN
                servo_wait <= (OTHERS => '0');
              END IF;
            END IF;
          ELSE
            wait_time <= (OTHERS => '0');
          END IF;
          
        WHEN WAIT_RETURN =>
          wait_time <= wait_time + 1;
          IF wait_time = 50000000 THEN -- 1 s
            servo_state <= IDLE;
          END IF;
          
        WHEN SW_SERVO =>
          IF sw_motorsito = '1' THEN
            servo_pos <= X"1F"; -- 180 grados
            wait_time <= (OTHERS => '0');
          ELSE
            wait_time <= wait_time + 1;
            IF wait_time = 550000000 THEN -- 6 segundos 
              servo_pos <= X"07"; -- 0 grados
              servo_state <= WAIT_RETURN;
              wait_time <= (OTHERS => '0');
              servo_wait <= servo_wait + 1;
              IF servo_wait = 5 THEN
                servo_wait <= (OTHERS => '0');
              END IF;
            END IF;
          END IF;
          
      END CASE;
    END IF;
  END PROCESS;

  Decodificador : PROCESS (digito2)
  BEGIN
    CASE digito2 IS
      WHEN X"0" => segmentos <= X"81";
      WHEN X"1" => segmentos <= X"F3";
      WHEN X"2" => segmentos <= X"49";
      WHEN X"3" => segmentos <= X"61";
      WHEN X"4" => segmentos <= X"33";
      WHEN X"5" => segmentos <= X"25";
      WHEN X"6" => segmentos <= X"05";
      WHEN X"7" => segmentos <= X"F1";
      WHEN X"8" => segmentos <= X"01";
      WHEN X"9" => segmentos <= X"21";
      WHEN X"A" => segmentos <= X"11";
      WHEN X"B" => segmentos <= X"07";
      WHEN X"C" => segmentos <= X"8D";
      WHEN X"D" => segmentos <= X"43";
      WHEN X"E" => segmentos <= X"0D";
      WHEN OTHERS => segmentos <= X"1D";
    END CASE;
  END PROCESS;
  
  Decodificador1 : PROCESS (digito1)
  BEGIN
    CASE digito1 IS
      WHEN X"0" => segmentos1 <= X"81";
      WHEN X"1" => segmentos1 <= X"F3";
      WHEN X"2" => segmentos1 <= X"49";
      WHEN X"3" => segmentos1 <= X"61";
      WHEN X"4" => segmentos1 <= X"33";
      WHEN X"5" => segmentos1 <= X"25";
      WHEN X"6" => segmentos1 <= X"05";
      WHEN X"7" => segmentos1 <= X"F1";
      WHEN X"8" => segmentos1 <= X"01";
      WHEN X"9" => segmentos1 <= X"21";
      WHEN X"A" => segmentos1 <= X"11";
      WHEN X"B" => segmentos1 <= X"07";
      WHEN X"C" => segmentos1 <= X"8D";
      WHEN X"D" => segmentos1 <= X"43";
      WHEN X"E" => segmentos1 <= X"0D";
      WHEN OTHERS => segmentos1 <= X"1D";
    END CASE;
  END PROCESS;

  -- Decodificador para mostrar el número de vueltas
  Decodificador_Vueltas : PROCESS (servo_wait)
  BEGIN
    CASE servo_wait IS
      WHEN "0000" => segmentos2 <= "1000000"; -- 0
      WHEN "0001" => segmentos2 <= "1111001"; -- 1
      WHEN "0010" => segmentos2 <= "0100100"; -- 2
      WHEN "0011" => segmentos2 <= "0110000"; -- 3
      WHEN "0100" => segmentos2 <= "0011001"; -- 4
      WHEN "0101" => segmentos2 <= "0010010"; -- 5
      WHEN OTHERS => segmentos2 <= "0000010"; -- 6
    END CASE;
  END PROCESS;

END Behavioral;