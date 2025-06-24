module testbench();

    logic clk;
    logic reset;

    // Instancia del módulo top
    top dut (
        .clk(clk),
        .reset(reset)
    );

    // Acceso jerárquico a las señales internas de top
    wire [31:0] WriteData = dut.WriteData;
    wire [31:0] DataAdr   = dut.DataAdr;
    wire        MemWrite  = dut.MemWrite;

    // Señal para el contador de ciclos
    logic [7:0] cycle_counter;

    // Instanciación del contador de ciclos
    Counter #(8) cycle_counter_inst (
        .clk(clk),
        .rst(reset),
        .en(1'b1),
        .Q(cycle_counter)
    );

    // Inicializar el reset para los primeros dos ciclos de reloj
    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    // Generar reloj con periodo de 10 ns
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // Verifica que la simulación termine al llegar al ciclo 24
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            $display("Reset active. Counter reset to 0");
        end else if (cycle_counter == 24) begin
            $display("Simulation finished after 24 cycles.");
            $stop;
        end
    end

    // Verificación de señales de escritura en memoria
    always @(negedge clk) begin
        // Mostrar valores relevantes de cada ciclo
        $display("Cycle %d: MemWrite=%b, DataAdr=%h, WriteData=%h", cycle_counter, MemWrite, DataAdr, WriteData);

        // Verificación de que la escritura ocurre en la dirección 0x64 y con el valor esperado
        if (MemWrite) begin
            if (DataAdr === 32'h64 && WriteData === 32'hA) begin
                $display("Simulation succeeded: Data 0xA written to address 0x64");
                $stop; // Detener la simulación en caso de éxito
            end else if (DataAdr !== 32'h64) begin
                $display("Simulation failed: Incorrect memory address. Expected 0x64, got %h", DataAdr);
                $stop; // Detener la simulación si la dirección es incorrecta
            end else if (WriteData !== 32'hA) begin
                $display("Simulation failed: Incorrect data written. Expected 0xA, got %h", WriteData);
                $stop; // Detener la simulación si los datos son incorrectos
            end
        end
    end

    // Verificación adicional de la memoria durante la ejecución
    always @(posedge clk) begin
        // Monitorizar cuando MemWrite está activado
        if (MemWrite) begin
            // Puedes agregar aquí más verificaciones según el flujo de tu simulación
            $display("Write operation: MemWrite=%b, Addr=%h, Data=%h", MemWrite, DataAdr, WriteData);
        end
    end

endmodule
