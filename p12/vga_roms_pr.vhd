
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vga_roms_pr is
   port(
      clk, reset: in std_logic;
      hsync, vsync: out  std_logic;
      r_out: out std_logic_vector(3 downto 0);
		g_out: out std_logic_vector(3 downto 0);
		b_out: out std_logic_vector(3 downto 0)
   );
end entity;

architecture arch of vga_roms_pr is
   signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
   signal video_on, pixel_tick: std_logic;
   signal r_reg, r_next: std_logic_vector(3 downto 0);
	signal g_reg, g_next: std_logic_vector(3 downto 0);
	signal b_reg, b_next: std_logic_vector(3 downto 0);
begin
   
	-- circuito VGA sync 
   vga_sync_unit: entity work.vga_core
      port map(clk=>clk, reset=>reset, hsync=>hsync,
               vsync=>vsync, video_on=>video_on,
               pixel_x=>pixel_x, pixel_y=>pixel_y,
               p_tick=>pixel_tick);
   
	--  font ROM
   font_gen_unit: entity work.test_gen_ima
      port map(clk=>clk, video_on=>video_on,
               pixel_x=>pixel_x, pixel_y=>pixel_y,
               r_channel=>r_next, g_channel=>g_next,
					b_channel=>b_next);
   
	-- registro rgb
   process (clk)
   begin
      if (clk'event and clk='1') then
         if (pixel_tick='1') then
            r_reg <= r_next;
				b_reg <= b_next;
				g_reg <= g_next;
         end if;
      end if;
   end process;
   r_out <= r_reg;
	g_out <= g_reg;
	b_out <= b_reg;
end arch;