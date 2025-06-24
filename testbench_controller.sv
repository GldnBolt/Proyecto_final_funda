module testbench_controller();

    logic clk;
    logic reset;
    logic [31:0] Instr;  // Asegúrate de que Instr sea de 32 bits

    // Señales de control
    logic [1:0] RegSrc;
    logic RegWrite;
    logic [1:0] ImmSrc;
    logic ALUSrc;
    logic [1:0] ALUControl;
    logic MemWrite;
    logic MemtoReg;
    logic PCSrc;

    // Instancia del controlador
    controller ctrl (
        .clk(clk),
        .reset(reset),
        .Instr(Instr),
        .RegSrc(RegSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .PCSrc(PCSrc)
    );

    // Inicializar señales
    initial begin
        clk = 0;
        reset = 1;
        Instr = 32'hE280200A;  // Inicializa con una instrucción válida
        #10 reset = 0;
    end

    // Generar reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Verificación de las señales de control
    always @(posedge clk) begin
        $display("Cycle: %d | Instr: %h | RegWrite: %b | MemWrite: %b | ALUControl: %b | RegSrc: %b | ImmSrc: %b | ALUSrc: %b", 
                 $time, Instr, RegWrite, MemWrite, ALUControl, RegSrc, ImmSrc, ALUSrc);
    end

endmodule
