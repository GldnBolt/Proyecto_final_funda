module testbench_alu();

    // Declaración de señales
    logic [31:0] A, B;       // Operandos A y B
    logic [1:0] ALUControl;  // Señal de control de la ALU
    logic [31:0] ALUResult;  // Resultado de la ALU
    logic [3:0] ALUFlags;    // Flags de la ALU (N, Z, C, V)

    // Instanciación de la ALU
    alu alu0 (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .ALUFlags(ALUFlags)
    );

    // Inicializar las señales
    initial begin
        // Mostrar encabezado
        $display("ALU Testbench");
        $display("A     B     ALUControl   ALUResult   ALUFlags");
        
        // Probar cada operación de la ALU
        // Suma (ALUControl = 00)
        A = 32'h00000005; B = 32'h00000003; ALUControl = 2'b00;
        #10 $display("A = %h, B = %h, ALUResult = %h", A, B, ALUResult);

        // Resta (ALUControl = 01)
        A = 32'h00000008; B = 32'h00000002; ALUControl = 2'b01;
        #10 $display("A = %h, B = %h, ALUResult = %h", A, B, ALUResult);

        // AND (ALUControl = 10)
        A = 32'h0000000F; B = 32'h00000003; ALUControl = 2'b10;
        #10 $display("A = %h, B = %h, ALUResult = %h", A, B, ALUResult);

        // OR (ALUControl = 11)
        A = 32'h0000000F; B = 32'h000000F0; ALUControl = 2'b11;
        #10 $display("A = %h, B = %h, ALUResult = %h", A, B, ALUResult);

        // Detener la simulación
        $stop;
    end

endmodule
