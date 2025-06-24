module testbench_controller();

    logic clk;
    logic reset;
    logic [31:0] Instr;  // Instrucción de 32 bits

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

    // Inicialización de señales
    initial begin
        clk = 0;
        reset = 1;
        Instr = 32'hE280200A;  // Instrucción inicial (ADD Immediate)
        #10 reset = 0;  // Desactivar reset después de 10 ciclos

        // Probar diferentes instrucciones
        #10 Instr = 32'hE280200A;  // ADD Immediate
        #10 Instr = 32'hE280200B;  // LDR
        #10 Instr = 32'hE280200C;  // STR
        #10 Instr = 32'hE280200D;  // Branch (BNE)
    end

    // Generación de reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Contador de ciclos para evitar el enciclado
    integer cycle_count = 0;
    always @(posedge clk) begin
        if (cycle_count < 20) begin  // Continuar hasta 20 ciclos
            cycle_count = cycle_count + 1;
        end else begin
            $display("Simulation stopped after 20 cycles.");
            $stop;  // Detener la simulación después de 20 ciclos
        end
    end

    // Verificación de las señales de control después de cada ciclo
    always @(posedge clk) begin
        // Mostrar información clave sobre la ejecución
        $display("Cycle: %d | Instr: %h | RegWrite: %b | MemWrite: %b | ALUControl: %b | RegSrc: %b | ImmSrc: %b | ALUSrc: %b", 
                 $time, Instr, RegWrite, MemWrite, ALUControl, RegSrc, ImmSrc, ALUSrc);
    end

    // Test de reset
    always @(posedge clk) begin
        if (reset) begin
            // Verificar que las señales de control están en estado de reset
            $display("Reset active: RegWrite=%b, MemWrite=%b, ALUControl=%b, RegSrc=%b, ImmSrc=%b, ALUSrc=%b", 
                     RegWrite, MemWrite, ALUControl, RegSrc, ImmSrc, ALUSrc);
        end
    end

    // Comprobación de las señales de control para diferentes instrucciones
    always @(posedge clk) begin
        case (Instr)
            32'hE280200A: begin  // ADD Immediate
                if (RegWrite && ALUControl == 2'b00) begin
                    $display("Success: ADD Instruction | RegWrite=%b, ALUControl=%b", RegWrite, ALUControl);
                end else begin
                    $display("Failure: ADD Instruction | Expected RegWrite=1, ALUControl=00");
                    $stop;
                end
            end
            32'hE280200B: begin  // LDR
                if (!MemWrite && ALUSrc) begin  // MemWrite debe ser 0, ALUSrc debe ser 1
                    $display("Success: LDR Instruction | MemWrite=%b, ALUSrc=%b", MemWrite, ALUSrc);
                end else begin
                    $display("Failure: LDR Instruction | Expected MemWrite=0, ALUSrc=1");
                    $stop;
                end
            end
            32'hE280200C: begin  // STR
                if (MemWrite && !ALUSrc) begin
                    $display("Success: STR Instruction | MemWrite=%b, ALUSrc=%b", MemWrite, ALUSrc);
                end else begin
                    $display("Failure: STR Instruction | Expected MemWrite=1, ALUSrc=0");
                    $stop;
                end
            end
            32'hE280200D: begin  // Branch (BNE)
                if (PCSrc) begin
                    $display("Success: Branch Instruction | PCSrc=%b", PCSrc);
                end else begin
                    $display("Failure: Branch Instruction | Expected PCSrc=1");
                    $stop;
                end
            end
            default: begin
                $display("Failure: Unknown Instruction | Instr: %h", Instr);
                $stop;
            end
        endcase
    end

endmodule
