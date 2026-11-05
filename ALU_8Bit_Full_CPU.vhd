library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_8Bit_Full_CPU is
    port (
        A      : in  std_logic_vector(7 downto 0); 
        B      : in  std_logic_vector(7 downto 0); 
        S      : in  std_logic_vector(3 downto 0); 
        Y      : out std_logic_vector(7 downto 0); 
        FLAG_Z : out std_logic;                   
        FLAG_C : out std_logic;                    
        FLAG_V : out std_logic;                    
        FLAG_S : out std_logic                     
    );
end entity ALU_8Bit_Full_CPU;

architecture Behavioral of ALU_8Bit_Full_CPU is


    signal sum_add  : unsigned(8 downto 0);
    signal sum_sub  : unsigned(8 downto 0);

    
    signal add_out  : std_logic_vector(7 downto 0);
    signal sub_out  : std_logic_vector(7 downto 0);
    signal inc_out  : std_logic_vector(7 downto 0);
    signal dec_out  : std_logic_vector(7 downto 0);
    signal pass_out : std_logic_vector(7 downto 0);
    
   
    signal and_out  : std_logic_vector(7 downto 0);
    signal or_out   : std_logic_vector(7 downto 0);
    signal xor_out  : std_logic_vector(7 downto 0);
    signal not_out  : std_logic_vector(7 downto 0);
    signal nand_out : std_logic_vector(7 downto 0);
    signal nor_out  : std_logic_vector(7 downto 0);
    
    
    signal lsl_out  : std_logic_vector(7 downto 0);
    signal lsr_out  : std_logic_vector(7 downto 0);
    signal asr_out  : std_logic_vector(7 downto 0);
    signal rol_out  : std_logic_vector(7 downto 0);
    signal ror_out  : std_logic_vector(7 downto 0);
    
    signal res_int  : std_logic_vector(7 downto 0);

begin


    sum_add <= ('0' & unsigned(A)) + ('0' & unsigned(B)); 
    add_out <= std_logic_vector(sum_add(7 downto 0));
    

    sum_sub <= ('0' & unsigned(A)) + ('0' & unsigned(not B)) + 1;
    sub_out <= std_logic_vector(sum_sub(7 downto 0));

   
    inc_out <= std_logic_vector(unsigned(A) + 1);
    
 
    dec_out <= std_logic_vector(unsigned(A) - 1);
    
    
    pass_out <= A;
    

    and_out  <= A and B;   
    or_out   <= A or B;    
    xor_out  <= A xor B;   
    not_out  <= not A;     
    nand_out <= A nand B; 
    nor_out  <= A nor B;   
    
    
    lsl_out <= A(6 downto 0) & '0';
    
    
    lsr_out <= '0' & A(7 downto 1);
    
    
    asr_out <= A(7) & A(7 downto 1);
    
    
    rol_out <= A(6 downto 0) & A(7);
    
    
    ror_out <= A(0) & A(7 downto 1);
    
    
    
    
    process(S,add_out, sub_out, inc_out, dec_out, pass_out,
            and_out, or_out, xor_out, not_out, nand_out, nor_out,
            lsl_out, lsr_out, asr_out, rol_out, ror_out)
    begin
        case S is
            when "0000" => res_int <= add_out;  
            when "0001" => res_int <= sub_out;  
            when "0010" => res_int <= inc_out;  
            when "0011" => res_int <= dec_out;  
            when "0100" => res_int <= pass_out; 
            when "0101" => res_int <= and_out;  
            when "0110" => res_int <= or_out;   
            when "0111" => res_int <= xor_out; 
            when "1000" => res_int <= not_out; 
            when "1001" => res_int <= nand_out;
            when "1010" => res_int <= nor_out;  
            when "1011" => res_int <= lsl_out;  
            when "1100" => res_int <= lsr_out;  
            when "1101" => res_int <= asr_out;  
            when "1110" => res_int <= rol_out;  
            when "1111" => res_int <= ror_out;  
            when others => res_int <= "00000000";
        end case;
    end process;
    
    Y <= res_int;

    
    FLAG_Z <= '1' when res_int = "00000000" else '0';
    
    
    FLAG_S <= res_int(7);


    FLAG_C <= std_logic(sum_add(8)) when S = "0000" else
              std_logic(sum_sub(8)) when S = "0001" else
              '0';
              

    FLAG_V <= ((not A(7)) and (not B(7)) and res_int(7)) or
              (A(7) and B(7) and (not res_int(7))) when S = "0000" else
              ((not A(7)) and B(7) and res_int(7)) or
              (A(7) and (not B(7)) and (not res_int(7))) when S = "0001" else
              '0';

end architecture Behavioral;