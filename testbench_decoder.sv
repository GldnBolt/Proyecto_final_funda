module testbench_decoder();

    // Señales de entrada
    logic [1:0]  Op;         // Operando (opcode)
    logic [5:0]  Funct;      // Función (para operaciones de la ALU)
    logic [3:0]  Rd;         // Registro destino

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
        .Funct(Funct),
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

        // Prueba para instrucciones de tipo 'Data Processing (ADDI)'
        // Instr: ADDI, Op = 2'b00, Funct = 6'bxxxxxx
        Op = 2'b00; Funct = 6'b000000; Rd = 4'b0000;   // Instrucción de suma
        #10 $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);

        // Prueba para instrucciones de tipo 'Store (STR)'
        // Instr: STR, Op = 2'b01, Funct = 6'bxxxxxx
        Op = 2'b01; Funct = 6'b000000; Rd = 4'b0000;   // Instrucción de almacenamiento
        #10 $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);

        // Prueba para instrucciones de tipo 'Branch'
        // Instr: Branch, Op = 2'b10, Funct = 6'bxxxxxx
        Op = 2'b10; Funct = 6'b000000; Rd = 4'b1111;   // Instrucción de salto
        #10 $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);

        // Prueba con otra combinación de `Op` y `Funct`
        // Instr: Suma, Op = 2'b00, Funct = 6'b010000
        Op = 2'b00; Funct = 6'b010000; Rd = 4'b0001;   // Instrucción de suma (ADD)
        #10 $display("%b   %b    %b   %b      %b        %b        %b      %b", Op, Funct, Rd, MemW, ALUControl, RegW, ImmSrc, ALUSrc);

        // Fin de la simulación
        $stop;
    end

endmodule
