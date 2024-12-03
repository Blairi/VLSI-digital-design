library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
  port (
    clk50MHz: in std_logic;
    red: out std_logic_vector (3 downto 0);
    green: out std_logic_vector (3 downto 0);
    blue: out std_logic_vector (3 downto 0);
    h_sync: out std_logic;
	 switch1 : in std_logic; -- Valor predeterminado
    switch2 : in std_logic; -- Valor predeterminado
    switch3 : in std_logic; -- Valor predeterminado
    switch4 : in std_logic; -- Valor predeterminado
    switch5 : in std_logic; -- Valor predeterminado
    switch6 : in std_logic; -- Valor predeterminado
    switch7 : in std_logic; -- Valor predeterminado
    switch8 : in std_logic;
    v_sync: out std_logic
  );
end entity vga;

architecture Behavioral of vga is
  -- Constantes para monitor VGA en 640x480
  constant h_pulse : integer := 96;
  constant h_bp : integer := 48;
  constant h_pixels : integer := 640;
  constant h_fp : integer := 16;
  constant v_pulse : integer := 2;
  constant v_bp : integer := 33;
  constant v_pixels : integer := 480;
  constant v_fp : integer := 10;

  -- Contadores
  constant h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
  constant v_period : integer := v_pulse + v_bp + v_pixels + v_fp;

  signal h_count : integer range 0 to h_period - 1 := 0;
  signal v_count : integer range 0 to v_period - 1 := 0;
  signal reloj_pixel : std_logic := '0';
  signal display_ena : std_logic;
  signal row : integer := 0;
  signal column : integer := 0;

begin
  -- Proceso para generar la señal de reloj a 25 MHz
  relojpixel: process (clk50MHz) is
  begin
    if rising_edge(clk50MHz) then
      reloj_pixel <= not reloj_pixel;
    end if;
  end process relojpixel; -- 25MHz

  -- Contadores de sincronización horizontal y vertical
  contadores : process (reloj_pixel) -- H_periodo=800, V_periodo=525
  begin
    if rising_edge(reloj_pixel) then
      if h_count < (h_period - 1) then
        h_count <= h_count + 1;
      else
        h_count <= 0;
        if v_count < (v_period - 1) then
          v_count <= v_count + 1;
        else
          v_count <= 0;
        end if;
      end if;
    end if;
  end process contadores;

  -- Generación de señal de sincronización horizontal (h_sync)
  senial_hsync : process (reloj_pixel) -- h_pixel + h_fp + h_pulse = 784
  begin
    if rising_edge(reloj_pixel) then
      if h_count > (h_pixels + h_fp) and h_count < (h_pixels + h_fp + h_pulse) then
        h_sync <= '0';
      else
        h_sync <= '1';
      end if;
    end if;
  end process senial_hsync;

  -- Generación de señal de sincronización vertical (v_sync)
  senial_vsync : process (reloj_pixel) -- v_pixels + v_fp + v_pulse = 525
  begin
    if rising_edge(reloj_pixel) then
      if v_count > (v_pixels + v_fp) and v_count < (v_pixels + v_fp + v_pulse) then
        v_sync <= '0';
      else
        v_sync <= '1';
      end if;
    end if;
  end process senial_vsync;

  -- Coordenadas del pixel actual
  coords_pixel: process (reloj_pixel)
  begin
    if rising_edge(reloj_pixel) then
      if (h_count < h_pixels) then
        column <= h_count;
      end if;
      if (v_count < v_pixels) then
        row <= v_count;
      end if;
    end if;
  end process coords_pixel;

-- Instanciación del generador de imagen
  generador_imagen_inst: entity work.generador_imagen_modulo
    port map (
      display_ena => display_ena,
      row => row,
      column => column,
		switch1 => switch1,
		switch2 => switch2,
		switch3 => switch3,
		switch4 => switch4,
		switch5 => switch5,
		switch6 => switch6,
		switch7 => switch7,
		switch8 => switch8,
      red => red,
      green => green,
      blue => blue
    );

  -- Habilitador de display
  display_enable: process (reloj_pixel)
  begin
    if rising_edge(reloj_pixel) then
      if (h_count < h_pixels and v_count < v_pixels) then
        display_ena <= '1';
      else
        display_ena <= '0';
      end if;
    end if;
  end process display_enable;

end architecture Behavioral;
