module testbench_datapath();

    logic clk;
    logic reset;

    // Señales de la ALU
    logic [31:0] ALUResult;
    logic [1:0] ALUControl;

    // Instanciación del datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .ALUResult(ALUResult),
        .ALUControl(ALUControl)
    );

    // Inicialización
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
        ALUControl = 2'b00;  // Prueba de suma
    end

    // Generar reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Verificar el resultado de la ALU
    always @(posedge clk) begin
        $display("ALUResult: %h", ALUResult);
    end

endmodule
