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
    // Nueva salida para el contador
    output logic [7:0] cycle_counter  // Contador de ciclos
);

    // Señales internas
    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result;
    logic [3:0]  RA1, RA2;

    // **Instanciación del contador de ciclos**
    logic [7:0] cycle_counter_internal;  // Contador de 8 bits
    Counter #(8) cycle_counter_inst (
        .clk(clk),
        .rst(reset),
        .en(1'b1),  // Siempre habilitado para contar ciclos
        .Q(cycle_counter_internal)  // Valor del contador de ciclos
    );

    // **Asignar la salida del contador de ciclos al puerto de salida**
    assign cycle_counter = cycle_counter_internal;

    // Lógica del siguiente PC
    mux2   #(32) pcmux   (PCPlus4,    Result, PCSrc,  PCNext);
    flopr  #(32) pcreg   (clk, reset, PCNext,       PC);
    adder  #(32) pcadd1  (PC, 32'b100, PCPlus4);
    adder  #(32) pcadd2  (PCPlus4, 32'b100, PCPlus8);

    // Lógica del Banco de Registros
    mux2   #(4)  ra1mux  (Instr[19:16], 4'b1111, RegSrc[0], RA1);
    mux2   #(4)  ra2mux  (Instr[3:0],   Instr[15:12], RegSrc[1], RA2);
    regfile      rf      (clk, RegWrite, RA1, RA2,
                          Instr[15:12], Result, PCPlus8,
                          SrcA, WriteData);

    // Selección de valor para escritura en los registros
    mux2   #(32) resmux  (ALUResult, ReadData, MemtoReg, Result);

    // Extensión inmediata
    extend       ext     (Instr[23:0], ImmSrc, ExtImm);

    // Selección de operando para la ALU
    mux2   #(32) srcbmux (WriteData, ExtImm, ALUSrc, SrcB);
    alu          alu0    (SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

endmodule
