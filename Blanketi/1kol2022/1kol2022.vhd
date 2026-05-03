--OR
LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.ALL;
  USE IEEE.NUMERIC_STD.ALL;

ENTITY orGate IS
	PORT(
    	 a, b: IN STD_LOGIC;
         y: OUT STD_LOGIC
         );
END ENTITY orGate;

ARCHITECTURE a_orGate OF orGate IS
BEGIN
	y <= a OR b;
END ARCHITECTURE a_orGate;

--XOR
LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.ALL;
  USE IEEE.NUMERIC_STD.ALL;
  
ENTITY xorGate IS
	PORT(
    	 a, b: IN STD_LOGIC;
         y: OUT STD_LOGIC
         );
END ENTITY xorGate;

ARCHITECTURE a_xorGate OF xorGate IS
BEGIN
	y <= a XOR b;
END ARCHITECTURE a_xorGate;

--kolo
LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.ALL;
  USE IEEE.NUMERIC_STD.ALL;
  
ENTITY kolo IS
	GENERIC(n : INTEGER := 4);
    PORT(
    	 a, b: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         c: IN STD_LOGIC;
         d: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
         );
END ENTITY kolo;

ARCHITECTURE a_kolo OF kolo IS
BEGIN
	
    generisi: FOR i IN 0 TO n-1 GENERATE
    	SIGNAL medju: STD_LOGIC;
    BEGIN
    	uslovi: IF i = 0 GENERATE
        BEGIN
        	nultiXor: ENTITY work.xorGate(a_xorGate)
            		  PORT MAP(a(i), b(i), medju);
            nultiOr: ENTITY work.orGate(a_orGate)
            		 PORT MAP(medju, c, d(i));
        ELSE GENERATE
        	itiXor: ENTITY work.xorGate(a_xorGate)
            		PORT MAP(a(i), b(i), medju);
            itiOr: ENTITY work.orGate(a_orGate)
            	   PORT MAP(medju, d(i-1), d(i));
    	END GENERATE uslovi;
	END GENERATE generisi;
END ARCHITECTURE a_kolo;

--testbench
LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.ALL;
  USE IEEE.NUMERIC_STD.ALL;
  
ENTITY tb IS
	GENERIC(n : INTEGER := 4);
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL a, b, d: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL c: STD_LOGIC;
BEGIN
	
    dut: ENTITY work.kolo(a_kolo)
    	 PORT MAP(a, b, c, d);
         
	stimuli: PROCESS
    BEGIN
    	a <= "0110";
        b <= "1001";
        c <= '1';
        WAIT FOR 50ns;
    END PROCESS stimuli;
END ARCHITECTURE sim;
