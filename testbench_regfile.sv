module testbench_regfile();

    logic clk;
    logic reset;
    logic [3:0] ra1, ra2, wa3;
    logic we3;
    logic [31:0] wd3;
    logic [31:0] r15; 
    logic [31:0] rd1, rd2;

    // Instancia del regfile
    regfile dut (
        .clk(clk),
        .we3(we3),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .r15(r15),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Ciclo de reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Inicialización
    initial begin
        reset <= 1;
        #10;
        reset <= 0;
        
        // Test de escritura y lectura en el regfile
        ra1 <= 4'd0;   // Lectura del registro 0
        ra2 <= 4'd1;   // Lectura del registro 1
        wa3 <= 4'd2;   // Vamos a escribir en el registro 2
        wd3 <= 32'h12345678;  // Valor a escribir
        we3 <= 1;  // Habilitar escritura
        
        // Verificar después de la escritura
        #10;
        $display("Reading rd1: %h, rd2: %h", rd1, rd2); // Verificamos los registros leídos
        
        // Asegúrate de que el valor fue escrito correctamente
        if (rd1 !== 32'h12345678) $display("Test failed: Reg2 not written correctly");

        // Ahora, verificamos si ALUResult se propaga correctamente (esto puede ser parte de un test más grande)
        $display("ALUResult: %h", rd2);  // Verificamos si la ALU está propagando correctamente a los registros

        #10;
        $stop;  // Detenemos la simulación
    end

endmodule
