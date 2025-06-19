module arm(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] PC,
    input  logic [31:0] Instr,
    output logic        MemWrite,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData,
    output logic [7:0]  cycle_counter  // Conexión del ciclo de contador
);

    // Señales internas
    logic [3:0]  ALUFlags;
    logic        RegWrite, ALUSrc, MemtoReg, PCSrc;
    logic [1:0]  RegSrc, ImmSrc, ALUControl;

	 // Instancia del contador de ciclos
    Counter #(8) cycle_counter_inst (
        .clk(clk),
        .rst(reset),
        .en(1'b1),  // Siempre habilitado para contar ciclos
        .Q(cycle_counter)  // El valor del contador se conecta a cycle_counter
    );
    // Controlador
    controller c (
        .clk        (clk),
        .reset      (reset),
        .Instr      (Instr[31:12]),
        .ALUFlags   (ALUFlags),
        .RegSrc     (RegSrc),
        .RegWrite   (RegWrite),
        .ImmSrc     (ImmSrc),
        .ALUSrc     (ALUSrc),
        .ALUControl (ALUControl),
        .MemWrite   (MemWrite),
        .MemtoReg   (MemtoReg),
        .PCSrc      (PCSrc)
    );

    // Datapath
    datapath dp (
        .clk        (clk),
        .reset      (reset),
        .RegSrc     (RegSrc),
        .RegWrite   (RegWrite),
        .ImmSrc     (ImmSrc),
        .ALUSrc     (ALUSrc),
        .ALUControl (ALUControl),
        .MemtoReg   (MemtoReg),
        .PCSrc      (PCSrc),
        .ALUFlags   (ALUFlags),
        .PC         (PC),
        .Instr      (Instr),
        .ALUResult  (ALUResult),
        .WriteData  (WriteData),
        .ReadData   (ReadData)
    );

endmodule
