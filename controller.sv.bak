module controller(
    input  logic        clk,
    input  logic        reset,
    input  logic [31:12] Instr,
    input  logic [3:0]  ALUFlags,
    output logic [1:0]  RegSrc,
    output logic        RegWrite,
    output logic [1:0]  ImmSrc,
    output logic        ALUSrc,
    output logic [1:0]  ALUControl,
    output logic        MemWrite,
    output logic        MemtoReg,
    output logic        PCSrc
);

    // Internal control signals
    logic [1:0] FlagW;
    logic       PCS, RegW, MemW;

    // Main decoder: generates control signals based on opcode, funct, and rd
    decoder dec (
        .Op        (Instr[27:26]),
        .Funct     (Instr[25:20]),
        .Rd        (Instr[15:12]),
        .FlagW     (FlagW),
        .PCS       (PCS),
        .RegW      (RegW),
        .MemW      (MemW),
        .MemtoReg  (MemtoReg),
        .ALUSrc    (ALUSrc),
        .ImmSrc    (ImmSrc),
        .RegSrc    (RegSrc),
        .ALUControl(ALUControl)
    );

    // Conditional logic: applies condition codes to update flags, writes, and PC selection
    condlogic cl (
        .clk      (clk),
        .reset    (reset),
        .Cond     (Instr[31:28]),
        .ALUFlags (ALUFlags),
        .FlagW    (FlagW),
        .PCS      (PCS),
        .RegW     (RegW),
        .MemW     (MemW),
        .PCSrc    (PCSrc),
        .RegWrite (RegWrite),
        .MemWrite (MemWrite)
    );

endmodule