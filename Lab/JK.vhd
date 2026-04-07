--neki jk flip flop sa async resetom:
--imena za entities i architectures se poklapaju zbog smrdljive eda playground jer nece da radi drugacije,ali bolje je inace da se razlikuju imena,npr ako je entity jk neka architecture bude arch_jk ili tako nesto 

library IEEE;
use IEEE.std_logic_1164.all;

ENTITY jk IS
	PORT(j, k, clk, rst : IN std_logic;
    	 q : OUT std_logic := '0');
END ENTITY jk;

ARCHITECTURE jk OF jk IS
	SIGNAL jk: std_logic_vector(1 DOWNTO 0);
BEGIN
	jk <= j & k;
    
    PROCESS(clk,rst) IS
    BEGIN
    	IF rst = '1' THEN
        	q <= '0';
    	ELSIF clk'EVENT AND clk = '1' THEN
        	CASE jk IS
            	WHEN "01" => q <= '0';
                WHEN "10" => q <= '1';
                WHEN "11" => q <= NOT q;
                WHEN OTHERS => q <= q;
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE jk;

--TESTBENCH

library IEEE;
use IEEE.std_logic_1164.all;

ENTITY jk_tb IS
END ENTITY jk_tb;

ARCHITECTURE jk_tb OF jk_tb IS
	SIGNAL j, k, q : std_logic;
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
BEGIN

	uut: ENTITY work.jk(jk)
    	 PORT MAP(j, k, clk, rst, q);
         
	clk_process: PROCESS
    BEGIN
    	clk <= NOT clk;
        WAIT FOR 5ns;
    END PROCESS clk_process;
    
    stim_process: PROCESS
    BEGIN
    	j <= '0';
        k <= '0';
        WAIT FOR 7ns;
        
        j <= '1';
        WAIT FOR 9ns;
        
        j <= '0';
        WAIT FOR 8ns;
        
        k <= '1';
        j <= '1';
        WAIT FOR 10ns;
        
        k <= '0';
        WAIT FOR 8ns;
        
        rst <= '1';
        WAIT FOR 6ns;
        
        rst <= '0';
        WAIT FOR 10ns;
    END PROCESS stim_process;
END ARCHITECTURE jk_tb;
