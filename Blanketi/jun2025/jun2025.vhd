--1konv
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY bcd_to_gray IS
	PORT(
    	 bcd: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         gray: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
END ENTITY bcd_to_gray;

ARCHITECTURE beh OF bcd_to_gray IS
BEGIN
	PROCESS(bcd)
    BEGIN
    	gray(3) <= bcd(3);
        gray(2) <= bcd(3) XOR bcd(2);
        gray(1) <= bcd(2) XOR bcd(1);
        gray(0) <= bcd(1) XOR bcd(0);
	END PROCESS;
END ARCHITECTURE beh;

--nkonv
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY nbcd_to_gray IS
	GENERIC(n : INTEGER := 4);
    PORT(
    	 bcd: IN STD_LOGIC_VECTOR(4*n-1 DOWNTO 0);
         gray: OUT STD_LOGIC_VECTOR(4*n-1 DOWNTO 0)
         );
END ENTITY nbcd_to_gray;

ARCHITECTURE struct OF nbcd_to_gray IS
BEGIN
	generisi: FOR i IN 0 TO n-1 GENERATE
    	cifra: ENTITY work.bcd_to_gray(beh)
        	   PORT MAP(
               			bcd => bcd(4*i+3 DOWNTO 4*i),
                        gray => gray(4*i+3 DOWNTO 4*i)
                        );
	END GENERATE generisi;
END ARCHITECTURE struct;

--testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY tb IS
	GENERIC(n : INTEGER := 4);
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL clk: STD_LOGIC;
    SIGNAL bcd, gray: STD_LOGIC_VECTOR(4*n-1 DOWNTO 0);
BEGIN
	uut: ENTITY work.nbcd_to_gray(struct)
    	 GENERIC MAP(n)
         PORT MAP(bcd, gray);
     
	klok: PROCESS
    BEGIN
    	clk <= '0';
        WAIT FOR 25ns;
        clk <= '1';
        WAIT FOR 25ns;
	END PROCESS klok;
    
    stimuli: PROCESS
    BEGIN
    	bcd <= "0000000000000001";
        WAIT FOR 50ns;
        bcd <= "0000000000001001";
        WAIT FOR 50ns;
        bcd <= "0000000000100101";
        WAIT FOR 50ns;
        bcd <= "0000000010011001";
        WAIT FOR 50ns;
        bcd <= "0000100010001000";
        WAIT FOR 50ns;
	END PROCESS stimuli;
END ARCHITECTURE sim;
