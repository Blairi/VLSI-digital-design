library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_gen_ima is
   port(
      clk        : in  std_logic;
      video_on   : in  std_logic;
      pixel_x    : in  std_logic_vector(9 downto 0);
      pixel_y    : in  std_logic_vector(9 downto 0);
      r_channel  : out std_logic_vector(3 downto 0);
      g_channel  : out std_logic_vector(3 downto 0);
      b_channel  : out std_logic_vector(3 downto 0)
   );
end entity;

architecture arch of test_gen_ima is
   -- Señales internas
   signal rom_addr      : std_logic_vector(8 downto 0); -- 9 bits para dirección ROM
   signal char_addr     : std_logic_vector(4 downto 0); -- 5 bits para la dirección del carácter
   signal row_addr      : std_logic_vector(3 downto 0); -- 4 bits para la fila
   signal bit_addr      : std_logic_vector(3 downto 0); -- 4 bits para el bit de cada pixel

   -- Datos leídos de las ROMs
   signal font_word_r   : std_logic_vector(15 downto 0); -- 16 bits para cada ROM de color
   signal font_word_g   : std_logic_vector(15 downto 0);
   signal font_word_b   : std_logic_vector(15 downto 0);

   -- Bits de los colores
   signal bit_red       : std_logic;
   signal bit_green     : std_logic;
   signal bit_blue      : std_logic;

   -- Señales de control
   signal font_bit      : std_logic;
   signal text_bit_on   : std_logic;

   -- Desplazamientos para centrar la imagen
   constant CENTER_X    : integer := 312;  -- Desplazamiento en X para centrar
   constant CENTER_Y    : integer := 232;  -- Desplazamiento en Y para centrar

   -- Definimos el número a mostrar y la posición inicial de Pac-Man
   constant NUMERO      : string := "422051042";
   constant PACMAN_X    : integer := 0;  -- Coordenada inicial de Pac-Man
   constant PACMAN_Y    : integer := 0;  -- Coordenada inicial de Pac-Man

   signal adjusted_x : std_logic_vector(9 downto 0);
   signal adjusted_y : std_logic_vector(9 downto 0);

begin

   adjusted_x <= std_logic_vector(to_unsigned(to_integer(unsigned(pixel_x)) - CENTER_X, 10));
   adjusted_y <= std_logic_vector(to_unsigned(to_integer(unsigned(pixel_y)) - CENTER_Y, 10));

   ROM_blue: entity work.ROM_blue_16imag_16x16
      port map(clk => clk, addr => rom_addr, dout => font_word_b);
   
   ROM_green: entity work.ROM_green_16imag_16x16
      port map(clk => clk, addr => rom_addr, dout => font_word_g);
   
   ROM_red: entity work.ROM_red_16imag_16x16
      port map(clk => clk, addr => rom_addr, dout => font_word_r);
   
   -- Si estamos mostrando Pac-Man, activamos su sprite
   if to_integer unsigned(adjusted_x) = PACMAN_X and to_integer(unsigned(adjusted_y) = PACMAN_Y then
      -- Activar Pac-Man (esto se deberá ajustar según el sprite de Pac-Man)
      -- Ejemplo de activación de Pac-Man
      char_addr <= "pacman_sprite"; -- Aquí deberás definir el sprite
   else
      -- Mostrar los números
      char_addr <= adjusted_y(5 downto 4) & adjusted_x(6 downto 4);
   end if;
   
   row_addr <= adjusted_y(3 downto 0);
   rom_addr <= char_addr & row_addr;
   bit_addr <= adjusted_x(3 downto 0);
   
   bit_red   <= font_word_r(to_integer(unsigned(bit_addr)));
   bit_green <= font_word_g(to_integer(unsigned(bit_addr)));
   bit_blue  <= font_word_b(to_integer(unsigned(bit_addr)));

   font_bit <= bit_blue or bit_green or bit_red;
   text_bit_on <= '1' when (adjusted_x(9 downto 7) = "000") and (adjusted_y(9 downto 6) = "0000") else '0';

   process(video_on, text_bit_on, bit_red, bit_green, bit_blue)
   begin
      if video_on = '1' and text_bit_on = '1' then
         r_channel <= (others => bit_red);
         g_channel <= (others => bit_green);
         b_channel <= (others => bit_blue);
      else
         r_channel <= (others => '0');
         g_channel <= (others => '0');
         b_channel <= (others => '0');
      end if;
   end process;

end architecture;
