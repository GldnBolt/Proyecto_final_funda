module controller(
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] Instr,  // Se arregla la declaración del tamaño de la instrucción
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
    // No duplicar la instancia del decoder
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
    // No duplicar la instancia del condlogic
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

    // --- Depuración ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            $display("Controller reset: RegWrite=%b, MemWrite=%b, ALUControl=%b", RegWrite, MemWrite, ALUControl);
        end else begin
            $display("Cycle: %d | Instr: %h | RegWrite=%b, MemWrite=%b, ALUControl=%b, RegSrc=%b, ImmSrc=%b, ALUSrc=%b", 
                     $time, Instr, RegWrite, MemWrite, ALUControl, RegSrc, ImmSrc, ALUSrc);
        end
    end

    // Mostrar la instrucción actual y los resultados del decodificador
    always @(Instr or RegWrite or MemWrite or ALUControl or RegSrc or ImmSrc or ALUSrc) begin
        $display("Instruction: %h | RegWrite: %b | MemWrite: %b | ALUControl: %b | RegSrc: %b | ImmSrc: %b | ALUSrc: %b", 
                 Instr, RegWrite, MemWrite, ALUControl, RegSrc, ImmSrc, ALUSrc);
    end

endmodule
