--bcd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY bcd IS
	PORT(
         ce, clk: IN STD_LOGIC;
         din: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         q: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
END ENTITY bcd;

ARCHITECTURE a_bcd OF bcd IS
	SIGNAL count: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	PROCESS
    BEGIN
    	IF clk'EVENT AND clk = '1' THEN
        	IF ce = '1' THEN
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
                	WHEN OTHERS => count <= "0000";
				END CASE;
			ELSE
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
                	WHEN OTHERS => count <= "0000";
				END CASE;
			END IF;
		END IF;
	END PROCESS;
    q <= count;
END ARCHITECTURE a_bcd;

--nbcd
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY bcd_n IS
	GENERIC(n : INTEGER := 4);
    PORT(
    	 clk, ce: IN STD_LOGIC;
         din: IN STD_LOGIC_VECTOR(4*n-1 DOWNTO 0); --zato sto je jedna bcd cifra 4 cifre
         q: OUT STD_LOGIC_VECTOR(4*n-1 DOWNTO 0)
         );
END ENTITY bcd_n;

ARCHITECTURE a_bcd_n OF bcd_n IS
	SIGNAL carry: STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
	carry(0) <= ce;
    
    gencifre: FOR i IN 0 TO n-1 GENERATE
    	cifra: ENTITY work.bcd(a_bcd)
        	   PORT MAP(
               			clk => clk,
                        ce => carry(i),
                        din => din(4*i+3 DOWNTO 4*i),
                        q => q(4*i+3 DOWNTO 4*i)
                        );
                        
		carry(i+1) <= '1' WHEN q(4*i+3 DOWNTO 4*i) = "0000" AND carry(i) = '1' ELSE '0';
	END GENERATE gencifre;
END ARCHITECTURE a_bcd_n;

--testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY tb IS
	GENERIC(n : INTEGER := 4);
END ENTITY tb;

ARCHITECTURE sim OF tb IS
	SIGNAL clk, ce: STD_LOGIC;
	SIGNAL din, q: STD_LOGIC_VECTOR(4*n-1 DOWNTO 0);
BEGIN
	uut: ENTITY work.bcd_n(a_bcd_n)
    	 GENERIC MAP(n)
         PORT MAP(clk, ce, din, q);
        
	klok: PROCESS
    BEGIN
    	clk <= '0';
        WAIT FOR 10ns;
        clk <= '1';
        WAIT FOR 10ns;
	END PROCESS klok;
    
    stimuli: PROCESS
    BEGIN
    	--paralelno legalne vr
        ce <= '0';
        din <= "0000000100000001";
        WAIT FOR 20ns;
        --dozvoljeno brojanje
        ce <= '1';
        WAIT FOR 200ns;
        --nelegalna vr
        ce <= '0';
        din <= "0000010010001101";
        WAIT FOR 20ns;
        --ponovo dozvoljeno brojanje
        ce <= '1';
        WAIT FOR 200ns;
	END PROCESS stimuli;
END ARCHITECTURE sim;
