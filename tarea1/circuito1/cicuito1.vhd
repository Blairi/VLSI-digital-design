-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
-- CREATED		"Mon Sep 09 12:57:41 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY cicuito1 IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		pin_name1 :  IN  STD_LOGIC;
		pin_name2 :  OUT  STD_LOGIC
	);
END cicuito1;

ARCHITECTURE bdf_type OF cicuito1 IS 

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	DFF_inst7 :  STD_LOGIC;
SIGNAL	DFF_inst8 :  STD_LOGIC;
SIGNAL	DFF_inst9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	DFF_inst2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;


BEGIN 
pin_name2 <= SYNTHESIZED_WIRE_14;



PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	SYNTHESIZED_WIRE_12 <= SYNTHESIZED_WIRE_0;
END IF;
END PROCESS;


PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	SYNTHESIZED_WIRE_16 <= SYNTHESIZED_WIRE_12;
END IF;
END PROCESS;


SYNTHESIZED_WIRE_15 <= NOT(DFF_inst7);



SYNTHESIZED_WIRE_13 <= NOT(DFF_inst8);



SYNTHESIZED_WIRE_14 <= NOT(DFF_inst9);



SYNTHESIZED_WIRE_6 <= NOT(pin_name1 OR SYNTHESIZED_WIRE_13 OR SYNTHESIZED_WIRE_14 OR SYNTHESIZED_WIRE_15);


PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	DFF_inst2 <= SYNTHESIZED_WIRE_4;
END IF;
END PROCESS;


SYNTHESIZED_WIRE_0 <= NOT(SYNTHESIZED_WIRE_16 AND DFF_inst2);


SYNTHESIZED_WIRE_5 <= NOT(SYNTHESIZED_WIRE_16);



SYNTHESIZED_WIRE_4 <= NOT(SYNTHESIZED_WIRE_5 AND SYNTHESIZED_WIRE_6);


PROCESS(SYNTHESIZED_WIRE_12)
BEGIN
IF (RISING_EDGE(SYNTHESIZED_WIRE_12)) THEN
	DFF_inst7 <= SYNTHESIZED_WIRE_15;
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_15)
BEGIN
IF (RISING_EDGE(SYNTHESIZED_WIRE_15)) THEN
	DFF_inst8 <= SYNTHESIZED_WIRE_13;
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_13)
BEGIN
IF (RISING_EDGE(SYNTHESIZED_WIRE_13)) THEN
	DFF_inst9 <= SYNTHESIZED_WIRE_14;
END IF;
END PROCESS;


END bdf_type;