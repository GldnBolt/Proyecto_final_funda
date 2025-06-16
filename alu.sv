`timescale 1ns/1ps

module alu(
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [1:0]  ALUControl,  // 00=ADD, 01=SUB, 10=AND, 11=ORR
    output logic [31:0] ALUResult,
    output logic [3:0]  ALUFlags      // {N,Z,C,V}
);

    // Suma / resta
    logic [31:0] sum;
    logic        c_out;
    assign {c_out, sum} = (ALUControl == 2'b01)
                         ? (A + (~B) + 1)  // SUB
                         : (A + B);        // ADD

    // AND / OR
    logic [31:0] band;
    logic [31:0] borr;
    assign band = A & B;
    assign borr = A | B;

    // Selección del resultado
    always_comb begin
        case (ALUControl)
            2'b00,
            2'b01: ALUResult = sum;
            2'b10: ALUResult = band;
            2'b11: ALUResult = borr;
            default: ALUResult = 32'b0;
        endcase
    end

    // Flags
    assign ALUFlags[3] = ALUResult[31];           // N
    assign ALUFlags[2] = (ALUResult == 32'b0);    // Z
    assign ALUFlags[1] = c_out;                   // C
    assign ALUFlags[0] =
        (ALUControl == 2'b00)  // ADD overflow
            ? ((A[31] & B[31] & ~sum[31]) |
               (~A[31] & ~B[31] & sum[31]))
        : (ALUControl == 2'b01)  // SUB overflow
            ? ((A[31] & ~B[31] & ~sum[31]) |
               (~A[31] & B[31] & sum[31]))
        : 1'b0;  // sin overflow para AND/OR

endmodule
