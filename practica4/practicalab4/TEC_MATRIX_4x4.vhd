Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_unsigned.all;
entity TEC_MATRIX_4X4 is
	Generic (FREQ_CLK: integer := 50_000_00);
	Port( CLK: IN STD_LOGIC;
		COLUMNAS: in std_logic_vector(3 downto 0);
		FILAS: out std_logic_vector(3 downto 0);
		IND: out std_logic;
		button: in std_logic;
		buzzer : OUT std_logic;
		DISPLAY1: OUT std_logic_vector(6 downto 0);
		DISPLAY2: OUT std_logic_vector(6 downto 0);
		DISPLAY3: OUT std_logic_vector(6 downto 0);
		DISPLAY4: OUT std_logic_vector(6 downto 0);
		DISPLAY5: OUT std_logic_vector(6 downto 0);
		DISPLAY6: OUT std_logic_vector(6 downto 0));
end TEC_MATRIX_4X4;

architecture behavioral of TEC_MATRIX_4X4 is
	CONSTANT DELAY_1MS : INTEGER := (FREQ_CLK/1000)-1;
	CONSTANT DELAY_10MS : INTEGER := (FREQ_CLK/100)-1;
	SIGNAL CONTA_1MS : INTEGER RANGE 0 TO DELAY_1MS := 0;
	SIGNAL BANDERA : STD_LOGIC := '0';
	SIGNAL CONTA_10MS : INTEGER RANGE 0 TO DELAY_10MS := 0;
	SIGNAL BANDERA2 : STD_LOGIC := '0';
	SIGNAL BOT_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_9 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_A : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_B : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_C : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_D : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_0 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_AS : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_GA : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL IND_S : STD_LOGIC := '0';
	SIGNAL EDO : INTEGER RANGE 0 TO 1 := 0;
	SIGNAL FILA_REG_S : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL FILA: INTEGER := 0;
	SIGNAL BOTON_PRES : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Estados de la FSM
    type state_type is (IDLE, CHECK_KEY, NEXT_KEY, SUCCESS, FAIL);
    signal state, next_state : state_type;
	 
	 -- Contraseña y contador
    signal password : std_logic_vector(3 downto 0) := "0000"; -- Almacena el código introducido
    signal count : integer := 0; -- Contador para las teclas
	 
	 -- Variables para la tecla leída
    signal current_key : std_logic_vector(3 downto 0);
	 
BEGIN
	FILAS <= FILA_REG_S;
--RETARDO 1 MS--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		CONTA_1MS <= CONTA_1MS+1;
		BANDERA <= '0';	
		IF CONTA_1MS = DELAY_1MS THEN
			CONTA_1MS <= 0;
			BANDERA <= '1';
		END IF;
	END IF;
END PROCESS;
----------------
--RETARDO 10 MS--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		CONTA_10MS <= CONTA_10MS+1;
		BANDERA2 <= '0';
		IF CONTA_10MS = DELAY_10MS THEN
			CONTA_10MS <= 0;
			BANDERA2 <= '1';
		END IF;
	END IF;
END PROCESS;
----------------
--PROCESO EN LAS FILAS ----
PROCESS(CLK, BANDERA2)
BEGIN
	IF RISING_EDGE(CLK) AND BANDERA2 = '1' THEN
		FILA <= FILA+1;
		IF FILA = 3 THEN
			FILA <= 0;
		END IF;
	END IF;
END PROCESS;

WITH FILA SELECT
	FILA_REG_S <= "1000" WHEN 0,
						"0100" WHEN 1,
						"0010" WHEN 2,
						"0001" WHEN OTHERS;


						
