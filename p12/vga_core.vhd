library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vga_core is
   port(
      clk, reset: in std_logic;
      hsync, vsync: out std_logic;
      video_on, p_tick: out std_logic;
      pixel_x, pixel_y: out std_logic_vector (9 downto 0)
    );
end entity;

architecture arch of vga_core is
   -- VGA 640-by-480 parametros
   constant HD: integer:=640; -- area horizontal de display 
   constant HF: integer:=16 ; --h. front porch
   constant HB: integer:=48 ; --h. back porch
   constant HR: integer:=96 ; --h. retrace
   constant VD: integer:=480; --area vertical de display
   constant VF: integer:=10;  --v. front porch
   constant VB: integer:=33;  --v. back porch
   constant VR: integer:=2;   --v. retrazado
   -- contador mod-2 
   signal mod2_reg, mod2_next: std_logic;
   -- contadores para señales sync 
   signal v_count_reg, v_count_next: unsigned(9 downto 0);
   signal h_count_reg, h_count_next: unsigned(9 downto 0);
   -- salidas registradas (buffer)
   signal v_sync_reg, h_sync_reg: std_logic;
   signal v_sync_next, h_sync_next: std_logic;
   -- señales de estados 
   signal h_end, v_end, pixel_tick: std_logic;
begin
   -- registros
   process (clk,reset)
   begin
      if reset='0' then
         mod2_reg <= '0';
         v_count_reg <= (others=>'0');
         h_count_reg <= (others=>'0');
         v_sync_reg <= '0';
         h_sync_reg <= '0';
      elsif (clk'event and clk='1') then
         mod2_reg <= mod2_next;
         v_count_reg <= v_count_next;
         h_count_reg <= h_count_next;
         v_sync_reg <= v_sync_next;
         h_sync_reg <= h_sync_next;
      end if;
   end process;
   -- circuito mod-2 para generar 25 MHz enable tick
   mod2_next <= not mod2_reg;
   -- pixel tick 25 MHz 
   pixel_tick <= '1' when mod2_reg='1' else '0';
   -- status
   h_end <=  -- fin del contador horizontal
      '1' when h_count_reg=(HD+HF+HB+HR-1) else --799
      '0';
   v_end <=  -- fin del contador vertical
      '1' when v_count_reg=(VD+VF+VB+VR-1) else --524
      '0';
   -- mod-800  contador señal horizontal sync 
   process (h_count_reg,h_end,pixel_tick)
   begin
      if pixel_tick='1' then  -- 25 MHz tick
         if h_end='1' then
            h_count_next <= (others=>'0');
         else
            h_count_next <= h_count_reg + 1;
         end if;
      else
         h_count_next <= h_count_reg;
      end if;
   end process;
   -- mod-525 contador señal vertical sync
   process (v_count_reg,h_end,v_end,pixel_tick)
   begin
      if pixel_tick='1' and h_end='1' then
         if (v_end='1') then
            v_count_next <= (others=>'0');
         else
            v_count_next <= v_count_reg + 1;
         end if;
      else
         v_count_next <= v_count_reg;
      end if;
   end process;
   -- horizontal and vertical sync, registrados (buffer ) para evitar el glitch
   h_sync_next <=
      '1' when (h_count_reg>=(HD+HF))           --656
           and (h_count_reg<=(HD+HF+HR-1)) else --751
      '0';
   v_sync_next <=
      '1' when (v_count_reg>=(VD+VF))           --490
           and (v_count_reg<=(VD+VF+VR-1)) else --491
      '0';
   -- video on/off
   video_on <=
      '1' when (h_count_reg<HD) and (v_count_reg<VD) else
      '0';
   -- señales de salida
   hsync <= h_sync_reg;
   vsync <= v_sync_reg;
   pixel_x <= std_logic_vector(h_count_reg);
   pixel_y <= std_logic_vector(v_count_reg);
   p_tick <= pixel_tick;
end arch;
