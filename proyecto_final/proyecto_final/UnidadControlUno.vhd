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
        ledR : out STD_LOGIC;
        ledG : out STD_LOGIC;
        ledB : out STD_LOGIC;
		  --Servomotor
		  Pini : in  STD_LOGIC;
		  Pfin : in  STD_LOGIC;   		  
	     control : out  STD_LOGIC;
		  --SensorDescarga
		  eco : IN STD_LOGIC;
        dispa : OUT STD_LOGIC;
        descarga : OUT STD_LOGIC;
		  --SensoresObstaculo
		  eco1: IN STD_LOGIC;
        dispa1: OUT STD_LOGIC;
        obstaculo1 : OUT STD_LOGIC;
		  
		  eco2 : IN STD_LOGIC;
        dispa2 : OUT STD_LOGIC;
        obstaculo2 : OUT STD_LOGIC;
		  --Motores
		  sw1Motor1 : in std_logic;  -- Switch 1 para controlar la polaridad
        sw2Motor1 : in std_logic;  -- Switch 2 para controlar la polaridad
        in1Motor1 : out std_logic; -- Entrada 1 del puente H
        in2Motor1 : out std_logic  -- Entrada 2 del puente H
		  sw1Motor2 : in std_logic;  -- Switch 1 para controlar la polaridad
        sw2Motor2 : in std_logic;  -- Switch 2 para controlar la polaridad
        in1Motor2 : out std_logic; -- Entrada 1 del puente H
        in2Motor2 : out std_logic  -- Entrada 2 del puente H
		  sw1Motor3 : in std_logic;  -- Switch 1 para controlar la polaridad
        sw2Motor3 : in std_logic;  -- Switch 2 para controlar la polaridad
        in1Motor3 : out std_logic; -- Entrada 1 del puente H
        in2Motor3 : out std_logic  -- Entrada 2 del puente H
		  sw1Motor3 : in std_logic;  -- Switch 1 para controlar la polaridad
        sw2Motor3 : in std_logic;  -- Switch 2 para controlar la polaridad
        in1Motor3 : out std_logic; -- Entrada 1 del puente H
        in2Motor3 : out std_logic  -- Entrada 2 del puente H
    );
end proyecto_final;

architecture behavioral of proyecto_final is
	 
    constant avanzar : STD_LOGIC_VECTOR(7 downto 0) := x"31"; --(Enciende el modulo 1: Motor a pasos)
    constant retroceder : STD_LOGIC_VECTOR(7 downto 0) := x"32";   -- (Cambio de direccion del motor a pasos)
	 
	 
    component RX is
        port(
            reloj : in STD_LOGIC;
            rst : in STD_LOGIC;
            RX_WIRE : in STD_LOGIC;
            dato_out : out STD_LOGIC_VECTOR(7 downto 0);
            dato_valid : out STD_LOGIC
        );
    end component;
	 
	 component puente_h is
		port(
        sw1 : in std_logic;  -- Switch 1 para controlar la polaridad
        sw2 : in std_logic;  -- Switch 2 para controlar la polaridad
        in1 : out std_logic; -- Entrada 1 del puente H
        in2 : out std_logic  -- Entrada 2 del puente H
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
  
    component servomotor is
		port( reloj_sv : in  STD_LOGIC;            
		 Pini : in  STD_LOGIC;
       Pfin : in  STD_LOGIC;                       
	    control : out  STD_LOGIC
		); 
	 end component;
   
    
    signal dato_out : STD_LOGIC_VECTOR(7 downto 0);
    signal dato_valid : STD_LOGIC;
    signal motorDireccion : STD_LOGIC;
	 signal parar : STD_LOGIC;
    signal MotorActivo : STD_LOGIC;
    signal LedActivo: STD_LOGIC;
    signal LetreroActivo : STD_LOGIC;

begin
   U_RX: RX
        port map (
            reloj => reloj,
            rst => rst,
            RX_WIRE => RX_WIRE,
            dato_out => dato_out,
            dato_valid => dato_valid
        );

	U_MotorTrasero: puente_h
				  port map (
						sw1 => sw1Motor1,
						sw2 => sw2Motor1,
						in1 => in1Motor1,
						in2 => in2Motor1
				  );
	
	U_MotorDelanteroMas: puente_h
				  port map (
						sw1 => sw1Motor2,
						sw2 => sw2Motor2,
						in1 => in1Motor2,
						in2 => in2Motor2
				  );
	
	U_MotorDelanteroMenos: puente_h
				  port map (
						sw1 => sw1Motor3,
						sw2 => sw2Motor3,
						in1 => in1Motor3,
						in2 => in2Motor3
				  );
 
	U_SensorDesgarga: SensorDescarga
				  port map (
						clk => reloj,
					   eco => eco,
					   dispa => dispa,
					   descarga => descarga
				  );
				  
	U_SensorObstaculo: SensorObstaculo
				  port map (
						clk => reloj,
					   eco1 => eco,
					   dispa1 => dispa,
					   obstaculo1 => obstaculo1
				  );
				  
	U_SensorObstaculo2: SensorObstaculo
				  port map (
						clk => reloj,
					   eco2 => eco,
					   dispa2 => dispa,
					   obstaculo2 => obstaculo2
				  );
				  
	

    -- Proceso de control del motor, LED RGB y letrero
process(reloj, rst)
begin
    if rst = '1' then
        -- Al inicio, activar un módulo por defecto (el motor)
        sw1Motor1 <= '0';
		  sw2Motor1 <= '0';
		  sw1Motor2 <= '0';
		  sw2Motor2 <= '0';
		  sw1Motor3 <= '0';
		  sw2Motor3 <= '0';
		  Pini <= '1';
		  ledR <= '0';
		  ledG <= '0';
		  ledB <= '0';
    elsif rising_edge(reloj) then
        if dato_valid = '1' then
            case dato_out is
                when avanzar =>
							if descarga = '0' then
								if obstaculo1 = '0' then
									ledG <= '1';
									sw1Motor1 <= '1';
									sw2Motor1 <= '0';
									sw1Motor2 <= '1';
									sw2Motor2 <= '0';
									sw1Motor3 <= '1';
									sw2Motor3 <= '0';
								 end if;
							 else
								sw1Motor1 <= '0';
							   sw2Motor1 <= '0';
							   sw1Motor2 <= '0';
							   sw2Motor2 <= '0';
							   sw1Motor3 <= '0';
							   sw2Motor3 <= '0';
								Pfin <= '1';
								ledB <= '1';
							end if;
							
					 when retroceder =>
							if descarga = '0' then
								if obstaculo2 = '0' then
									ledR <= '1';
									sw1Motor1 <= '0';
									sw2Motor1 <= '1';
									sw1Motor2 <= '0';
									sw2Motor2 <= '1';
									sw1Motor3 <= '0';
									sw2Motor3 <= '1';
								 end if;
							 else
								sw1Motor1 <= '0';
							   sw2Motor1 <= '0';
							   sw1Motor2 <= '0';
							   sw2Motor2 <= '0';
							   sw1Motor3 <= '0';
							   sw2Motor3 <= '0';
								Pfin <= '1';
								ledB <= '1';
							end if;
                when others =>
                    -- Si no se recibe un comando válido, mantener el estado actual
                    null;
            end case;
       
        end if;
    end if;
end process;


end behavioral;