library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity servomotor is     
Port ( reloj_sv : in  STD_LOGIC;            
	Pini : out  STD_LOGIC;
	Pfin : out  STD_LOGIC;            
	Inc : in  STD_LOGIC;
	Dec : in  STD_LOGIC;            
	control : out  STD_LOGIC;
	); 
end Servomotor;

architecture Behavioral of Servomotor is

-- Declaración del componente divisor
component divisor is
Port ( reloj : in std_logic;
	div_reloj : out std_logic);    
end component;

-- Declaración del componente PWM
component PWM is       
Port ( reloj_pwm : in  STD_LOGIC;                  
	D : in  STD_LOGIC_VECTOR (7 downto 0);                 
	S : out  STD_LOGIC);    
end component;

-- Declaración del componente decodificador de 7 segmentos
component decodificador_7segmentos is
    Port (
        numero : in  STD_LOGIC_VECTOR (3 downto 0); -- Número a decodificar
        segmentos : out  STD_LOGIC_VECTOR (6 downto 0)  -- Segmentos del display
    );
end component;

signal reloj_serv : STD_LOGIC;    
signal ancho : STD_LOGIC_VECTOR (7 downto 0) := X"0F"; 
signal posicion : integer range 0 to 180 := 0; -- Posición del servomotor en grados
signal centenas, decenas, unidades : STD_LOGIC_VECTOR (3 downto 0); -- Valores para los displays
	
begin    
	U1: divisor port map (reloj_sv, reloj_serv);   
	U2: PWM port map (reloj_serv, ancho, control);    

   
    U3: decodificador_7segmentos port map (centenas, display1);
    U4: decodificador_7segmentos port map (decenas, display2);
    U5: decodificador_7segmentos port map (unidades, display3);
	
process (reloj_serv, Pini, Pfin, Inc, Dec)      
    variable valor : STD_LOGIC_VECTOR (7 downto 0) := X"0F";      
    variable cuenta : integer range 0 to 1023 := 0;    
begin       
    if reloj_serv='1' and reloj_serv'event then          
        if cuenta>0 then             
            cuenta := cuenta -1;          
        else             
            if Pini='1' then                
                valor := X"07"; 
                posicion <= 0;  
            elsif Pfin='1' then                
                valor := X"1F"; 
                posicion <= 180; 
            elsif Inc='0' and valor<X"1F" then                
                valor := valor + 4; -- Incrementar 4 ciclos por posición
                posicion <= posicion + 30; 
            elsif Dec='0' and valor>X"07" then                
                valor := valor - 4; -- Decrementar 4 ciclos por posición
                posicion <= posicion - 30; 
            end if;             
            cuenta := 1023;             
            ancho <= valor;         
        end if;       
    end if;    
end process;


process(posicion)
begin
    centenas <= conv_std_logic_vector(posicion / 100, 4); -- Centenas
    decenas <= conv_std_logic_vector((posicion / 10) mod 10, 4); -- Decenas
    unidades <= conv_std_logic_vector(posicion mod 10, 4); -- Unidades
end process;

end Behavioral;

