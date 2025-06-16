// HDL Example 7.4 CONDITIONAL LOGIC
module condlogic(
    input  logic        clk,
    input  logic        reset,
    input  logic [3:0]  Cond,
    input  logic [3:0]  ALUFlags,
    input  logic [1:0]  FlagW,
    input  logic        PCS,
    input  logic        RegW,
    input  logic        MemW,
    output logic        PCSrc,
    output logic        RegWrite,
    output logic        MemWrite
);

    logic [1:0] FlagWrite;
    logic [3:0] Flags;
    logic       CondEx;

    // Registros de flags con habilitación
    flopenr #(2) flagreg1 (
        .clk   (clk),
        .reset (reset),
        .en    (FlagWrite[1]),
        .d     (ALUFlags[3:2]),
        .q     (Flags[3:2])
    );
    flopenr #(2) flagreg0 (
        .clk   (clk),
        .reset (reset),
        .en    (FlagWrite[0]),
        .d     (ALUFlags[1:0]),
        .q     (Flags[1:0])
    );

    // Chequeo de condición
    condcheck cc (
        .Cond   (Cond),
        .Flags  (Flags),
        .CondEx (CondEx)
    );

    assign FlagWrite = FlagW & {2{CondEx}};
    assign RegWrite  = RegW   & CondEx;
    assign MemWrite  = MemW   & CondEx;
    assign PCSrc     = PCS    & CondEx;

endmodule

// HDL Example 7.4b CONDITION CHECK
module condcheck(
    input  logic [3:0] Cond,
    input  logic [3:0] Flags,
    output logic       CondEx
);

    logic neg, zero, carry, overflow, ge;

    assign {neg, zero, carry, overflow} = Flags;
    assign ge = (neg == overflow);

    always_comb
        case (Cond)
            4'b0000: CondEx =  zero;                  // EQ
            4'b0001: CondEx = ~zero;                  // NE
            4'b0010: CondEx =  carry;                 // CS
            4'b0011: CondEx = ~carry;                 // CC
            4'b0100: CondEx =  neg;                   // MI
            4'b0101: CondEx = ~neg;                   // PL
            4'b0110: CondEx =  overflow;              // VS
            4'b0111: CondEx = ~overflow;              // VC
            4'b1000: CondEx =  carry & ~zero;         // HI
            4'b1001: CondEx = ~(carry & ~zero);       // LS
            4'b1010: CondEx =  ge;                    // GE
            4'b1011: CondEx = ~ge;                    // LT
            4'b1100: CondEx = ~zero & ge;             // GT
            4'b1101: CondEx = ~(~zero & ge);          // LE
            4'b1110: CondEx = 1'b1;                   // Always
            default: CondEx = 1'bx;                   // undefined
        endcase

endmodule
