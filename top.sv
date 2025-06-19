`timescale 1ns/1ps

module top(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

    // Señales internas
    logic [31:0] PC, Instr, ReadData;

    // Señal interna para el contador de ciclos
    logic [7:0] cycle_counter;  // Instancia de un contador de 8 bits (puedes ajustarlo a más bits si necesitas más capacidad)

    // Instanciación del contador de ciclos (Counter)
    Counter #(8) cycle_counter_inst (
        .clk(clk),
        .rst(reset),
        .en(1'b1),  // Siempre habilitado para contar ciclos
        .Q(cycle_counter)  // El valor del contador se conecta a cycle_counter
    );

    // Instancia del procesador
    arm arm0 (
        .clk       (clk),
        .reset     (reset),
        .PC        (PC),
        .Instr     (Instr),
        .MemWrite  (MemWrite),
        .ALUResult (DataAdr),
        .WriteData (WriteData),
        .ReadData  (ReadData)
    );

    // Memoria de instrucciones (imem.sv)
    // Asegúrate de que en imem.sv tengas:
    //   initial $readmemh("ROM.dat", RAM);
    imem imem0 (
        .a  (PC),    // byte-address de instrucción
        .rd (Instr)  // instrucción de 32 bits
    );

    // Memoria de datos (dmem.sv)
    // Memoria de datos de dos puertos (dmem.sv)
    dmem dmem0 (
        .clk    (clk),        // reloj
        .we     (MemWrite),   // habilita escritura en puerto 0
        .addr0  (DataAdr),    // dirección byte-address puerto 0
        .wd0    (WriteData),  // dato a escribir            puerto 0
        .rd0    (ReadData),   // dato leído                 puerto 0

        .addr1  (32'b0),      // puerto 1 sólo lectura: dirección fija a 0
        .rd1    ()            // puerto 1 sólo lectura: salida no conectada
    );


    // Puedes usar el contador de ciclos para depuración o como señal de control en tu diseño
    // Ejemplo: puedes mostrar el valor de `cycle_counter` en la simulación con un display
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            $display("Counter reset to 0");
        end else begin
            $display("Cycle Counter: %d", cycle_counter);
        end
    end

endmodule
