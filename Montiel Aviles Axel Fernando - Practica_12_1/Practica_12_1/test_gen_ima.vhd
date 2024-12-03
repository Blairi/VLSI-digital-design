
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_gen_ima is
   port(
      clk: in std_logic;
      video_on: in std_logic;
      pixel_x, pixel_y: std_logic_vector(9 downto 0);
      r_channel: out std_logic_vector(3 downto 0);
		g_channel: out std_logic_vector(3 downto 0);
		b_channel: out std_logic_vector(3 downto 0)
   );
end entity;

architecture arch of test_gen_ima is
   signal rom_addr: std_logic_vector(8 downto 0); -- 9 bits of every address
   signal char_addr: std_logic_vector(4 downto 0); -- 5 bits for image address
   signal row_addr: std_logic_vector(3 downto 0); -- 4 bits for ROM's decoder
   signal bit_addr: std_logic_vector(3 downto 0);  -- 4 bits for ROM's multiplexor
   signal font_word_r, font_word_b, font_word_g: std_logic_vector(15 downto 0); -- 16 bits for every ROM's data
	signal bit_red, bit_green, bit_blue: std_logic;
   signal font_bit, text_bit_on: std_logic;
begin
   -- components for every channel ROM
   ROM_blue: entity work.ROM_blue_16imag_16x16
      port map(clk=>clk, addr=>rom_addr, dout=>font_word_b);
		
	ROM_green: entity work.ROM_green_16imag_16x16
      port map(clk=>clk, addr=>rom_addr, dout=>font_word_g);
		
	ROM_red: entity work.ROM_red_16imag_16x16
      port map(clk=>clk, addr=>rom_addr, dout=>font_word_r);
		
   -- interfaz para la font ROM 
   char_addr<=pixel_y(5 downto 4) & pixel_x(6 downto 4);
   row_addr<=pixel_y(3 downto 0);
   rom_addr <= char_addr & row_addr;
   bit_addr<=pixel_x(3 downto 0);
   bit_red <= font_word_r(to_integer(unsigned(not bit_addr)));
	bit_green <= font_word_g(to_integer(unsigned(not bit_addr)));
	bit_blue <= font_word_b(to_integer(unsigned(not bit_addr)));
   
   -- "on" region limitada 
	font_bit <= bit_blue or bit_green or bit_red;
   text_bit_on <= font_bit when pixel_x(9 downto 7)="000" and pixel_y(9 downto 6)="0000" else '0';
   
   -- circuito de multiplexeo rgb TODO

end arch;
