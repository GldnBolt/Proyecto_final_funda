module testbench_regfile();

    logic clk;
    logic reset;
    logic we3;
    logic [3:0] ra1, ra2, wa3;
    logic [31:0] wd3, r15;
    logic [31:0] rd1, rd2;

    // Instancia del banco de registros
    regfile rf (
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

    // Inicialización de señales
    initial begin
        clk = 0;
        reset = 1;
        we3 = 0;  // Inicializamos el we3 en 0
        ra1 = 4'd0; ra2 = 4'd1; wa3 = 4'd0;
        wd3 = 32'hA5A5A5A5;  // Primer valor a escribir
        r15 = 32'hFF00FF00;  // Valor de r15, que simula la PC+8

        #10 reset = 0; // Desactivar el reset
        #10 we3 = 1;  // Activar la escritura después de 10 ciclos
        #10 wd3 = 32'h12345678;  // Escribir en el registro 1
        #10 ra1 = 4'd0; ra2 = 4'd1; // Leer registros 0 y 1
        #10 ra1 = 4'd1; ra2 = 4'd2; // Leer registros 1 y 2
        #10 wd3 = 32'h87654321; // Escribir en el registro 2
        #10 ra1 = 4'd2; ra2 = 4'd3; // Leer registros 2 y 3
        #10 wd3 = 32'hDEADBEEF; // Escribir en el registro 3
        #10 ra1 = 4'd3; ra2 = 4'd4; // Leer registros 3 y 4
        #10 ra1 = 4'd15; ra2 = 4'd0; // Leer registro 15 y 0
    end

    // Generar reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Verificación de los registros
    always @(posedge clk) begin
        // Verificar lectura de registros
        if (ra1 != 4'd15) begin
            if (rd1 !== wd3) begin
                $display("Error: Expected %h at rd1[%d], but found %h", wd3, ra1, rd1);
                $stop;
            end
        end
        if (ra2 != 4'd15) begin
            if (rd2 !== wd3) begin
                $display("Error: Expected %h at rd2[%d], but found %h", wd3, ra2, rd2);
                $stop;
            end
        end
    end

    // Comprobación de éxito
    always @(posedge clk) begin
        // Comprobación exitosa después de cada escritura
        if (ra1 == 4'd0 && rd1 == 32'hA5A5A5A5) begin
            $display("Success: Reg0 written correctly.");
        end
        if (ra2 == 4'd1 && rd2 == 32'h12345678) begin
            $display("Success: Reg1 written correctly.");
        end
        if (ra1 == 4'd2 && rd1 == 32'h87654321) begin
            $display("Success: Reg2 written correctly.");
        end
        if (ra2 == 4'd3 && rd2 == 32'hDEADBEEF) begin
            $display("Success: Reg3 written correctly.");
        end
    end

    // Condición de parada después de 200 ciclos
    integer cycle_count = 0;
    always @(posedge clk) begin
        cycle_count = cycle_count + 1;
        if (cycle_count == 200) begin
            $display("Simulation stopped after 200 cycles");
            $stop;
        end
    end

endmodule
