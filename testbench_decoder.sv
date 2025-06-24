module testbench_decoder();

    // Señales de entrada
    logic [1:0]  Op;         // Operando (opcode)
    logic [5:0]  Funct;      // Función (para operaciones de la ALU), corregido a 4 bits
    logic [3:0]  Rd;         // Registro destino
    logic [3:0]  Mul;        // Multiplicación (si es necesario)
    logic [3:0]  movhi_field; // Campo MOVHI (si es necesario)

    // Señales de salida
    logic [1:0]  FlagW;      // Flags a escribir
    logic        PCS;        // Señal de PC (branch)
    logic        RegW;       // Señal de escritura en registro
    logic        MemW;       // Señal de escritura en memoria
    logic        MemtoReg;   // Señal de fuente para la escritura en registros
    logic        ALUSrc;     // Selección de fuente para la ALU
    logic [1:0]  ImmSrc;     // Fuente del inmediato
    logic [1:0]  RegSrc;     // Fuente del registro
    logic [1:0]  ALUControl; // Control de la ALU

    // Instanciación del decoder
    decoder uut (
        .Op(Op),
        .Funct(Funct[5:0]),  // Corregido a 6 bits para ajustar a la estructura del módulo
        .Rd(Rd),
        .FlagW(FlagW),
        .PCS(PCS),
        .RegW(RegW),
        .MemW(MemW),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegSrc(RegSrc),
        .ALUControl(ALUControl)
    );

    // Inicialización de señales
    initial begin
        // Mostrar encabezado
        $display("Testbench for Decoder");
        $display("Op   Funct   Rd   MemWrite  ALUControl  RegWrite  ImmSrc  ALUSrc");

        // Caso 1: Instrucción de suma (ADD) - Op = 2'b00, Funct = 6'b010000
        Op = 2'b00; Funct = 6'b010000; Rd = 4'b0000;   // Instrucción de suma (ADD)
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 0, ALUControl = 00 (ADD), RegWrite = 1, ALUSrc = 0, RegSrc = 00, ImmSrc = 00

        // Caso 2: Instrucción de resta (SUB) - Op = 2'b00, Funct = 6'b001000
        Op = 2'b00; Funct = 6'b001000; Rd = 4'b0001;   // Instrucción de resta (SUB)
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 0, ALUControl = 01 (SUB), RegWrite = 1, ALUSrc = 0, RegSrc = 00, ImmSrc = 00

        // Caso 3: Instrucción de AND - Op = 2'b00, Funct = 6'b000000
        Op = 2'b00; Funct = 6'b000000; Rd = 4'b0010;   // Instrucción de AND
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 0, ALUControl = 10 (AND), RegWrite = 1, ALUSrc = 0, RegSrc = 00, ImmSrc = 00

        // Caso 4: Instrucción de ORR - Op = 2'b00, Funct = 6'b110000
        Op = 2'b00; Funct = 6'b110000; Rd = 4'b0011;   // Instrucción de ORR
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 0, ALUControl = 11 (ORR), RegWrite = 1, ALUSrc = 0, RegSrc = 00, ImmSrc = 00

        // Caso 5: Instrucción de carga (LDR) - Op = 2'b01, Funct = 6'b000000
        Op = 2'b01; Funct = 6'b000000; Rd = 4'b0100;   // Instrucción LDR
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 0, ALUControl = 00 (ADD), RegWrite = 1, ALUSrc = 1, RegSrc = 00, ImmSrc = 00

        // Caso 6: Instrucción de almacenamiento (STR) - Op = 2'b01, Funct = 6'b000000
        Op = 2'b01; Funct = 6'b000000; Rd = 4'b0101;   // Instrucción STR
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 1, ALUControl = 00 (ADD), RegWrite = 0, ALUSrc = 1, RegSrc = 00, ImmSrc = 00

        // Caso 7: Instrucción de salto (Branch) - Op = 2'b10, Funct = 6'b000000
        Op = 2'b10; Funct = 6'b000000; Rd = 4'b0110;   // Instrucción de salto (Branch)
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);
        // Esperado: MemWrite = 0, ALUControl = 00 (ADD), RegWrite = 0, ALUSrc = 0, RegSrc = 00, ImmSrc = 00

        // Caso 8: Instrucción de salto con `Funct = 010000` (Ejemplo: ADD)
        Op = 2'b00; Funct = 6'b010000; Rd = 4'b1000;   // Instrucción ADD
        #10;
        $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);

        // Fin de la simulación
        $stop;
    end

endmodule
