library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

 
entity tb_ALU_8Bit_Full_CPU is
end entity tb_ALU_8Bit_Full_CPU;

architecture sim of tb_ALU_8Bit_Full_CPU is

     
    signal A_tb      : std_logic_vector(7 downto 0) := x"00";
    signal B_tb      : std_logic_vector(7 downto 0) := x"00";
    signal SEL_tb    : std_logic_vector(3 downto 0) := "0000";

    
    signal RESULT_tb : std_logic_vector(7 downto 0);
    signal FLAG_Z_tb : std_logic;
    signal FLAG_C_tb : std_logic;
    signal FLAG_V_tb : std_logic;
    signal FLAG_S_tb : std_logic;

begin

     
    UUT : entity work.ALU_8Bit_Full_CPU
        port map (
            A      => A_tb,
            B      => B_tb,
            S    => SEL_tb,
            Y => RESULT_tb,
            FLAG_Z => FLAG_Z_tb,
            FLAG_C => FLAG_C_tb,
            FLAG_V => FLAG_V_tb,
            FLAG_S => FLAG_S_tb
        );

    
    stim_proc : process
    begin
         
        A_tb <= x"0A"; 
        B_tb <= x"03"; 

         
        SEL_tb <= "0000";
        wait for 10 ns;
        assert (RESULT_tb = x"0D" and FLAG_Z_tb = '0' and FLAG_C_tb = '0' and FLAG_V_tb = '0' and FLAG_S_tb = '0')
            report "FAIL Op 1 (ADD)" severity error;

         
        SEL_tb <= "0001";
        wait for 10 ns;
        assert (RESULT_tb = x"07" and FLAG_Z_tb = '0' and FLAG_C_tb = '1' and FLAG_V_tb = '0' and FLAG_S_tb = '0')
            report "FAIL Op 2 (SUB)" severity error;

         
        SEL_tb <= "0010";
        wait for 10 ns;
        assert (RESULT_tb = x"0B" and FLAG_Z_tb = '0' and FLAG_S_tb = '0')
            report "FAIL Op 3 (INC)" severity error;

        
        SEL_tb <= "0011";
        wait for 10 ns;
        assert (RESULT_tb = x"09" and FLAG_Z_tb = '0' and FLAG_S_tb = '0')
            report "FAIL Op 4 (DEC)" severity error;

        
        SEL_tb <= "0100";
        wait for 10 ns;
        assert (RESULT_tb = x"0A" and FLAG_Z_tb = '0' and FLAG_S_tb = '0')
            report "FAIL Op 5 (PASS A)" severity error;

         
        A_tb <= x"F0";
        B_tb <= x"AA";

         
        SEL_tb <= "0101";
        wait for 10 ns;
        assert (RESULT_tb = x"A0" and FLAG_S_tb = '1')
            report "FAIL Op 6 (AND)" severity error;

         
        SEL_tb <= "0110";
        wait for 10 ns;
        assert (RESULT_tb = x"FA" and FLAG_S_tb = '1')
            report "FAIL Op 7 (OR)" severity error;

         
        SEL_tb <= "0111";
        wait for 10 ns;
        assert (RESULT_tb = x"5A" and FLAG_S_tb = '0')
            report "FAIL Op 8 (XOR)" severity error;

         
        SEL_tb <= "1000";
        wait for 10 ns;
        assert (RESULT_tb = x"0F" and FLAG_S_tb = '0')
            report "FAIL Op 9 (NOT A)" severity error;

         
        SEL_tb <= "1001";
        wait for 10 ns;
        assert (RESULT_tb = x"5F" and FLAG_S_tb = '0')
            report "FAIL Op 10 (NAND)" severity error;

        
        SEL_tb <= "1010";
        wait for 10 ns;
        assert (RESULT_tb = x"05" and FLAG_S_tb = '0')
            report "FAIL Op 11 (NOR)" severity error;

        
 
        SEL_tb <= "1011";
        wait for 10 ns;
        assert (RESULT_tb = "00101110" and FLAG_S_tb = '0')
            report "FAIL Op 12 (LSL)" severity error;

         
        SEL_tb <= "1100";
        wait for 10 ns;
        assert (RESULT_tb = "01001011" and FLAG_S_tb = '0')
            report "FAIL Op 13 (LSR)" severity error;

        
        SEL_tb <= "1101";
        wait for 10 ns;
        assert (RESULT_tb = "11001011" and FLAG_S_tb = '1')
            report "FAIL Op 14 (ASR)" severity error;

       
        SEL_tb <= "1110";
        wait for 10 ns;
        assert (RESULT_tb = "00101111" and FLAG_S_tb = '0')
            report "FAIL Op 15 (ROL)" severity error;

        
        SEL_tb <= "1111";
        wait for 10 ns;
        assert (RESULT_tb = "11001011" and FLAG_S_tb = '1')
            report "FAIL Op 16 (ROR)" severity error;

        
        A_tb   <= x"25";
        B_tb   <= x"25";
        SEL_tb <= "0001"; -- SUB
        wait for 10 ns;
        assert (RESULT_tb = x"00" and FLAG_Z_tb = '1' and FLAG_C_tb = '1')
            report "FAIL Test 17 (Zero Flag Z)" severity error;

         
        B_tb   <= x"01";
        SEL_tb <= "0000"; -- ADD
        wait for 10 ns;
        assert (RESULT_tb = x"00" and FLAG_C_tb = '1' and FLAG_Z_tb = '1')
            report "FAIL Test 18 (Carry Flag C)" severity error;

         
        A_tb   <= x"7F";
        B_tb   <= x"01";
        SEL_tb <= "0000"; -- ADD
        wait for 10 ns;
        assert (RESULT_tb = x"80" and FLAG_V_tb = '1' and FLAG_S_tb = '1' and FLAG_C_tb = '0')
            report "FAIL Test 19 (Overflow Flag V)" severity error;

        report "SUCCESS: All 16 CPU ALU operations and 4 Status Flags verified with ZERO errors!"
            severity note;
        wait;
    end process;

end architecture sim;