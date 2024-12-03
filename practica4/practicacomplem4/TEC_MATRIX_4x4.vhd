Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_unsigned.all;

entity TEC_MATRIX_4X4 is
    Generic (FREQ_CLK: integer := 50_000_00);
    Port( 
			CLK: IN STD_LOGIC; -- reloj 
			
			-- teclado matricia
        COLUMNAS: in std_logic_vector(3 downto 0); 
        rows	: out std_logic_vector(3 downto 0);
		  
        IND: out std_logic;
		  
		  -- displays
        D1 : BUFFER std_logic_vector(6 downto 0);
		  D2 : BUFFER std_logic_vector(6 downto 0);
		  D3 : BUFFER std_logic_vector(6 downto 0);
		  D4 : BUFFER std_logic_vector(6 downto 0);
		  
		  -- salida del buzzer
        BUZZER: out std_logic
		  );
end TEC_MATRIX_4X4;

architecture behavioral of TEC_MATRIX_4X4 is
		
	 -- C_1MS, contador_10ms, C_5S: Estas señales cuentan los ciclos del reloj para generar los retardos de 1ms, 10ms y 5 segundos, respectivamente.
	 -- Flags: flag1 y flag2 son indicadores (banderas) que se activan cuando se alcanzan los valores de tiempo deseados. Por ejemplo, flag1 
	 -- se activa cuando el contador de 1ms llega a su valor.
    SIGNAL C_1MS : INTEGER RANGE 0 TO D_1MS := 0;
    SIGNAL flag1 : STD_LOGIC := '0';
    SIGNAL contador_10ms : INTEGER RANGE 0 TO D_10MS := 0;
    SIGNAL flag2 : STD_LOGIC := '0';
    SIGNAL C_5S : INTEGER RANGE 0 TO D_5S := 0;
    SIGNAL BAN_5S : STD_LOGIC := '0';
	 
	 -- D_1MS, D_10MS y D_5S: Estas constantes definen retardos de 1 milisegundo, 10 milisegundos y 5 segundos, respectivamente. 
	 -- Se calculan usando la frecuencia del reloj del sistema (FREQ_CLK).
	 CONSTANT D_1MS : INTEGER := (FREQ_CLK/1000)-1;
    CONSTANT D_10MS : INTEGER := (FREQ_CLK/100)-1;
    CONSTANT D_5S : INTEGER := (FREQ_CLK * 5) - 1;
	 
	 -- seniales de control
    SIGNAL BOT_1: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
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
	 SIGNAL BOT_AS: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0'); 
	 SIGNAL BOT_GA : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	 
	 -- seniales del teclado
    SIGNAL indS : STD_LOGIC := '0';
    SIGNAL estado : INTEGER RANGE 0 TO 1 := 0;
    SIGNAL fila_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL row: INTEGER := 0;
    SIGNAL entrada : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 
	 -- buffer para las teclas
    SIGNAL D_buf : std_logic_vector(27 downto 0) := (others => '1');
    SIGNAL button_anterior : std_logic_vector(3 downto 0) := (others => '1');
    SIGNAL button_presionandose : std_logic := '0';
    
	 -- maquina de estados
    TYPE state_type IS (Q_0, Q_1, Q_2, Q_3, V, retornoAbsoluto);
    SIGNAL Q_actual, Q_next: state_type := Q_0;
    SIGNAL RST_DISP : std_logic := '0';

