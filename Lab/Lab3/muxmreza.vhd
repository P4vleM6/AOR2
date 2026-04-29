--kolo sa slike opisati koriscenjem generate klauzula,iskljucivo for generate. u okviru njih instance komponenata 
--koje takodje treba opisati.   (slika prilozena u folderu)

--MUX
LIBRARY IEEE;
USE IEEE.std_logic.1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mux IS
  PORT(a,b: IN STD_LOGIC;
       sel: IN STD_LOGIC;
       y: OUT STD_LOGIC
       );
END ENTITY mux;

ARCHITECTURE a_mux OF mux IS
BEGIN
  PROCESS(sel)
  BEGIN
    IF sel = '0' THEN
      y <= a;
    ELSE
      y <= b;
    END IF;
  END PROCESS;
END ARCHITECTURE a_mux;

--KOLO
LIBRARY IEEE;
USE IEEE.std_logic.1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY kolo IS
  GENERIC(n : INTEGER := 8);
  PORT(a, b : IN STD_LOGIC_VECTOR(0 TO n-1);
       sel : IN STD_LOGIC;
       y : OUT STD_LOGIC_VECTOR(0 TO n-1)
       );
END ENTITY kolo;

ARCHITECTURE a_kolo OF kolo IS
BEGIN
  zadnjimux: ENTITY work.mux(a_mux)
    PORT MAP(a(n-1), b(n-1), sel, y(n-1));
  generisi: FOR i IN 0 TO n-2 GENERATE
  BEGIN
    itimux: ENTITY work.mux(a_mux)
      PORT MAP(a(i), a(i+1), sel, y(i));
  END GENERATE generisi;
END ARCHITECTURE a_kolo;

--TESTBENCH

LIBRARY IEEE;
USE IEEE.std_logic.1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_kolo IS
  GENERIC(n : INTEGER := 8);
END ENTITY tb_kolo;

ARCHITECTURE a_tb_kolo OF tb_kolo IS
  SIGNAL a, b, y : STD_LOGIC_VECTOR(0 TO n-1);
  SIGNAL sel : STD_LOGIC;
BEGIN
  dut: ENTITY work.kolo(a_kolo)
    GENERIC MAP(n)
    PORT MAP(a, b, sel, y);

  stimuli: PROCESS
  BEGIN
    a <= "01010101";
    b <= "11001100";
    sel <= '1';
    WAIT FOR 50ns;
    sel <= '0';
    WAIT FOR 50ns;
  END PROCESS stimuli;
END ARCHITECTURE a_tb_kolo
