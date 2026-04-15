--n-bitni kruzni brojac nanize sa wr,ce,din ulazima pomocu procesa i sensitivity listi (n-bitni preko generic klauzule)

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY kruzni IS
  GENERIC (n : INTEGER := 10);
  PORT(
       clk, wr, ce : IN STD_LOGIC;
       din : IN INTEGER RANGE 0 TO n-1;
       count : OUT INTEGER RANGE 0 TO n-1;
      );
END ENTITY kruzni;

ARCHITECTURE beh OF kruzni IS
  SIGNAL counter : INTEGER RANGE 0 TO n-1 := 0;
BEGIN
  PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF wr = '1' THEN
        counter <= din;
      ELSE
        IF ce = '1' THEN
          IF counter = 0 THEN
            counter <= n-1;
          ELSE
            counter <= counter - 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
  count <= counter;
END ARCHITECTURE beh;

--TESTBENCH

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY kruzni_tb IS
  GENERIC (n : INTEGER := 10);
END ENTITY kruzni_tb;

ARCHITECTURE a_kruzni_tb OF kruzni_tb IS
  SIGNAL clk, wr, ce : STD_LOGIC;
  SIGNAL din, count : INTEGER RANGE 0 TO n-1;
BEGIN

  dut: ENTITY work.kruzni(beh)
       PORT MAP(clk, wr, ce, din, count);

  klok: PROCESS
  BEGIN
    clk <= '1';
    WAIT FOR 5ns;
    clk <= '0';
    WAIT FOR 5ns;
  END PROCESS klok;

  stimuli: PROCESS
  BEGIN
    wr <= '0';
    din <= 9;
    WAIT FOR 10ns;
    wr <= '1';
    ce <= '1';
    WAIT FOR 10ns;
    wr <= '0';
    WAIT FOR 200ns;
  END PROCESS stimuli;
END ARCHITECTURE a_kruzni_tb;
