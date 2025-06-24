module testbench_dmem();

    logic clk;
    logic reset;
    logic [31:0] DataAdr;
    logic [31:0] WriteData;
    logic MemWrite;
    logic [31:0] ReadData;

    // Instancia de la memoria de datos
    dmem mem (
        .clk(clk),
        .we(MemWrite),
        .addr0(DataAdr),
        .wd0(WriteData),
        .rd0(ReadData)
    );

    // Inicialización de señales
    initial begin
        clk = 0;
        reset = 1;
        MemWrite = 0;
        DataAdr = 32'h64;  // Dirección de memoria inicial
        WriteData = 32'hA;  // Dato a escribir
        #10 reset = 0;      // Desactivar el reset
    end

    // Generar reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Recorrer direcciones de memoria de 10 en 10 hasta 1020
    integer i;
    always @(posedge clk) begin
        if (!reset) begin
            // Realizar escritura y lectura cada vez que MemWrite esté activo
            for (i = 0; i < 101; i = i + 1) begin
                // Escribir datos
                DataAdr <= 32'h64 + i * 10;  // Incrementar dirección de 10 en 10
                WriteData <= 32'hA + i;       // Escribir datos incrementales

                MemWrite <= 1;                // Activar MemWrite
                #10 MemWrite <= 0;            // Desactivar MemWrite

                // Leer y verificar el dato escrito
                #10;
                if (ReadData !== WriteData) begin
                    $display("ERROR: Data mismatch at address %h, expected %h but got %h", DataAdr, WriteData, ReadData);
                end else begin
                    $display("Success: Data %h written and read %h correctly at address %h", WriteData, ReadData, DataAdr);
                end
            end
            $display("Simulation completed successfully.");
            $stop;  // Detener la simulación después de recorrer todas las direcciones
        end
    end

endmodule
