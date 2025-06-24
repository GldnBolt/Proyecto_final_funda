module testbench_datapath();
    logic clk;
    logic reset;
    logic [31:0] Instr;
    logic [1:0] RegSrc;
    logic RegWrite;
    logic [1:0] ImmSrc;
    logic ALUSrc;
    logic [1:0] ALUControl;
    logic MemtoReg;
    logic PCSrc;
    logic [3:0] ALUFlags;
    logic [31:0] PC;
    logic [31:0] ALUResult;
    logic [31:0] WriteData;
    logic [7:0] cycle_counter;
    logic [31:0] ReadData;
    logic MemWrite;

    // Instancia del datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .RegSrc(RegSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemtoReg(MemtoReg),
        .PCSrc(PCSrc),
        .ALUFlags(ALUFlags),
        .PC(PC),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .cycle_counter(cycle_counter),
        .MemWrite(MemWrite)
    );

    // Inicializar señales
    initial begin
        clk = 0;
        reset = 1;
        Instr = 32'hE280200A;  // Instrucción de ejemplo (ADD Immediate)
        #10 reset = 0;

        // Probar diferentes instrucciones
        #10 Instr = 32'hE280200A;  // ADD Immediate
        #10 Instr = 32'hE280200B;  // LDR
        #10 Instr = 32'hE280200C;  // STR
        #10 Instr = 32'hE280200D;  // BEQ
    end

    // Generación de reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Verificación de los registros y valores
    always @(posedge clk) begin
        $display("Cycle: %d | Instr: %h | RegWrite: %b | MemWrite: %b | ALUControl: %b | RegSrc: %b | ImmSrc: %b | ALUSrc: %b", 
                 $time, Instr, RegWrite, MemWrite, ALUControl, RegSrc, ImmSrc, ALUSrc);
        
        // Comprobación de valores
        if (PC != 0) 
            $display("Current PC: %h", PC);
        
        // Verificación de ALUResult
        $display("ALU Result: %h", ALUResult);
    end

    // Detener la simulación después de 20 ciclos
    integer cycle_count = 0;
    always @(posedge clk) begin
        if (cycle_count < 20) begin
            cycle_count = cycle_count + 1;
        end else begin
            $display("Simulation stopped after 20 cycles");
            $stop;  // Detener la simulación después de 20 ciclos
        end
    end

endmodule