-------------------------------
----------PROCESO EN EL TECLADO AL SELECCIONAR UN VALOR------------
PROCESS(CLK,BANDERA)
BEGIN
	IF RISING_EDGE(CLK) AND BANDERA = '1' THEN
		IF FILA_REG_S = "1000" THEN
					Bot_1 <= Bot_1(6 DOWNTO 0)&COLUMNAS(3);
					Bot_2 <= Bot_2(6 DOWNTO 0)&COLUMNAS(2);
					Bot_3 <= Bot_3(6 DOWNTO 0)&COLUMNAS(1);
					Bot_A <= Bot_A(6 DOWNTO 0)&COLUMNAS(0);
		ELSIF FILA_REG_S = "0100" THEN
					Bot_4 <= Bot_4(6 DOWNTO 0)&COLUMNAS(3);
					Bot_5 <= Bot_5(6 DOWNTO 0)&COLUMNAS(2);
					Bot_6 <= Bot_6(6 DOWNTO 0)&COLUMNAS(1);
					Bot_B <= Bot_B(6 DOWNTO 0)&COLUMNAS(0);
		ELSIF FILA_REG_S = "0010" THEN
					Bot_7 <= Bot_7(6 DOWNTO 0)&COLUMNAS(3);
					Bot_8 <= Bot_8(6 DOWNTO 0)&COLUMNAS(2);
					Bot_9 <= Bot_9(6 DOWNTO 0)&COLUMNAS(1);
					Bot_C <= Bot_C(6 DOWNTO 0)&COLUMNAS(0);
		ELSIF FILA_REG_S = "0001" THEN
					Bot_AS <= Bot_AS(6 DOWNTO 0)&COLUMNAS(3);
					Bot_0 <= Bot_0(6 DOWNTO 0)&COLUMNAS(2);
					Bot_GA <= Bot_GA(6 DOWNTO 0)&COLUMNAS(1);
					Bot_D <= Bot_D(6 DOWNTO 0)&COLUMNAS(0);
		END IF;
	END IF;
END PROCESS;
----------------------------------------------------------------------------
--SALIDA--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		IF Bot_0 = "11111111" THEN BOTON_PRES <= X"0"; IND_S <= '1';
		ELSIF Bot_1 = "11111111" THEN BOTON_PRES <= X"1"; IND_S <= '1';
		ELSIF Bot_2 = "11111111" THEN BOTON_PRES <= X"2"; IND_S <= '1';
		ELSIF Bot_3 = "11111111" THEN BOTON_PRES <= X"3"; IND_S <= '1';
		ELSIF Bot_4 = "11111111" THEN BOTON_PRES <= X"4"; IND_S <= '1';
		ELSIF Bot_5 = "11111111" THEN BOTON_PRES <= X"5"; IND_S <= '1';
		ELSIF Bot_6 = "11111111" THEN BOTON_PRES <= X"6"; IND_S <= '1';
		ELSIF Bot_7 = "11111111" THEN BOTON_PRES <= X"7"; IND_S <= '1';
		ELSIF Bot_8 = "11111111" THEN BOTON_PRES <= X"8"; IND_S <= '1';
		ELSIF Bot_9 = "11111111" THEN BOTON_PRES <= X"9"; IND_S <= '1';
		ELSIF Bot_A = "11111111" THEN BOTON_PRES <= X"A"; IND_S <= '1';
		ELSIF Bot_B = "11111111" THEN BOTON_PRES <= X"B"; IND_S <= '1';
		ELSIF Bot_C = "11111111" THEN BOTON_PRES <= X"C"; IND_S <= '1';
		ELSIF Bot_D = "11111111" THEN BOTON_PRES <= X"D"; IND_S <= '1';
		ELSIF Bot_AS = "11111111" THEN BOTON_PRES <= X"E"; IND_S <= '1';
		ELSIF Bot_GA = "11111111" THEN BOTON_PRES <= X"F"; IND_S <= '1';
		ELSE IND_S <= '0';
		END IF;
	END IF;
END PROCESS;
-----------------------------
--ACTIVACIÓN PARA LA BANDERA UN CICLO DE RELOJ--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		IF EDO = 0 THEN
			IF IND_S = '1' THEN
				IND <= '1';
				EDO <= 1;
			ELSE
				EDO <= 0;
				IND <= '0';
			END IF;
			ELSE
			IF IND_S = '1' THEN
				EDO <= 1;
				IND <= '0';
			ELSE
				EDO <= 0;
			END IF;
		END IF;
	END IF;
END PROCESS;

