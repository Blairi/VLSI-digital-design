Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;
entity M7219 is
Port( clk : in std_logic;
clk_out : out std_logic;
data_out : out std_logic;
load : out std_logic);
end entity;
architecture behavioral of M7219 is

signal parallel : std_logic_vector(31 downto 0):=X"08234156";

attribute sync_encoding: string;
Type state_machine is (init_1, init_2, init_3, init_4, read_data, dig_7,
dig_6, dig_5, dig_4, dig_3, dig_2, dig_1, dig_0);
attribute sync_encoding of state_machine: type is "safe";
signal state : state_machine := init_1;
Type driver_machine is (idle, start, clk_data, clk_high, clk_low,
finished);
attribute sync_encoding of driver_machine : type is "safe";
signal driver_state : driver_machine := idle;
signal command : std_logic_vector(15 downto 0) := X"0000";
signal driver_start : std_logic := '0';
---Decoder 4x16 for the 7-segment display----
function hex2seg(num:std_logic_vector(3 downto 0)) return
std_logic_vector is
begin
case num is
when "0000" => return("10101010"); -- 0
when "0001" => return("10101010"); -- 1
when "0010" => return("10101010"); -- 2
when "0011" => return("10101010"); -- 3
when "0100" => return("10101010"); -- 4
when "0101" => return("10101010"); -- 5
when "0110" => return("10101010"); -- 6
when "0111" => return("10101010"); -- 7
when "1000" => return("10101010"); -- 8
when "1001" => return("10101010"); -- 9
when "1010" => return("10101010"); -- A
when "1011" => return("10101010"); -- b
when "1100" => return("10101010"); -- c
when "1101" => return("10101010"); -- d
when "1110" => return("10101010"); -- E
when "1111" => return("10101010"); -- F
when others => return("10101010");
end case;

end hex2seg;
begin
process
variable counter : integer := 0;
variable clk_counter : integer := 0;
variable latch_in : std_logic_vector(31 downto 0) := x"00000000";
variable dig0_data : std_logic_vector(7 downto 0) := x"00";
variable dig1_data : std_logic_vector(7 downto 0) := x"00";
variable dig2_data : std_logic_vector(7 downto 0) := x"00";
variable dig3_data : std_logic_vector(7 downto 0) := x"00";
variable dig4_data : std_logic_vector(7 downto 0) := x"00";
variable dig5_data : std_logic_vector(7 downto 0) := x"00";
variable dig6_data : std_logic_vector(7 downto 0) := x"00";
variable dig7_data : std_logic_vector(7 downto 0) := x"00";
begin
wait until rising_edge(clk); --- FPGA clk = 50 MHz
case state is
when init_1 =>
if (driver_state = idle) then
command <= x"0c01"; -- shutdown / normal operation

driver_state <= start;
state <= init_2;

end if;
when init_2 =>
if (driver_state = idle) then
command <= x"0900"; -- decode mode

driver_state <= start;
state <= init_3;

end if;
when init_3 =>
if (driver_state = idle) then
command <= x"0A00"; -- intensity

driver_state <= start;
state <= init_4;

end if;
when init_4 =>
if (driver_state = idle) then
command <= x"0B07"; -- scan limit

driver_state <= start;
state <= read_data;

end if;
when read_data =>
latch_in := parallel;

dig7_data := hex2seg(latch_in(31 downto 28));
dig6_data := hex2seg(latch_in(27 downto 24));
dig5_data := hex2seg(latch_in(23 downto 20));
dig4_data := hex2seg(latch_in(19 downto 16));
dig3_data := hex2seg(latch_in(15 downto 12));
dig2_data := hex2seg(latch_in(11 downto 8));
dig1_data := hex2seg(latch_in(7 downto 4));
dig0_data := hex2seg(latch_in(3 downto 0));
state <= dig_7;
when dig_7 =>
if (driver_state = idle) then
command <= x"08" & dig7_data;

driver_state <= start;
state <= dig_6;

end if;
when dig_6 =>
if (driver_state = idle) then
command <= x"07" & dig6_data;
driver_state <= start;
state <= dig_5;
end if;
when dig_5 =>
if (driver_state = idle) then
command <= x"06" & dig5_data;
driver_state <= start;
state <= dig_4;
end if;
when dig_4 =>
if (driver_state = idle) then
command <= x"05" & dig4_data;
driver_state <= start;
state <= dig_3;
end if;
when dig_3 =>
if (driver_state = idle) then
command <= x"04" & dig3_data;
driver_state <= start;
state <= dig_2;
end if;
when dig_2 =>
if (driver_state = idle) then
command <= x"03" & dig2_data;
driver_state <= start;
state <= dig_1;
end if;
when dig_1 =>
if (driver_state = idle) then
command <= x"02" & dig1_data;
driver_state <= start;
state <= dig_0;
end if;
when dig_0 =>
if (driver_state = idle) then
command <= x"01" & dig0_data;
driver_state <= start;
state <= read_data;
end if;
when others => null;
end case;
if (clk_counter < 100) then
clk_counter := clk_counter + 1;
else
clk_counter := 0;
case driver_state is
when idle =>
load <= '1';
clk_out <= '0';
when start =>

load <= '0';
counter := 16;
driver_state <= clk_data;
when clk_data =>
counter := counter - 1;
data_out <= command(counter);
driver_state <= clk_high;
when clk_high =>
clk_out <= '1';
driver_state <= clk_low;
when clk_low =>
clk_out <= '0';
if (counter = 0) then
load <= '1';
driver_state <= finished;
else
driver_state <= clk_data;
end if;
when finished =>
driver_state <= idle;
when others => null;
end case;
end if;
end process;
end architecture;