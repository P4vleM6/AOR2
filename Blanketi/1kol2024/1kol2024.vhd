--D flip flop (a))
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY dff IS
	PORT(
    	 d, clk: IN STD_LOGIC;
         q: OUT STD_LOGIC
         );
END ENTITY dff;

ARCHITECTURE a_dff OF dff IS
BEGIN
	q <= d WHEN clk'EVENT AND clk = '1';
END ARCHITECTURE a_dff;

--bcd brojac (b))
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd IS
	PORT(
    	 clk, load: IN STD_LOGIC;
    	 din: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         q: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
END ENTITY bcd;

ARCHITECTURE a_bcd OF bcd IS
	SIGNAL count: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
BEGIN
	PROCESS
    BEGIN
    	WAIT UNTIL rising_edge(clk);
        IF load = '1' THEN
        	CASE din IS
            	WHEN "0000" => count <= din;
                WHEN "0001" => count <= din;
                WHEN "0010" => count <= din;
                WHEN "0011" => count <= din;
                WHEN "0100" => count <= din;
                WHEN "0101" => count <= din;
                WHEN "0110" => count <= din;
                WHEN "0111" => count <= din;
                WHEN "1000" => count <= din;
                WHEN "1001" => count <= din;
                WHEN others => count <= "0000";
            END CASE;
         ELSE
         	CASE count IS
            	WHEN "0000" => count <= "0001";
                WHEN "0001" => count <= "0010";
                WHEN "0010" => count <= "0011";
                WHEN "0011" => count <= "0100";
                WHEN "0100" => count <= "0101";
                WHEN "0101" => count <= "0110";
                WHEN "0110" => count <= "0111";
                WHEN "0111" => count <= "1000";
                WHEN "1000" => count <= "1001";
                WHEN "1001" => count <= "0000";
                WHEN others => count <= "0000";
            END CASE;
         END IF;
     END PROCESS;
     q <= count;
END ARCHITECTURE a_bcd;

--kolo sa brojacem i dff-om (c))
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY kolo IS
	PORT(
    	 clk, load: IN STD_LOGIC;
    	 din: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         q: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
END ENTITY kolo;

ARCHITECTURE structural OF kolo IS
	SIGNAL cnt_out: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL lsb_ff: STD_LOGIC;
BEGIN
	najmanjatezina: ENTITY work.dff(a_dff)
    				PORT MAP(
                    		 clk => clk,
                    		 d => cnt_out(0),
                             q => lsb_ff
                             );
    ostalibitovi: ENTITY work.bcd(a_bcd)
    			  PORT MAP(
                  		   clk => clk,
                           load => load,
                           din => din,
                           q => cnt_out
                           );
    q(0) <= lsb_ff;
    q(3 DOWNTO 1) <= cnt_out(3 DOWNTO 1);
END ARCHITECTURE structural;

--testbench (d))
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb IS
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL clk: STD_LOGIC;
    SIGNAL load: STD_LOGIC;
    SIGNAL din: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL q: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	uut: ENTITY work.kolo(structural)
    	 PORT MAP(
         		  clk => clk,
                  load => load,
                  din => din,
                  q => q
                  );
    clk_gen: PROCESS
    BEGIN
    	clk <= '0';
        WAIT FOR 25ns;
        clk <= '1';
        WAIT FOR 25ns;
    END PROCESS clk_gen;
    
    stimuli: PROCESS
    BEGIN
        WAIT FOR 75ns;
        load <= '1';
        din <= "0010";
        WAIT FOR 50ns;
        load <= '0';
        WAIT FOR 500ns;
        load <= '1';
        din <= "1100";
        WAIT FOR 50ns;
        load <= '0';
        WAIT FOR 25ns;
	END PROCESS stimuli;
END ARCHITECTURE sim;
                  		   
