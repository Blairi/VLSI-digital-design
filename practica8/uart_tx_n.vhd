library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity uart_tx_n is
  generic (
    g_CLKS_PER_BIT : integer := 5200     -- Because of baud rate (50_000_000/9_600 = 5200)
    );
  port (  i_rst : in  std_logic; -- main reset
            i_Clk : in  std_logic; -- FGPA Clock
           o_TX_Active : out std_logic; -- TX active
           o_TX_Serial : out std_logic; -- Serial out TX
           o_TX_Done   : out std_logic -- Transmission data done
    );
end uart_tx_n;
 
 
architecture RTL of uart_tx_n is
 
  type t_SM_Main is (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits, s_TX_Stop_Bit, s_Cleanup);
  signal r_pr_state, r_nxt_state : t_SM_Main;
  constant tmax : integer := 8 * (g_CLKS_PER_BIT-1);
  signal r_Clk_Count  : integer range 0 to tmax := 0;
  signal r_Bit_Index_reg, r_Bit_Index_nxt : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_TX_Data_reg, r_TX_Data_nxt   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
  signal i_TX_Byte   : std_logic_vector(7 downto 0); -- Data 8 bits
  signal i_TX_DV     : std_logic := '0'; -- Data valid
  
  signal pulso : STD_LOGIC :='0';
  signal conta2: INTEGER RANGE 0 TO 49_999_999 := 0; 
  signal conta : INTEGER range 0 to 49_999_999 := 0;
  signal valor : INTEGER range 0 to 49_999_999 := 70_000;
  signal i : INTEGER range 0 to 4;

begin
 

process (i_rst, i_Clk)
 begin
	if (i_rst = '0') then 
		r_pr_state <= s_Idle;
      r_Bit_Index_reg <= 0;
	   r_TX_Data_reg <= (others => '0');
	elsif rising_edge(i_Clk) then
		r_pr_state <= r_nxt_state;
      r_Bit_Index_reg <= r_Bit_Index_nxt;
	   r_TX_Data_reg <= r_TX_Data_nxt;
	end if;
 end process;

 -- Temporizer
 process (i_rst, i_Clk)
 begin
  if i_rst = '0' then 
    r_Clk_Count <= 0;
  elsif rising_edge(i_Clk) then
    if r_pr_state /= r_nxt_state then
      r_Clk_Count <= 0;
    elsif (r_Clk_Count /= tmax) then
      r_Clk_Count <= r_Clk_Count + 1;
    end if;
  end if;
end process;


TX_divisor : process(i_Clk)
	begin 
		if rising_edge(i_Clk) then
			conta2 <= conta2 + 1;
			if (conta2 < 70_000) then
				pulso <= '1';
			else 
				pulso <= '0';
			end if;
		end if;
end process TX_divisor;

TX_prepara : process(i_Clk, i_TX_DV, pulso)
	type arreglo is array (0 to 8) of STD_LOGIC_VECTOR(7 downto 0);
	variable asc_dato : arreglo := (X"41", X"58", X"45" ,X"4C", X"20", X"4D",X"4F",X"4E",X"54");
		
begin
	if (pulso ='1') then
		if rising_edge(i_Clk) then
			if (conta = valor) then
					conta <= 0;
					i_TX_DV <= '1';
					i_TX_Byte <= asc_dato(i);
						if (i=1) then
							i <= 0;
						else
							i <= i+1;
						end if;
			else
				conta <= conta+1;
				i_TX_DV <= '0';
			end if;
		end if;
	end if;
	
end process TX_prepara;	
   
  p_UART_TX : process (r_pr_state, i_TX_DV, i_TX_Byte, r_Clk_Count, r_TX_Data_reg, r_Bit_Index_reg)
  begin
      r_TX_Data_nxt <= r_TX_Data_reg;  
      r_Bit_Index_nxt <= r_Bit_Index_reg; 
      case r_pr_state is
 
        when s_Idle =>
          o_TX_Active <= '0';
          o_TX_Serial <= '1';         
          r_TX_Done   <= '0';
          r_Bit_Index_nxt <= 0;
			 
          if i_TX_DV = '1' then
            r_TX_Data_nxt <= i_TX_Byte;  
            r_nxt_state <= s_TX_Start_Bit; 
          else
            r_nxt_state <= s_Idle;
          end if;
 
       
        when s_TX_Start_Bit =>
          o_TX_Active <= '1';
          o_TX_Serial <= '0';
			 r_TX_Done   <= '0';
		    r_Bit_Index_nxt <= 0;
        
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
             r_nxt_state   <= s_TX_Start_Bit;
          else
            r_nxt_state   <= s_TX_Data_Bits;
          end if;
 
        
        when s_TX_Data_Bits =>
          o_TX_Serial <= r_TX_Data_reg(r_Bit_Index_reg);
			 o_TX_Active <= '1';
			 r_TX_Done   <= '0';
			 r_TX_Data_nxt <= r_TX_Data_reg;
            -- Check if we have sent out all bits
            if r_Clk_Count < tmax then
		   r_nxt_state   <= s_TX_Data_Bits;
	         if r_Clk_Count = ((g_CLKS_PER_BIT-1)* (r_Bit_Index_reg + 1)) then
                  r_Bit_Index_nxt <= r_Bit_Index_reg + 1;
	         else
			r_Bit_Index_nxt <= r_Bit_Index_reg;
	         end if;
            else
               r_nxt_state   <= s_TX_Stop_Bit;
            end if;
 
       
        when s_TX_Stop_Bit =>
          o_TX_Serial <= '1';
			 o_TX_Active <= '1';
			 r_TX_Data_nxt <= (others => '0');
			 r_Bit_Index_nxt <= 0;
			 
          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_nxt_state   <= s_TX_Stop_Bit;
				r_TX_Done   <= '0';
          else
            r_TX_Done   <= '1';
            r_nxt_state   <= s_Cleanup;
			end if;
         
       
        when s_Cleanup =>
          o_TX_Active <= '0';
          r_TX_Done   <= '1';
          r_nxt_state   <= s_Idle;
			 o_TX_Serial <= '1';
			 r_Bit_Index_nxt <= 0;
			 r_TX_Data_nxt <= (others => '0');
		  
		  when others =>
          o_TX_Active <= '0';
          r_TX_Done   <= '0';
          r_nxt_state   <= s_Idle;
			 o_TX_Serial <= '1';
			 r_Bit_Index_nxt <= 0;
			 r_TX_Data_nxt <= (others => '0');
 
      end case;
  end process p_UART_TX;
 
  o_TX_Done <= r_TX_Done;
   
end RTL;