-- Proceso para detectar la pulsación del botón
process(clk)
    begin
        if rising_edge(clk) then
            if button = '0' then          -- Botón presionado (normalmente '0' indica presión, verifica esto)
                buzzer <= '1';            -- Encender el buzzer
            else
                buzzer <= '0';            -- Apagar el buzzer cuando el botón no está presionado
            end if;
        end if;
 end process;
 
 
  -- Lógica de transición de estados
    process(state, current_key, count)
    begin
        case state is
            when IDLE =>
                -- Esperando la primera tecla
                if current_key /= "0000" then -- si una tecla es presionada
                    next_state <= CHECK_KEY;
                else
                    next_state <= IDLE;
                end if;
            
            when CHECK_KEY =>
                -- Verifica la tecla
                if (count = 0 and current_key = "0001") or -- '1'
                   (count = 1 and current_key = "0010") or -- '2'
                   (count = 2 and current_key = "0011") or -- '3'
                   (count = 3 and current_key = "0100") then -- '4'
                    next_state <= NEXT_KEY;
                else
                    next_state <= FAIL;
                end if;
            
            when NEXT_KEY =>
                -- Avanza al siguiente dígito
                count <= count + 1;
                if count = 3 then
                    next_state <= SUCCESS;
                else
                    next_state <= IDLE;
                end if;

            when SUCCESS =>
                -- Contraseña correcta
                correct_led <= '1';
                wrong_led <= '0';
                next_state <= IDLE;

            when FAIL =>
                -- Contraseña incorrecta
                correct_led <= '0';
                wrong_led <= '1';
                next_state <= IDLE;
            
            when others =>
                next_state <= IDLE;
        end case;
    end process;
 
 
--------------------------------------
	

 with BOTON_PRES select
  display1 <= "1000000" when X"0",
				 "1111001" when X"1",
				 "0100100" when X"2",
				 "0110000" when X"3",
				 "0011001" when X"4",
				 "0010010" when X"5",
				 "0000010" when X"6",
				 "1111000" when X"7",
				 "0000000" when X"8",
				 "0010000" when X"9",
				 "0001000" when X"A",
				 "0000011" when X"B",
				 "1000110" when X"C",
				 "0100001" when X"D",
				 "0000110" when X"E",
				 "0001110" when X"F",
				 "1111111" when others;
				 
	with BOTON_PRES select
  display2 <= "1000000" when X"0",
				 "1111001" when X"1",
				 "0100100" when X"2",
				 "0110000" when X"3",
				 "0011001" when X"4",
				 "0010010" when X"5",
				 "0000010" when X"6",
				 "1111000" when X"7",
				 "0000000" when X"8",
				 "0010000" when X"9",
				 "0001000" when X"A",
				 "0000011" when X"B",
				 "1000110" when X"C",
				 "0100001" when X"D",
				 "0000110" when X"E",
				 "0001110" when X"F",
				 "1111111" when others;
				 
	with BOTON_PRES select
  display3 <= "1000000" when X"0",
				 "1111001" when X"1",
				 "0100100" when X"2",
				 "0110000" when X"3",
				 "0011001" when X"4",
				 "0010010" when X"5",
				 "0000010" when X"6",
				 "1111000" when X"7",
				 "0000000" when X"8",
				 "0010000" when X"9",
				 "0001000" when X"A",
				 "0000011" when X"B",
				 "1000110" when X"C",
				 "0100001" when X"D",
				 "0000110" when X"E",
				 "0001110" when X"F",
				 "1111111" when others;
	
	with BOTON_PRES select
  display4 <= "1000000" when X"0",
				 "1111001" when X"1",
				 "0100100" when X"2",
				 "0110000" when X"3",
				 "0011001" when X"4",
				 "0010010" when X"5",
				 "0000010" when X"6",
				 "1111000" when X"7",
				 "0000000" when X"8",
				 "0010000" when X"9",
				 "0001000" when X"A",
				 "0000011" when X"B",
				 "1000110" when X"C",
				 "0100001" when X"D",
				 "0000110" when X"E",
				 "0001110" when X"F",
				 "1111111" when others;
				 
	with BOTON_PRES select
  display5 <= "1000000" when X"0",
				 "1111001" when X"1",
				 "0100100" when X"2",
				 "0110000" when X"3",
				 "0011001" when X"4",
				 "0010010" when X"5",
				 "0000010" when X"6",
				 "1111000" when X"7",
				 "0000000" when X"8",
				 "0010000" when X"9",
				 "0001000" when X"A",
				 "0000011" when X"B",
				 "1000110" when X"C",
				 "0100001" when X"D",
				 "0000110" when X"E",
				 "0001110" when X"F",
				 "1111111" when others;
				 
	with BOTON_PRES select
  display6 <= "1000000" when X"0",
				 "1111001" when X"1",
				 "0100100" when X"2",
				 "0110000" when X"3",
				 "0011001" when X"4",
				 "0010010" when X"5",
				 "0000010" when X"6",
				 "1111000" when X"7",
				 "0000000" when X"8",
				 "0010000" when X"9",
				 "0001000" when X"A",
				 "0000011" when X"B",
				 "1000110" when X"C",
				 "0100001" when X"D",
				 "0000110" when X"E",
				 "0001110" when X"F",
				 "1111111" when others;
				 
				
END behavioral;