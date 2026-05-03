--dff
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
    
ENTITY dff IS
	PORT(
    	 d, clk, rst: IN STD_LOGIC;
         q: OUT STD_LOGIC
         );
END ENTITY dff;

ARCHITECTURE a_dff OF dff IS
BEGIN
	PROCESS(clk, rst)
    BEGIN
    	IF rst = '1' THEN
        	q <= '0';
        ELSIF clk'EVENT AND clk = '1' THEN
        	q <= d;
        END IF;
    END PROCESS;
END ARCHITECTURE a_dff;

--reg
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg IS
	GENERIC(n : INTEGER := 8);
    PORT(
    	 clk, rst: IN STD_LOGIC;
         din: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         q: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
         );
END ENTITY reg;

ARCHITECTURE a_reg OF reg IS
BEGIN
	generisi: FOR i IN 0 TO n-1 GENERATE
    	itidff: ENTITY work.dff(a_dff)
        		PORT MAP(
                		 clk => clk,
                         rst => rst,
                         d => din(i),
                         q => q(i)
                         );
	END GENERATE generisi;
END ARCHITECTURE a_reg;

--detektor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY detektor IS
	GENERIC(n : INTEGER := 5);
    PORT(
    	 clk, rst: IN STD_LOGIC;
         A: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         CHANGED: OUT STD_LOGIC
         );
END ENTITY detektor;

ARCHITECTURE a_detektor OF detektor IS
	SIGNAL prev_A: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
	instanca_reg: ENTITY work.reg(a_reg)
    			  GENERIC MAP(n)
                  PORT MAP(
                  		   clk => clk,
                           rst => rst,
                           din => A,
                           q => prev_A
                           );
	PROCESS(A, prev_A)
    BEGIN
    	IF A /= prev_A THEN
        	CHANGED <= '1';
        ELSE
        	CHANGED <= '0';
        END IF;
    END PROCESS;
END ARCHITECTURE a_detektor;

--testbench
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb IS
	GENERIC(n : INTEGER := 5);
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL clk, rst: STD_LOGIC;
    SIGNAL A: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL CHANGED: STD_LOGIC;
BEGIN
	uut: ENTITY work.detektor(a_detektor)
    	 GENERIC MAP(n)
         PORT MAP(clk, rst, A, CHANGED);
    
    klok: PROCESS
    BEGIN
    	clk <= '0';
        WAIT FOR 30ns;
        clk <= '1';
        WAIT FOR 30ns;
    END PROCESS klok;
    
    stimuli: PROCESS
    BEGIN
    	rst <= '1';
        WAIT FOR 60ns;
        rst <= '0';
        A <= "00001";
        WAIT FOR 120ns;
        A <= "00001";
        WAIT FOR 120ns;
        A <= "00011";
        WAIT FOR 120ns;
        A <= "00011";
        WAIT FOR 120ns;
        A <= "11111";
        WAIT FOR 120ns;
	END PROCESS stimuli;
END ARCHITECTURE sim;