BEGIN
		-- indicamos que fila esta activa
    rows <= fila_reg;
    
    
	 -- temporizacion 1ms
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            C_1MS <= C_1MS+1;
            flag1 <= '0';    
            IF C_1MS = D_1MS THEN
                C_1MS <= 0;
                flag1 <= '1';
            END IF;
        END IF;
    END PROCESS;
    
	-- temporizacion 10ms
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            contador_10ms <= contador_10ms+1;
            flag2 <= '0';
            IF contador_10ms = D_10MS THEN
                contador_10ms <= 0;
                flag2 <= '1';
            END IF;
        END IF;
    END PROCESS;
    
    
	 -- temporizacion 5 seg
   PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            C_5S <= C_5S+1;
            BAN_5S <= '0';
            IF C_5S = D_5S THEN
                C_5S <= 0;
                BAN_5S <= '1';
            END IF;
        END IF;
    END PROCESS;
    
    
	 -- Este proceso escanea las filas del teclado matricial. Cada vez que pasa un ciclo de 10 ms (cuando flag2 está en '1'), la señal row se incrementa
    PROCESS(CLK, flag2)
    BEGIN
        IF RISING_EDGE(CLK) AND flag2 = '1' THEN
            row <= row+1;
            IF row = 3 THEN
                row <= 0;
            END IF;
        END IF;
    END PROCESS;
	
    WITH row SELECT
        fila_reg <= "1000" WHEN 0,
                      "0100" WHEN 1,
                      "0010" WHEN 2,
                      "0001" WHEN OTHERS;
    
    
    PROCESS(CLK,flag1)
    BEGIN
        IF RISING_EDGE(CLK) AND flag1 = '1' THEN
            IF fila_reg = "1000" THEN
                        Bot_1 <= Bot_1(6 DOWNTO 0)&COLUMNAS(3);
                        Bot_2 <= Bot_2(6 DOWNTO 0)&COLUMNAS(2);
                        Bot_3 <= Bot_3(6 DOWNTO 0)&COLUMNAS(1);
                        Bot_A <= Bot_A(6 DOWNTO 0)&COLUMNAS(0);
            ELSIF fila_reg = "0100" THEN
                        Bot_4 <= Bot_4(6 DOWNTO 0)&COLUMNAS(3);
                        Bot_5 <= Bot_5(6 DOWNTO 0)&COLUMNAS(2);
                        Bot_6 <= Bot_6(6 DOWNTO 0)&COLUMNAS(1);
                        Bot_B <= Bot_B(6 DOWNTO 0)&COLUMNAS(0);
            ELSIF fila_reg = "0010" THEN
                        Bot_7 <= Bot_7(6 DOWNTO 0)&COLUMNAS(3);
                        Bot_8 <= Bot_8(6 DOWNTO 0)&COLUMNAS(2);
                        Bot_9 <= Bot_9(6 DOWNTO 0)&COLUMNAS(1);
                        Bot_C <= Bot_C(6 DOWNTO 0)&COLUMNAS(0);
            ELSIF fila_reg = "0001" THEN
                        Bot_AS <= Bot_AS(6 DOWNTO 0)&COLUMNAS(3);
                        Bot_0 <= Bot_0(6 DOWNTO 0)&COLUMNAS(2);
                        Bot_GA <= Bot_GA(6 DOWNTO 0)&COLUMNAS(1);
                        Bot_D <= Bot_D(6 DOWNTO 0)&COLUMNAS(0);
            END IF;
        END IF;
    END PROCESS;
    
	 -- entradas del teclado
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF Bot_0 = "11111111" THEN entrada <= X"0"; indS <= '1';
            ELSIF Bot_1 = "11111111" THEN entrada <= X"1"; indS <= '1';
            ELSIF Bot_2 = "11111111" THEN entrada <= X"2"; indS <= '1';
            ELSIF Bot_3 = "11111111" THEN entrada <= X"3"; indS <= '1';
            ELSIF Bot_4 = "11111111" THEN entrada <= X"4"; indS <= '1';
            ELSIF Bot_5 = "11111111" THEN entrada <= X"5"; indS <= '1';
            ELSIF Bot_6 = "11111111" THEN entrada <= X"6"; indS <= '1';
            ELSIF Bot_7 = "11111111" THEN entrada <= X"7"; indS <= '1';
            ELSIF Bot_8 = "11111111" THEN entrada <= X"8"; indS <= '1';
            ELSIF Bot_9 = "11111111" THEN entrada <= X"9"; indS <= '1';
            ELSIF Bot_A = "11111111" THEN entrada <= X"A"; indS <= '1';
            ELSIF Bot_B = "11111111" THEN entrada <= X"B"; indS <= '1';
            ELSIF Bot_C = "11111111" THEN entrada <= X"C"; indS <= '1';
            ELSIF Bot_D = "11111111" THEN entrada <= X"D"; indS <= '1';
            ELSIF Bot_AS = "11111111" THEN entrada <= X"E"; indS <= '1';
            ELSIF Bot_GA = "11111111" THEN entrada <= X"F"; indS <= '1';
            ELSE indS <= '0';
            END IF;
        END IF;
    END PROCESS;
    
    
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF estado = 0 THEN
                IF indS = '1' THEN
                    IND <= '1';
                    estado <= 1;
                ELSE
                    estado <= 0;
                    IND <= '0';
                END IF;
            ELSE
                IF indS = '1' THEN
                    estado <= 1;
                    IND <= '0';
                ELSE
                    estado <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

   
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            button_presionandose <= '0';  
            
            IF indS = '1' AND entrada /= button_anterior THEN
                button_presionandose <= '1';
                button_anterior <= entrada;
                D_buf(27 downto 7) <= D_buf(20 downto 0);
         -- deco
                CASE entrada IS
                    WHEN X"0" => D_buf(6 downto 0) <= "1000000";
                    WHEN X"1" => D_buf(6 downto 0) <= "1111001";
                    WHEN X"2" => D_buf(6 downto 0) <= "0100100";
                    WHEN X"3" => D_buf(6 downto 0) <= "0110000";
                    WHEN X"4" => D_buf(6 downto 0) <= "0011001";
                    WHEN X"5" => D_buf(6 downto 0) <= "0010010";
                    WHEN X"6" => D_buf(6 downto 0) <= "0000010";
                    WHEN X"7" => D_buf(6 downto 0) <= "1111000";
                    WHEN X"8" => D_buf(6 downto 0) <= "0000000";
                    WHEN X"9" => D_buf(6 downto 0) <= "0010000";
                    WHEN X"A" => D_buf(6 downto 0) <= "0001000";
                    WHEN X"B" => D_buf(6 downto 0) <= "0000011";
                    WHEN X"C" => D_buf(6 downto 0) <= "1000110";
                    WHEN X"D" => D_buf(6 downto 0) <= "0100001";
                    WHEN X"E" => D_buf(6 downto 0) <= "0000110";
                    WHEN X"F" => D_buf(6 downto 0) <= "0001110";
                    WHEN OTHERS => D_buf(6 downto 0) <= "1111111";
                END CASE;
            END IF;

            IF RST_DISP = '1' THEN
                D_buf <= (others => '1');
            END IF;
				
				-- corrimiento de los decos
            D1 <= D_buf(6 downto 0);
            D2 <= D_buf(13 downto 7);
            D3 <= D_buf(20 downto 14);
            D4 <= D_buf(27 downto 21);
        END IF;
    END PROCESS;

	
	 
	 
	 -- logica de la maquina de estados
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            Q_actual <= Q_next;
            
            CASE Q_actual IS
                WHEN Q_0 =>
                    BUZZER <= '0';
                    RST_DISP <= '0';
                    IF button_presionandose = '1' THEN
                        IF entrada = X"1" THEN
                            Q_next<= Q_1;
                        
                        END IF;
                    END IF;
                
                WHEN Q_1 =>
                    IF button_presionandose = '1' THEN
                        IF entrada = X"2" THEN
                            Q_next<= Q_2;
                        
                        END IF;
                    END IF;
                
                WHEN Q_2 =>
                    IF button_presionandose = '1' THEN
                        IF entrada = X"3" THEN
                            Q_next<= Q_3;
                        
                        END IF;
                    END IF;
                
                WHEN Q_3 =>
                    IF button_presionandose = '1' THEN
                        IF entrada = X"A" THEN
                            Q_next<= V;
                        
                        END IF;
					END IF;
                
                WHEN V =>
                    BUZZER <= '1';
                    IF BAN_5S = '1' THEN
								-- reiniciamos la maquina
                        Q_next<= Q_0;
                        RST_DISP <= '1';
                    END IF;
                
                WHEN retornoAbsoluto =>
                    BUZZER <= '0';
                    IF BAN_5S = '1' THEN
                        Q_next<= Q_0;
                        RST_DISP <= '1';
                    END IF;
                
                WHEN OTHERS =>
                    Q_next<= Q_0;
            END CASE;
        END IF;
    END PROCESS;

END behavioral;
