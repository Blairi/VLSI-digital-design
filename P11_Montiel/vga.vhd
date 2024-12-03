library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
    generic(
        h_pulse  : integer := 96;
        h_bp     : integer := 48;
        h_pixels : integer := 640;
        h_fp     : integer := 16;
        v_pulse  : integer := 2;
        v_bp     : integer := 33;
        v_pixels : integer := 480;
        v_fp     : integer := 10
    );
    port(
        clk50MHz : in std_logic;
		  
		  -- canales RGB
        red      : out std_logic_vector(3 downto 0); 
        green    : out std_logic_vector(3 downto 0);
        blue     : out std_logic_vector(3 downto 0);
        h_sync   : out std_logic;
        v_sync   : out std_logic;
		  
        -- DECO
        A1, B1, C1, D1, E1, F1, G1 : out std_logic;
        A2, B2, C2, D2, E2, F2, G2 : out std_logic
    );
end entity vga;

architecture behavioral of vga is
    -- Señales internas
    constant h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
    constant v_period : integer := v_pulse + v_bp + v_pixels + v_fp;
    
	 -- seniales de sincronizacion
    signal h_count      : integer range 0 to h_period - 1 := 0;
    signal v_count      : integer range 0 to v_period - 1 := 0;
    signal reloj_pixel  : std_logic := '0';
    signal pixel_enable : std_logic := '0';
    signal pixel_x      : integer range 0 to h_pixels - 1 := 0;
    signal pixel_y      : integer range 0 to v_pixels - 1 := 0;
    signal pixel_color  : std_logic_vector(11 downto 0);
    
    -- DISPLAY de 7 segmentos
    signal display_color : std_logic_vector(11 downto 0);
    signal final_color  : std_logic_vector(11 downto 0);
	 
	 -- seniales para la imagen
	 signal column : integer;
    signal row : integer;
	 signal display_ena : std_logic;

    
	-- GENERADOR IMAGEN
    component generador_imagen_modulo is
        port(
            clk         : in std_logic;
            pixel_x     : in integer range 0 to 639;
            pixel_y     : in integer range 0 to 479;
            pixel_color : out std_logic_vector(11 downto 0);
            A1, B1, C1, D1, E1, F1, G1 : out std_logic;
            A2, B2, C2, D2, E2, F2, G2 : out std_logic
        );
    end component;

begin
	
	-- logica para la figura
	column <= pixel_x;
    row <= pixel_y;
    
    -- PRENDER DISPLAY
    display_ena <= '1' when pixel_x < 640 and pixel_y < 480 else '0';
	 
		process(clk50MHz)
    begin
        if rising_edge(clk50MHz) then
		  -- USANDO COLORES EN HEXADECIMAL
            if (display_ena = '1') then
                -- 1
                if ((row > 170 and row < 190) and (column > 436 and column < 496)) then
						 
                    pixel_color <= X"00F"; 
                -- 2
                elsif ((row > 170 and row < 310) and (column > 436 and column < 453)) then
                    pixel_color <= X"00F"; 
                
                -- 3
                elsif  ((row > 280 and row < 310) and (column > 436 and column < 496)) then
                    pixel_color <= X"00F"; 
                
                -- 4
                elsif  ((row > 170 and row < 310) and (column > 476 and column < 496)) then
                    pixel_color <= X"00F"; 
						  
                -- 5
                elsif  ((row > 190 and row < 280) and (column > 453 and column < 473)) then
                     pixel_color <=  X"F00"; 
					-- 6
						elsif  ((row > 170 and row < 198) and (column > 496 and column < 526)) then
							pixel_color <= X"00F"; 
					-- 7 
					elsif ((row > 226 and row < 254) and (column > 496 and column < 526)) then
							pixel_color <= X"00F"; 
					-- 8
						elsif ((row > 282 and row < 310) and (column > 496 and column < 526)) then
							pixel_color <= X"00F"; 
                
                else
                    pixel_color <= X"000"; 
                end if;
            else
                pixel_color <= X"000"; 
            end if;
        end if;
    end process;

    -- INSTANCIA IMAGEN MODULO
    ContadorDisplays: generador_imagen_modulo
    port map (
        clk         => reloj_pixel,
        pixel_x     => pixel_x,
        pixel_y     => pixel_y,
        pixel_color => display_color,
        A1 => A1, B1 => B1, C1 => C1, D1 => D1, E1 => E1, F1 => F1, G1 => G1,
        A2 => A2, B2 => B2, C2 => C2, D2 => D2, E2 => E2, F2 => F2, G2 => G2
    );

    -- Divisor de reloj para reducir la frecuencia de 50Mhz a 25 Mhz
    relojpixel: process(clk50MHz)
    begin
        if rising_edge(clk50MHz) then
            reloj_pixel <= not reloj_pixel;
        end if;
    end process relojpixel;

    -- Contadores horizontal y vertical
    contadores: process(reloj_pixel)
    begin
        if rising_edge(reloj_pixel) then
            if h_count < (h_period-1) then
                h_count <= h_count + 1;
            else
                h_count <= 0;
                if v_count < (v_period-1) then
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
                end if;
            end if;
        end if;
    end process contadores;

    -- señales de sincronizacion
    senial_hsync: process(reloj_pixel)
    begin
        if rising_edge(reloj_pixel) then
            if h_count > (h_pixels + h_fp) and h_count <= (h_pixels + h_fp + h_pulse) then
                h_sync <= '0';
            else
                h_sync <= '1';
            end if;
        end if;
    end process senial_hsync;

    senial_vsync: process(reloj_pixel)
    begin
        if rising_edge(reloj_pixel) then
            if v_count > (v_pixels + v_fp) and v_count <= (v_pixels + v_fp + v_pulse) then
                v_sync <= '0';
            else
                v_sync <= '1';
            end if;
        end if;
    end process senial_vsync;

    -- Coordenadas de pixel y señal de enable
    coords_pixel: process(reloj_pixel)
    begin
        if rising_edge(reloj_pixel) then
            if (h_count < h_pixels and v_count < v_pixels) then
                pixel_x <= h_count;
                pixel_y <= v_count;
                pixel_enable <= '1';
            else
                pixel_enable <= '0';
            end if;
        end if;
    end process coords_pixel;

     -- Mezclador de colores, selecciona el color final entre display y píxel
    color_mixer: process(pixel_color, display_color)
    begin
        if display_color /= X"000" then
            final_color <= display_color;
        else
            final_color <= pixel_color;
        end if;
    end process color_mixer;

     -- Proceso de salida para los colores
    output_color: process(pixel_enable, final_color)
    begin
        if pixel_enable = '1' then
            red   <= final_color(11 downto 8);
            green <= final_color(7 downto 4);
            blue  <= final_color(3 downto 0);
        else
            red   <= (others => '0');
            green <= (others => '0');
            blue  <= (others => '0');
        end if;
    end process output_color;

end architecture behavioral;