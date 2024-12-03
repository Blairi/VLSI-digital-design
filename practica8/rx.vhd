library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity RX is
port( reloj : IN STD_LOGIC;
LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
RX_WIRE : IN STD_LOGIC);
end entity;
architecture behaivoral OF RX IS
signal BUFF: STD_LOGIC_VECTOR(9 downto 0);
signal Flag: STD_LOGIC := '0';
signal PRE: INTEGER RANGE 0 TO 5208 := 0;
signal INDICE: INTEGER RANGE 0 TO 9 := 0;
signal PRE_val: INTEGER range 0 to 41600;
signal baud: STD_LOGIC_VECTOR(2 downto 0);
begin
RX_dato : process(reloj)
begin
if (reloj'EVENT and reloj = '1') then
if (Flag = '0' and RX_WIRE = '0') then
Flag<= '1';
INDICE <= 0;
PRE <= 0;
end if;
if (Flag = '1') then
BUFF(INDICE)<=RX_WIRE;
if(PRE < PRE_val) then
PRE <= PRE + 1;
else
PRE <= 0;
end if;
if(PRE = PRE_val/2) then
if(INDICE < 9) then
INDICE <= INDICE + 1;
else
if(BUFF(0) = '0' and BUFF(9)= '1') then
LEDS <= BUFF(8 DOWNTO 1);
else
LEDS <= "00000000";
end if;
Flag <= '0';
end if;
end if;
end if;
end if;
end process RX_dato;
baud<="011";
with (baud) select
PRE_val <= 41600 when "000", -- 1200 bauds
20800 when "001", -- 2400 bauds
10400 when "010", -- 4800 bauds
5200 when "011", -- 9600 bauds
2600 when "100", -- 19200 bauds
1300 when "101", -- 38400 bauds
866 when "110", -- 57600 bauds
432 when others; --115200 bauds
end architecture behaivoral;

--variable asc_dato : arreglo := (X"41", X"58", X"45" ,X"4C", X"20", X"4D",X"4F",X"4E",X"54");