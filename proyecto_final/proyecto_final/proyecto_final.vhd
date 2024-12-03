library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity proyecto_final is
    port(
        reloj : in STD_LOGIC;
        rst : in STD_LOGIC;
		  --Modulo Bluetooth
        RX_WIRE : in STD_LOGIC;
		  --Leds
--        ledR : out STD_LOGIC;
        ledG : out STD_LOGIC;
        ledB : out STD_LOGIC;
		  --Servomotor
		  Pini : BUFFER  STD_LOGIC;
		  Pfin : BUFFER  STD_LOGIC;   		  
	     control : out  STD_LOGIC;
		  --SensorDescarga
		  eco : IN STD_LOGIC;
        dispa : OUT STD_LOGIC;
        descarga : IN STD_LOGIC;
		  --SensoresObstaculo
		  eco1: IN STD_LOGIC;
        dispa1: OUT STD_LOGIC;
        obstaculo1 : IN STD_LOGIC;
		  
		  eco2 : IN STD_LOGIC;
        dispa2 : OUT STD_LOGIC;
        obstaculo2 : IN STD_LOGIC;
		  --Motores
		 
        in1Motor1 : out std_logic; -- Entrada 1 del puente H
        in2Motor1 : out std_logic;  -- Entrada 2 del puente H
	
        in1Motor2 : out std_logic; -- Entrada 1 del puente H
        in2Motor2 : out std_logic;  -- Entrada 2 del puente H
		
        in1Motor3 : out std_logic; -- Entrada 1 del puente H
        in2Motor3 : out std_logic  -- Entrada 2 del puente H
        );
end proyecto_final;

architecture behavioral of proyecto_final is
	 
    constant avanzar : STD_LOGIC_VECTOR(7 downto 0) := x"31"; --(Enciende el modulo 1: Motor a pasos)
    constant retroceder : STD_LOGIC_VECTOR(7 downto 0) := x"32";   -- (Cambio de direccion del motor a pasos)
	 
	 
	 signal reloj_serv : STD_LOGIC;    
	 signal ancho : STD_LOGIC_VECTOR (7 downto 0) := X"0F"; 
	 signal posicion : integer range 0 to 180 := 0; -- Posición del servomotor en grados
	 
	 signal descarga_int: STD_LOGIC;
	 signal obstaculo1_int: STD_LOGIC;
	 signal obstaculo2_int: STD_LOGIC;
	 
	 
    component RX is
        port(
            reloj : in STD_LOGIC;
            rst : in STD_LOGIC;
            RX_WIRE : in STD_LOGIC;
            dato_out : out STD_LOGIC_VECTOR(7 downto 0);
            dato_valid : out STD_LOGIC
        );
    end component;
	 
	 
	 component SensorDescarga is
		port(
		 clk : IN STD_LOGIC;
		 eco : IN STD_LOGIC;
		 dispa : OUT STD_LOGIC;
		 descarga : OUT STD_LOGIC
		);
	 end component;
	 
    component SensorObstaculo is
		port(
		 clk : IN STD_LOGIC;
		 eco : IN STD_LOGIC;
		 dispa : OUT STD_LOGIC;
		 obstaculo : OUT STD_LOGIC
	  );
	 end component;
  
	 
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
   
    
    signal dato_out : STD_LOGIC_VECTOR(7 downto 0);
    signal dato_valid : STD_LOGIC;
   

begin
   U_RX: RX
        port map (
            reloj => reloj,
            rst => rst,
            RX_WIRE => RX_WIRE,
            dato_out => dato_out,
            dato_valid => dato_valid
        );

 
	U_SensorDesgarga: SensorDescarga
				  port map (
						clk => reloj,
					   eco => eco,
					   dispa => dispa,
					   descarga => descarga_int
				  );
				  
	U_SensorObstaculo: SensorObstaculo
				  port map (
						clk => reloj,
					   eco => eco1,
					   dispa => dispa1,
					   obstaculo => obstaculo1_int
				  );
				  
	U_SensorObstaculo2: SensorObstaculo
				  port map (
						clk => reloj,
					   eco => eco2,
					   dispa => dispa2,
					   obstaculo => obstaculo2_int
				  );
	U1: divisor port map (reloj, reloj_serv);   
	U2: PWM port map (reloj_serv, ancho, control);  

	
				  

    -- Proceso de control del motor, LED RGB y letrero
process(reloj, rst)
begin
    if rst = '1' then
        -- Al inicio, activar un módulo por defecto (el motor)
        in1Motor1  <= '0';
		  in2Motor1  <= '0';
		  in1Motor2  <= '0';
		  in2Motor2  <= '0';
		  in1Motor3  <= '0';
		  in2Motor3  <= '0';
		  Pini<= '1';
--		  ledR <= '0';
		  ledG <= '0';
		  ledB <= '0';
		  
    elsif rising_edge(reloj) then
        if dato_valid = '1' then
            case dato_out is
                when avanzar =>
							if descarga_int = '0' then
								if obstaculo1_int = '0' then
									ledG <= '1';
									in1Motor1  <= '0';
									in2Motor1  <= '1';
									in1Motor2  <= '0';
									in2Motor2  <= '1';
									in1Motor3  <= '0';
									in2Motor3  <= '1';
								 end if;
							 else
								in1Motor1  <= '0';
								in2Motor1  <= '0';
								in1Motor2  <= '0';
								in2Motor2  <= '0';
								in1Motor3  <= '0';
								in2Motor3  <= '0';
								Pfin <= '1';
								ledB <= '1';
							end if;
							
					 when retroceder =>
							if descarga_int = '0' then
								if obstaculo2_int = '0' then
									ledB <= '0';
									in1Motor1  <= '1';
									in2Motor1  <= '0';
									in1Motor2  <= '1';
									in2Motor2  <= '0';
									in1Motor3  <= '1';
									in2Motor3  <= '0';
								 end if;
							 else
								in1Motor1  <= '0';
								in2Motor1  <= '0';
								in1Motor2  <= '0';
								in2Motor2  <= '0';
								in1Motor3  <= '0';
								in2Motor3  <= '0';
								Pfin <= '1';
--								ledB <= '1';
							end if;
                when others =>
                    -- Si no se recibe un comando válido, mantener el estado actual
                    null;
            end case;
       
        end if;
    end if;
	end process;


	


	  
	process (reloj_serv, Pini, Pfin)      
    variable valor : STD_LOGIC_VECTOR (7 downto 0) := X"0F";      
    variable cuenta : integer range 0 to 1023 := 0;    
	begin       
		 if reloj_serv='1' and reloj_serv'event then          
			  if cuenta>0 then             
					cuenta := cuenta -1;          
			  else             
					if Pini='1' then                
						 valor := X"07"; 
						   
					elsif Pfin='1' then                
						 valor := X"1F";  
					end if;             
					cuenta := 1023;             
					ancho <= valor;         
			  end if;       
		 end if;    
	end process;




end behavioral;