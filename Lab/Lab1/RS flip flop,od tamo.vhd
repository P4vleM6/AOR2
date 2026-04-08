--Koriscenjem procesa opisati RS fliflop koji radi u negativnoj logici(ulazi niskog aktivnog nivoa) i koji se okida prednjom ivicom.Portovi su tipa bit.Testbench koji demonstrira sve osobine:

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY rs IS
    PORT(
         r, s, clk: IN BIT;
         q: OUT BIT;
         );
END ENTITY rs;
  
ARCHITECTURE a_rs OF rs IS
BEGIN
    PROCESS(clk)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF r = '1' AND s = '0' THEN q <= '1';
            ELSIF r = '0' AND s = '1' THEN q <= '0';
            ELSIF r = '1' AND s = '1' THEN q <= q;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE a_rs;

--TESTBENCH

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY rs_tb IS
END ENTITY rs_tb;
  
ARCHITECTURE a_rs_tb OF rs_tb IS
    SIGNAL r, s, clk, q: BIT;
BEGIN
    dut: ENTITY work.rs(a_rs)
         PORT MAP(r, s, clk, q);

    PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 5ns;
        clk <= '1';
        WAIT FOR 5ns;
    END PROCESS;
  
    PROCESS
    BEGIN
        r <= '1';
        s <= '0';
        WAIT FOR 7ns;
        r <= '0';
        s <= '1';
        WAIT FOR 10ns;
        s <= '0';
        WAIT FOR 10ns;
        r <= '1';
        WAIT FOR 10ns;
        s <= '1';
        WAIT FOR 10ns;
        r <= '0';
        WAIT FOR 10ns;
        r <= '1';
        WAIT FOR 10ns;
    END PROCESS;
END ARCHITECTURE a_rs_tb;
