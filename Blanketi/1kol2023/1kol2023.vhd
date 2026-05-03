--bcd brojac
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY bcd IS
	PORT(
    	 clk, we: IN STD_LOGIC;
         d_in: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         y: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
END ENTITY bcd;

ARCHITECTURE a_bcd OF bcd IS
BEGIN
	PROCESS(clk)
    	VARIABLE counter: INTEGER RANGE 0 TO 9;
    BEGIN
    	IF clk'EVENT AND clk = '1' THEN
        	IF we = '0' THEN
            	counter := (counter + 1) mod 10;
            ELSE
            	counter := TO_INTEGER(UNSIGNED(d_in));
            END IF;
        END IF;
        
        y <= STD_LOGIC_VECTOR(TO_UNSIGNED(counter, 4));
    END PROCESS;
END ARCHITECTURE a_bcd;

--kolo
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY kolo IS
	PORT(
    	 clk, rst: IN STD_LOGIC;
         d_out: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
END ENTITY kolo;

ARCHITECTURE a_kolo OF kolo IS
	SIGNAL we_unutr, cq: STD_LOGIC;
    SIGNAL d_in_unutr: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

	bcd: ENTITY work.bcd(a_bcd)
    	 PORT MAP(cq, we_unutr, d_in_unutr, d_out);
         
    PROCESS(clk, rst)
    BEGIN
    	IF rst = '1' THEN
        	we_unutr <= '1';
            d_in_unutr <= "0000";
            cq <= clk;
        END IF;
        
        IF clk'EVENT AND clk = '1' THEN
        	cq <= NOT cq;
            IF cq = '1' THEN
            	we_unutr <= '0';
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE a_kolo;

--testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY tb IS
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL clk, rst: STD_LOGIC;
    SIGNAL d_out: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	
    dut: ENTITY work.kolo(a_kolo)
    	 PORT MAP(clk, rst, d_out);
      
    klok: PROCESS
    BEGIN
    	clk <= '0';
        WAIT FOR 5ns;
        clk <= '1';
        WAIT FOR 5ns;
    END PROCESS klok;
    
    stimuli: PROCESS
    BEGIN
    	rst <= '1';
        WAIT FOR 2ns;
        rst <= '0';
        WAIT FOR 500ns;
    END PROCESS stimuli;
END ARCHITECTURE sim;
    
