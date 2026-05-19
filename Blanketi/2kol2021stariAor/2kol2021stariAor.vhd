--dff
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY dff IS
	PORT (
    	  clk, d: IN STD_LOGIC;
          q: OUT STD_LOGIC
          );
END ENTITY dff;

ARCHITECTURE dff_beh OF dff IS
BEGIN
	q <= d WHEN (clk'EVENT AND clk = '0') ELSE q;
END ARCHITECTURE dff_beh;

--brojac
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY brojac IS
	GENERIC (n: INTEGER := 4);
    PORT (
    	  clk, rst: IN STD_LOGIC;
          din: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
          dout: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
          );
END ENTITY brojac;

ARCHITECTURE brojac_beh OF brojac IS
BEGIN
	PROCESS(clk)
    	VARIABLE brojac_int: INTEGER RANGE 0 TO (2**n-1);
        VARIABLE upDown: STD_LOGIC;
	BEGIN
    	IF clk'EVENT AND clk = '1' THEN
        	IF rst = '1' THEN
            	brojac_int := TO_INTEGER(UNSIGNED(din));
                upDown := '1';
            ELSIF upDown = '1' THEN
            	IF brojac_int = (2**n - 1) THEN
                	upDown := '0';
                    brojac_int := brojac_int - 1;
                ELSE
                	brojac_int := brojac_int + 1;
                END IF;
            ELSE
            	IF brojac_int = 0 THEN
                	upDown := '1';
                    brojac_int := brojac_int + 1;
                ELSE
                	brojac_int := brojac_int - 1;
                END IF;
            END IF;
        END IF;
        dout <= STD_LOGIC_VECTOR(TO_UNSIGNED(brojac_int, n));
	END PROCESS;
END ARCHITECTURE brojac_beh;

--kolo
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY kolo IS
	GENERIC (n: INTEGER := 4);
    PORT (
    	  clk, rst: IN STD_LOGIC;
          din: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
          dout: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
          );
END ENTITY kolo;

ARCHITECTURE kolo_struct OF kolo IS
	SIGNAL brojac_out: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL dff_out: STD_LOGIC;
BEGIN
	brojacinst: ENTITY work.brojac(brojac_beh)
    			GENERIC MAP (n)
                PORT MAP (clk, rst, din, brojac_out);
                
	dffinst: ENTITY work.dff(dff_beh)
    		PORT MAP (clk, brojac_out(n-1), dff_out);
            
    dout <= dff_out & brojac_out(n-2 DOWNTO 0);
END ARCHITECTURE kolo_struct;

--testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY tb IS
	GENERIC (n: INTEGER := 4);
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL clk, rst: STD_LOGIC;
    SIGNAL din, dout: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
	dut: ENTITY work.kolo(kolo_struct)
    	 PORT MAP (clk, rst, din, dout);
         
	klok: PROCESS
    BEGIN
    	clk <= '0';
        WAIT FOR 50ns;
        clk <= '1';
        WAIT FOR 50ns;
	END PROCESS klok;
    
    stimuli: PROCESS
    BEGIN
    	rst <= '1';
        din <= "0110";
        WAIT FOR 100 ns;
        rst <= '0';
        WAIT FOR 2000ns;
	END PROCESS stimuli;
END ARCHITECTURE sim;
