library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sonicos is
Port (
    clk: in STD_LOGIC;
    sensor_disp: out STD_LOGIC;
    sensor_eco: in STD_LOGIC;
    segmentos: out STD_LOGIC_VECTOR (7 downto 0);
    segmentos2: out STD_LOGIC_VECTOR (7 downto 0);
	 control     : out STD_LOGIC;
	 S: out STD_LOGIC_VECTOR(7 downto 0);
	 T: out STD_LOGIC_VECTOR(7 downto 0);
	 O: out STD_LOGIC_VECTOR(7 downto 0);
	 U: out STD_LOGIC_VECTOR(7 downto 0)
);
end sonicos;

architecture Behavioral of sonicos is
signal cuenta: unsigned(16 downto 0) := (others => '0');
signal centimetros: unsigned(15 downto 0) := (others => '0');
signal centimetros_unid: unsigned(3 downto 0) := (others => '0');
signal centimetros_dece: unsigned(3 downto 0) := (others => '0');
signal sal_unid: unsigned(3 downto 0) := (others => '0');
signal sal_dece: unsigned(3 downto 0) := (others => '0');
signal digito: unsigned(3 downto 0) := (others => '0');
signal digito2: unsigned(3 downto 0) := (others => '0');
signal eco_pasado: std_logic := '0';
signal eco_sinc: std_logic := '0';
signal eco_nsinc: std_logic := '0';
signal espera: std_logic := '0'; 
signal siete_seg_cuenta: unsigned(15 downto 0) := (others => '0');

 -- Declaración de señales para el servomotor
	 signal activar_servo : STD_LOGIC;
    signal Pini_sig, Pfin_sig : STD_LOGIC;
	 -- Instanciamos el componente del servomotor
    component servomotor
        Port (
            reloj_sv : in  STD_LOGIC;
            Pini     : in  STD_LOGIC;
            Pfin     : in  STD_LOGIC;
            control  : out STD_LOGIC
        );
    end component;

begin

siete_seg: process(clk)
begin
    if rising_edge(clk) then
        if siete_seg_cuenta(siete_seg_cuenta'high) = '1' then
            digito <= sal_unid;
        else
            digito2 <= sal_dece;
        end if;
        siete_seg_cuenta <= siete_seg_cuenta +1;
    end if;
end process;

Trigger:process(clk)
begin
    if rising_edge(clk) then
        if espera = '0' then
            if cuenta = 500 then
                sensor_disp <= '0';
                espera <= '1';
                cuenta <= (others => '0');
            else
                sensor_disp <= '1';
                cuenta <= cuenta+1;
            end if;
        elsif eco_pasado = '0' and eco_sinc = '1' then
            cuenta <= (others => '0');
            centimetros <= (others => '0');
            centimetros_unid <= (others => '0');
            centimetros_dece <= (others => '0');
        elsif eco_pasado = '1' and eco_sinc = '0' then
            sal_unid <= centimetros_unid;
            sal_dece <= centimetros_dece;
        elsif cuenta = 2900-1 then
            if centimetros_unid = 9 then
                centimetros_unid <= (others => '0');
                centimetros_dece <= centimetros_dece + 1;
            else
                centimetros_unid <= centimetros_unid + 1;
            end if;
            centimetros <= centimetros + 1;
            cuenta<= (others => '0');
            if centimetros = 3448 then
                espera <= '0';
            end if;
        else
            cuenta <= cuenta + 1;
        end if;

        eco_pasado<= eco_sinc;
        eco_sinc <= eco_nsinc;
        eco_nsinc <= sensor_eco;
    end if;
end process;


-- Asignación de las señales Pini y Pfin
    Pini_sig <= '1' when activar_servo = '0' else '0';  -- Mueve a 0 grados si 'activar_servo' es 0
    Pfin_sig <= '1' when activar_servo = '1' else '0';  -- Mueve a 180 grados si 'activar_servo' es 1

    -- Instanciación del componente del servomotor
    U_servomotor: servomotor
        Port map (
            reloj_sv => clk,
            Pini     => Pini_sig,
            Pfin     => Pfin_sig,
            control  => control
        );

		  -- Lógica para activar o desactivar el servomotor según la distancia
    process(digito, digito2)
    begin
        -- Convertir 'centimetros' a natural para la comparación
        if (digito2=X"1" and (digito=X"3" or  digito=X"4" or  digito=X"5" or  digito=X"6" or  digito=X"7" or  digito=X"8" or  digito=X"9" ) ) then
            activar_servo <= '1';  -- Activa el servomotor si la distancia está en el rango
        else
            activar_servo <= '0';  -- Desactiva el servomotor si la distancia está fuera del rango
        end if;
    end process;
		  

Decodificador: process (digito, digito2)
begin

    if digito=X"0" then segmentos <= X"81";
    elsif digito=X"1" then segmentos <= X"F3";
    elsif digito=X"2" then segmentos <= X"49";
    elsif digito=X"3" then segmentos <= X"61";
    elsif digito=X"4" then segmentos <= X"33";
    elsif digito=X"5" then segmentos <= X"25";
    elsif digito=X"6" then segmentos <= X"05";
    elsif digito=X"7" then segmentos <= X"F1";
    elsif digito=X"8" then segmentos <= X"01";
    elsif digito=X"9" then segmentos <= X"21";
    elsif digito=X"a" then segmentos <= X"11";
    elsif digito=X"b" then segmentos <= X"07";
    elsif digito=X"c" then segmentos <= X"8D";
    elsif digito=X"d" then segmentos <= X"43";
    elsif digito=X"e" then segmentos <= X"0D";
    else
        segmentos<= X"1D";
	 end if;

    if digito2=X"0" then segmentos2 <= X"81";
    elsif digito2=X"1" then segmentos2 <= X"F3";
    elsif digito2=X"2" then segmentos2 <= X"49";
    elsif digito2=X"3" then segmentos2 <= X"61";
    elsif digito2=X"4" then segmentos2 <= X"33";
    elsif digito2=X"5" then segmentos2 <= X"25";
    elsif digito2=X"6" then segmentos2 <= X"05";
    elsif digito2=X"7" then segmentos2 <= X"F1";
    elsif digito2=X"8" then segmentos2 <= X"01";
    elsif digito2=X"9" then segmentos2 <= X"21";
    elsif digito2=X"a" then segmentos2 <= X"11";
    elsif digito2=X"b" then segmentos2 <= X"07";
    elsif digito2=X"c" then segmentos2 <= X"8D";
    elsif digito2=X"d" then segmentos2 <= X"43";
    elsif digito2=X"e" then segmentos2 <= X"0D";
    else
        segmentos2<= X"1D";
    end if;
	 if (digito2=X"1" and (digito=X"3" or  digito=X"4" or  digito=X"5" or  digito=X"6" or  digito=X"7" or  digito=X"8" or  digito=X"9" )) then
		  --' en los displays palabra “OUT “ que saldrá 
		    O <= X"81"; -- O para OUT
                U <= X"7E"; -- U para OUT
                T <= X"0F"; -- T para OUT
else	
              O <= X"FF"; -- O apagado
              U <= X"FF"; -- U apagado
             T <= X"FF"; -- T apagado
		  
    end if;
end process;

end Behavioral;