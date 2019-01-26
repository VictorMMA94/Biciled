Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use IEEE.std_logic_arith.all;
---------------------------------------------------------------------------------------------------------
ENTITY CONTROLADORA_MSS IS
PORT(	START: 					In std_logic;
		LEFT_BUTTON: 			In std_logic;
		RIGHT_BUTTON: 			In std_logic;
		MOSTRAR_BUTTON:		In std_logic;
		FIN_SECUENCIA:			In std_logic;
		RESET: 					In std_logic;
		CLOCK_MSS: 				In std_logic;
		LOAD_REG: 				Out std_logic;
		RESET_REG: 				Out std_logic;
		S1: 						Out std_logic;
		S0:						Out std_logic;
		RESET_1:					Out std_logic;
		EN_TIME:					Out std_logic;
		RESET_TIME:				Out std_logic;
		RESET_FF:				Out std_logic;
		PRENDE:					Out std_logic);
END CONTROLADORA_MSS; 
---------------------------------------------------------------------------------------------------------
ARCHITECTURE estructural OF CONTROLADORA_MSS IS
-------------------------------------------------------------------------------------------------------------
TYPE ESTADO IS (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12);
SIGNAL Y: ESTADO;
BEGIN
	MSS_TRANSICIONES: PROCESS(RESET, CLOCK_MSS)
	BEGIN
		IF RESET='1' THEN Y <= T0;
		ELSIF (CLOCK_MSS'EVENT AND CLOCK_MSS='1') THEN
			CASE Y IS
				WHEN T0 => IF START='0' THEN Y<=T0; ELSE Y<=T1; END IF;
				WHEN T1 => IF START='1' THEN Y<=T1; ELSE Y<=T2; END IF;
				WHEN T2 => Y<=T3;
				WHEN T3 => IF RIGHT_BUTTON='1' THEN Y<=T4;
							  ELSIF LEFT_BUTTON='1' THEN Y<=T7;
							  ELSE Y<=T3; END IF;
				WHEN T4 => IF RIGHT_BUTTON='0' THEN Y<=T5;
							  ELSIF LEFT_BUTTON='1' THEN Y<=T9;
							  ELSE Y<=T4; END IF;
				WHEN T5 => IF MOSTRAR_BUTTON='1' THEN Y<=T6;
							  ELSIF FIN_SECUENCIA='1' THEN Y<=T12;
							  ELSE Y<=T5; END IF;
				WHEN T6 => IF MOSTRAR_BUTTON='0' THEN Y<=T5;
							  ELSE Y<=T6; END IF;
				WHEN T7 => IF LEFT_BUTTON='0' THEN Y<=T8;
							  ELSIF RIGHT_BUTTON='1' THEN Y<=T9;
							  ELSE Y<=T7; END IF;
				WHEN T8 => IF MOSTRAR_BUTTON='1' THEN Y<=T11; 
							  ELSIF FIN_SECUENCIA='1' THEN Y<=T12;
							  ELSE Y<=T8; END IF;
				WHEN T9 => IF MOSTRAR_BUTTON='1' THEN Y<=T10;
							  ELSIF FIN_SECUENCIA='1' THEN Y<=T12;
							  ELSE Y<=T9; END IF;
				WHEN T10 => IF MOSTRAR_BUTTON='0' THEN Y<=T9; 
								ELSE Y<=T10; END IF;
				WHEN T11 => IF MOSTRAR_BUTTON='0' THEN Y<=T8; 
								ELSE Y<=T11; END IF;
				WHEN T12 => Y<=T3;
			END CASE;
		END IF;
	END PROCESS;
	
	MSS_SALIDAS: PROCESS(Y, START, LEFT_BUTTON, RIGHT_BUTTON, MOSTRAR_BUTTON, FIN_SECUENCIA)
	BEGIN
		LOAD_REG<='0'; RESET_REG<='0'; S1<='0'; S0<='0'; RESET_1<='0'; EN_TIME<='0'; RESET_TIME<='0'; RESET_FF<='0'; PRENDE<='0';
		
		CASE Y IS
			WHEN T0 =>  RESET_REG<='1'; RESET_1<='1'; RESET_TIME<='1'; RESET_FF<='1';
			WHEN T1 =>  RESET_REG<='1'; RESET_1<='1'; RESET_TIME<='1'; RESET_FF<='1';
			WHEN T2 =>  LOAD_REG<='1';
			WHEN T3 =>  
			WHEN T4 =>  IF RIGHT_BUTTON='0' THEN S0<='1'; LOAD_REG<='1'; EN_TIME<='1';
							ELSIF LEFT_BUTTON='1' THEN S1<='1'; S0<='1'; LOAD_REG<='1'; EN_TIME<='1'; END IF;
			WHEN T5 =>  S0<='1'; EN_TIME<='1';
			WHEN T6 =>  S0<='1'; EN_TIME<='1';
							IF MOSTRAR_BUTTON='0' THEN PRENDE<='1'; END IF;
			WHEN T7 =>  IF LEFT_BUTTON='0' THEN S1<='1'; LOAD_REG<='1'; EN_TIME<='1';
							ELSIF RIGHT_BUTTON='1' THEN S1<='1'; S0<='1'; LOAD_REG<='1'; EN_TIME<='1'; END IF;
			WHEN T8 =>  S1<='1'; EN_TIME<='1';
			WHEN T9 =>  S1<='1'; S0<='1'; EN_TIME<='1';
			WHEN T10 =>  S1<='1'; S0<='1'; EN_TIME<='1';
							 IF MOSTRAR_BUTTON='0' THEN PRENDE<='1'; END IF;
			WHEN T11 =>  S1<='1'; EN_TIME<='1';
							 IF MOSTRAR_BUTTON='0' THEN PRENDE<='1'; END IF;
			WHEN T12 =>  RESET_TIME<='1';
		END CASE;
	END PROCESS;	
END estructural;


	