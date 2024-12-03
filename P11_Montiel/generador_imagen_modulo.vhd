library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entidad para generar imagenes en el display de 7 segmentos
entity generador_imagen_modulo is
    port (
        clk         : in std_logic;
        pixel_x     : in integer range 0 to 639;
        pixel_y     : in integer range 0 to 479;
        pixel_color : out std_logic_vector(11 downto 0);
        A1, B1, C1, D1, E1, F1, G1 : out std_logic;
        A2, B2, C2, D2, E2, F2, G2 : out std_logic
    );
end entity generador_imagen_modulo;

architecture Behavioral of generador_imagen_modulo is

    -- DISPLAY EN LOGICA NEGADA
    constant cero   : std_logic_vector(6 downto 0) := "0111111";
    constant uno    : std_logic_vector(6 downto 0) := "0000110";
    constant dos    : std_logic_vector(6 downto 0) := "1011011";
    constant tres   : std_logic_vector(6 downto 0) := "1001111";
    constant cuatro : std_logic_vector(6 downto 0) := "1100110";
    constant cinco  : std_logic_vector(6 downto 0) := "1101101";
    constant seis   : std_logic_vector(6 downto 0) := "1111101";
    constant siete  : std_logic_vector(6 downto 0) := "0000111";
    constant ocho   : std_logic_vector(6 downto 0) := "1111111";
    constant nueve  : std_logic_vector(6 downto 0) := "1100111";
	 
	 
	  -- Señales para conectar el decodificador de unidades y decenas
    signal conectornum1 : std_logic_vector(6 downto 0); 
    signal conectornum2 : std_logic_vector(6 downto 0); 

    -- Contadores para unidades, decenas y segundos
    signal contador_unidades : integer range 0 to 9 := 0;
    signal contador_decenas : integer range 0 to 9 := 0;
    signal contador_segundos : integer range 0 to 49_999_999 := 0;

     -- Coordenadas del píxel actual y habilitación del display
    signal column : integer;
    signal row : integer;
    signal display_ena : std_logic;

begin
    
	 -- asignar coordenas al pixel
    column <= pixel_x;
    row <= pixel_y;
	 
	 -- activa el display si el pixel esta en el area visible
    display_ena <= '1' when pixel_x < 640 and pixel_y < 480 else '0';

    -- Proceso de conteo  para unidades y decenas
    conteo: process(clk)
    begin
        if rising_edge(clk) then
            if contador_segundos < 19_999_999 then
                contador_segundos <= contador_segundos + 1;
            else
                contador_segundos <= 0;
                if contador_decenas = 9 and contador_unidades = 5 then
                    -- Reset 
                    contador_decenas <= 0;
                    contador_unidades <= 0;
                else
                    -- Incremento
                    if contador_unidades = 9 then
                        contador_unidades <= 0;
                        if contador_decenas < 9 then
                            contador_decenas <= contador_decenas + 1;
                        end if;
                    else
                        contador_unidades <= contador_unidades + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- DECO unidades
    with contador_unidades select
        conectornum1 <=
            cero    when 0,
            uno     when 1,
            dos     when 2,
            tres    when 3,
            cuatro  when 4,
            cinco   when 5,
            seis    when 6,
            siete   when 7,
            ocho    when 8,
            nueve   when 9,
            "0000000" when others;

    -- DECO decenas
    with contador_decenas select
        conectornum2 <=
            cero    when 0,
            uno     when 1,
            dos     when 2,
            tres    when 3,
            cuatro  when 4,
            cinco   when 5,
				seis    when 6,
            siete   when 7,
            ocho    when 8,
            nueve   when 9,
            "0000000" when others;

    -- Asigna cada segmento del display de unidades
    A1 <= conectornum1(0);
    B1 <= conectornum1(1);
    C1 <= conectornum1(2);
    D1 <= conectornum1(3);
    E1 <= conectornum1(4);
    F1 <= conectornum1(5);
    G1 <= conectornum1(6);

    -- Asigna cada segmento del display de decenas
    A2 <= conectornum2(0);
    B2 <= conectornum2(1);
    C2 <= conectornum2(2);
    D2 <= conectornum2(3);
    E2 <= conectornum2(4);
    F2 <= conectornum2(5);
    G2 <= conectornum2(6);

     -- Proceso para emular el color de los segmentos en el display
    process(display_ena, column, row, conectornum1, conectornum2)
    begin
        if display_ena = '1' then
		  
            --Color por defecto
            pixel_color <= X"000";

            -- Unidades 
				
            -- A
            if conectornum1(0) = '1' then
                if (row > 200 and row < 210) and (column > 330 and column < 360) then
                    pixel_color <= X"00F";
                end if;
            end if;

            -- B
            if conectornum1(1) = '1' then
                if (row > 210 and row < 240) and (column > 360 and column < 370) then
                    pixel_color <= X"0F0";
                end if;
            end if;

            -- C
            if conectornum1(2) = '1' then
                if (row > 250 and row < 280) and (column > 360 and column < 370) then
                    pixel_color <= X"F00";
                end if;
            end if;

            -- D
            if conectornum1(3) = '1' then
                if (row > 280 and row < 290) and (column > 330 and column < 360) then
                    pixel_color <= X"FFF";
                end if;
            end if;

            -- E
            if conectornum1(4) = '1' then
                if (row > 250 and row < 280) and (column > 320 and column < 330) then
                    pixel_color <= X"0FF";
                end if;
            end if;

            -- F
            if conectornum1(5) = '1' then
                if (row > 210 and row < 240) and (column > 320 and column < 330) then
                    pixel_color <= X"FF0";
                end if;
            end if;

            -- Segment G 
            if conectornum1(6) = '1' then
                if (row > 240 and row < 250) and (column > 330 and column < 360) then
                    pixel_color <= X"F0F";
                end if;
            end if;

            -- DECENAS 
				
            -- A
            if conectornum2(0) = '1' then
                if (row >= 200 and row < 210) and (column > 270 and column < 300) then
                    pixel_color <= X"00F";
                end if;
            end if;

            -- B
            if conectornum2(1) = '1' then
                if (row >= 210 and row < 240) and (column > 300 and column < 310) then
                    pixel_color <= X"0F0";
                end if;
            end if;

            -- C
            if conectornum2(2) = '1' then
                if (row >= 250 and row < 280) and (column > 300 and column < 310) then
                    pixel_color <= X"F00";
                end if;
            end if;

            -- D
            if conectornum2(3) = '1' then
                if (row >= 280 and row < 290) and (column > 270 and column < 300) then
                    pixel_color <= X"FFF";
                end if;
            end if;

            -- E
            if conectornum2(4) = '1' then
                if (row >= 250 and row < 280) and (column > 260 and column < 270) then
                    pixel_color <= X"0FF";
                end if;
            end if;

            -- F
            if conectornum2(5) = '1' then
                if (row > 210 and row < 240) and (column > 260 and column < 270) then
                    pixel_color <= X"FF0";
                end if;
            end if;

            -- G
            if conectornum2(6) = '1' then
                if (row >= 240 and row < 250) and (column > 270 and column < 300) then
                    pixel_color <= X"F0F";
                end if;
            end if;

        else
            pixel_color <= X"000";
        end if;
    end process;

end architecture Behavioral;