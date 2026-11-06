module ALU_8Bit_Full_CPU (
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] S,
    output reg [7:0] Y,
    output FLAG_Z,
    output FLAG_C,
    output FLAG_V,
    output FLAG_S
);

    
    wire [8:0] sum_add = {1'b0, A} + {1'b0, B};
    wire [8:0] sum_sub = {1'b0, A} + {1'b0, ~B} + 1'b1;

    
    always @(*) begin
        case (S)
            4'b0000: Y = sum_add[7:0];                 // ADD
            4'b0001: Y = sum_sub[7:0];                 // SUB
            4'b0010: Y = A + 1'b1;                     // INC
            4'b0011: Y = A - 1'b1;                     // DEC
            4'b0100: Y = A;                            // PASS A
            4'b0101: Y = A & B;                        // AND
            4'b0110: Y = A | B;                        // OR
            4'b0111: Y = A ^ B;                        // XOR
            4'b1000: Y = ~A;                           // NOT A
            4'b1001: Y = ~(A & B);                     // NAND
            4'b1010: Y = ~(A | B);                     // NOR
            4'b1011: Y = {A[6:0], 1'b0};               // LSL
            4'b1100: Y = {1'b0, A[7:1]};               // LSR
            4'b1101: Y = {A[7], A[7:1]};               // ASR
            4'b1110: Y = {A[6:0], A[7]};               // ROL
            4'b1111: Y = {A[0], A[7:1]};               // ROR
            default: Y = 8'h00;
        endcase
    end

     
    assign FLAG_Z = (Y == 8'h00) ? 1'b1 : 1'b0;
    assign FLAG_S = Y[7];
    
    assign FLAG_C = (S == 4'b0000) ? sum_add[8] :
                    (S == 4'b0001) ? sum_sub[8] : 1'b0;
                    
    assign FLAG_V = (S == 4'b0000) ? ((~A[7] & ~B[7] & Y[7]) | (A[7] & B[7] & ~Y[7])) :
                    (S == 4'b0001) ? ((~A[7] & B[7] & Y[7]) | (A[7] & ~B[7] & ~Y[7])) : 1'b0;

endmodule