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
        DataAdr = 32'h64;  // Dirección de memoria
        WriteData = 32'hA;  // Dato a escribir

        // Activar reset y luego desactivarlo después de 10 ciclos
        #10 reset = 0;
        #10 MemWrite = 1;  // Activar la escritura
    end

    // Generar reloj
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Condición de parada después de 100 ciclos
    integer cycle_count = 0;
    always @(posedge clk) begin
        cycle_count = cycle_count + 1;
        if (cycle_count == 100) begin  // Parar la simulación después de 100 ciclos
            $display("Simulation stopped after 100 cycles");
            $stop;
        end
    end

    // Verificar escritura en memoria
    always @(posedge clk) begin
        if (MemWrite) begin
            $display("Writing data %h to address %h", WriteData, DataAdr);
        end
    end

endmodule
