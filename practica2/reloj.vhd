library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reloj_contador is
    Port (
		  reset: in std_logic;
        reloj: in std_logic;
        encender: in std_logic;  -- Senial para habilitar el conteo
        L1: out std_logic_vector(6 downto 0); -- Unidades de segundo
        L2: out std_logic_vector(6 downto 0); -- Decenas de segundo
        L3: out std_logic_vector(6 downto 0)  -- Unidades de minuto
    );
end reloj_contador;

architecture Behavioral of reloj_contador is
    signal segundo: std_logic;
    signal n, e: std_logic;
    signal Qs, Qdm, Qm: std_logic_vector(3 downto 0);

    -- Variables para contar
    signal cuenta_segundos: unsigned(27 downto 0) := (others => '0');
    signal cuenta_unidades: unsigned(3 downto 0) := to_unsigned(9, 4);
    signal cuenta_decenas: unsigned(3 downto 0) := to_unsigned(5, 4);
    signal cuenta_minutos: unsigned(3 downto 0) := to_unsigned(3, 4);

begin
    -- Proceso para dividir la frecuencia del reloj a 1 Hz
    divisor: process (reloj)
    begin
        if rising_edge(reloj) then
            if encender = '1' then
                if cuenta_segundos = X"48009E0" then
                    cuenta_segundos <= (others => '0');
                else
                    cuenta_segundos <= cuenta_segundos + 1;
                end if;
                segundo <= cuenta_segundos(22);  -- Pulso de 1 Hz
            end if;
        end if;
    end process;

    -- Proceso para contar unidades de segundo
    unidades: process (segundo, reset)
    begin
        if reset = '1' then
            cuenta_unidades <= to_unsigned(9, 4);
            n <= '0';
        elsif rising_edge(segundo) and encender = '1' then
            if cuenta_unidades = to_unsigned(0, 4) then
                cuenta_unidades <= to_unsigned(9, 4);
                n <= '1';
            else
                cuenta_unidades <= cuenta_unidades - 1;
                n <= '0';
            end if;
        end if;
        Qs <= std_logic_vector(cuenta_unidades);
    end process;

    -- Proceso para contar decenas de segundo
    decenas: process (n, reset)
    begin
        if reset = '1' then
            cuenta_decenas <= to_unsigned(5, 4);
            e <= '0';
        elsif rising_edge(n) and encender = '1' then
            if cuenta_decenas = to_unsigned(0, 4) then
                cuenta_decenas <= to_unsigned(5, 4);
                e <= '1';
            else
                cuenta_decenas <= cuenta_decenas - 1;
                e <= '0';
            end if;
        end if;
        Qdm <= std_logic_vector(cuenta_decenas);
    end process;

    -- Proceso para contar unidades de minuto
    minutos: process (e, reset)
    begin
        if reset = '1' then
            cuenta_minutos <= to_unsigned(3, 4);  -- Se reinicia en 3:59
        elsif rising_edge(e) and encender = '1' then
            if cuenta_minutos = to_unsigned(0, 4) then
                cuenta_minutos <= to_unsigned(3, 4);  -- Se reinicia en 3:59
            else
                cuenta_minutos <= cuenta_minutos - 1;
            end if;
        end if;
        Qm <= std_logic_vector(cuenta_minutos);
    end process;
	 
	-- DECOS
	 
    with Qs select
    -- Decodificacion de las señales para los displays de 7 segmentos
    L1 <= "1000000" when "0000",
          "1111001" when "0001", 
          "0100100" when "0010", 
          "0110000" when "0011", 
          "0011001" when "0100", 
          "0010010" when "0101", 
          "0000010" when "0110", 
          "1111000" when "0111", 
          "0000000" when "1000", 
          "0010000" when "1001", 
          "1111111"when others;  -- Estado por defecto: display apagado
	with Qdm select
    L2 <= "1000000" when "0000", 
          "1111001" when "0001", 
          "0100100" when "0010", 
          "0110000" when "0011", 
          "0011001" when "0100", 
          "0010010" when "0101", 
          "1111111" when others;  -- Estado por defecto: display apagado
	with Qm select
    L3 <= "1000000" when "0000", 
          "1111001" when "0001", 
          "0100100" when "0010", 
          "0110000" when "0011", 
          "1111111"when others;  -- Estado por defecto: display apagado
end Behavioral;
