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
    dmem dmem0 (
        .clk (clk),
        .we  (MemWrite),
        .a   (DataAdr),   // byte-address de datos
        .wd  (WriteData), // dato a escribir
        .rd  (ReadData)   // dato leído
    );

endmodule
