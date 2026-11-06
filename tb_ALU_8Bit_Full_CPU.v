

module tb_ALU_8Bit_Full_CPU();
    reg [7:0] A_tb;
    reg [7:0] B_tb;
    reg [3:0] SEL_tb;
    
    wire [7:0] RESULT_tb;
    wire FLAG_Z_tb;
    wire FLAG_C_tb;
    wire FLAG_V_tb;
    wire FLAG_S_tb;

     
    ALU_8Bit_Full_CPU uut (
        .A(A_tb),
        .B(B_tb),
        .S(SEL_tb),
        .Y(RESULT_tb),
        .FLAG_Z(FLAG_Z_tb),
        .FLAG_C(FLAG_C_tb),
        .FLAG_V(FLAG_V_tb),
        .FLAG_S(FLAG_S_tb)
    );

    initial begin
         
        A_tb = 8'h0A; B_tb = 8'h03; SEL_tb = 4'b0000;
        #10;
        
         
        SEL_tb = 4'b0001;
        #10;
        
         
        A_tb = 8'hF0; B_tb = 8'hAA; SEL_tb = 4'b0101;
        #10;
        
        
        A_tb = 8'h7F; B_tb = 8'h01; SEL_tb = 4'b0000;
        #10;
        
        $finish;
    end
endmodule