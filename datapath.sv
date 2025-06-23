module datapath(
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  RegSrc,
    input  logic        RegWrite,
    input  logic [1:0]  ImmSrc,
    input  logic        ALUSrc,
    input  logic [1:0]  ALUControl,
    input  logic        MemtoReg,
    input  logic        PCSrc,
    output logic [3:0]  ALUFlags,
    output logic [31:0] PC,
    input  logic [31:0] Instr,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData,
    output logic [7:0]  cycle_counter
);

    // Señales internas
    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result;
    logic [3:0]  RA1, RA2;
    logic [31:0] RegSrcA; // 🔧 CAMBIO: salida directa del banco de registros para A
    logic [31:0] JumpTarget; // 🔧 CAMBIO: dirección de salto
    logic        UsePCForSrcA; // 🔧 CAMBIO: control para SrcA

    // 🔧 CAMBIO: contador de ciclos
    logic [7:0] cycle_counter_internal;
    Counter #(8) cycle_counter_inst (
        .clk(clk),
        .rst(reset),
        .en(1'b1),
        .Q(cycle_counter_internal)
    );
    assign cycle_counter = cycle_counter_internal;

    // 🔧 CAMBIO: PCPlus4 y PCPlus8
    adder #(32) pcadd1  (PC, 32'd4, PCPlus4);
    adder #(32) pcadd2  (PC, 32'd8, PCPlus8);

    // 🔧 CAMBIO: dirección de salto para branch
    adder #(32) jumpadder (PCPlus8, ExtImm, JumpTarget);

    // 🔧 CAMBIO: selección de siguiente PC entre PC+4 y salto
    mux2 #(32) pcmux (PCPlus4, JumpTarget, PCSrc, PCNext);
    flopr #(32) pcreg (clk, reset, PCNext, PC);

    // Banco de registros
    mux2 #(4)  ra1mux (Instr[19:16], 4'b1111, RegSrc[0], RA1);
    mux2 #(4)  ra2mux (Instr[3:0], Instr[15:12], RegSrc[1], RA2);
    regfile rf (
        .clk(clk), .we3(RegWrite),
        .ra1(RA1), .ra2(RA2), .wa3(Instr[15:12]),
        .wd3(Result), .r15(PCPlus8),
        .rd1(RegSrcA), .rd2(WriteData)
    );

    // 🔧 CAMBIO: selecciona entre PC y banco de registros para SrcA
    assign UsePCForSrcA = PCSrc;  // Solo para instrucciones de salto
    mux2 #(32) srca_mux (RegSrcA, PC, UsePCForSrcA, SrcA);

    // ALU operandos
    mux2 #(32) srcbmux (WriteData, ExtImm, ALUSrc, SrcB);
    alu alu0 (SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

    // Extend inmediato
    extend ext (Instr[23:0], ImmSrc, ExtImm);

    // Resultado final
    mux2 #(32) resmux (ALUResult, ReadData, MemtoReg, Result);

endmodule
