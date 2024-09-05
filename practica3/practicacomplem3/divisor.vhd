library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor is Generic ( N : integer := 24);
	Port ( reloj : in std_logic;
		div_reloj : out std_logic);
end Divisor;

architecture Behavioral of divisor is
begin

	process (reloj)
	
		variable cuenta: std_logic_vector (27 downto 0) := X"0000000";
		
		begin
		
			if rising_edge (reloj) then
				cuenta := cuenta + 1;
			end if;
			
			div_reloj <= cuenta (N);
			
		end process;
		
end Behavioral;