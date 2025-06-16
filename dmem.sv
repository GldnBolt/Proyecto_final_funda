`timescale 1ns/1ps

module dmem(
    input  logic        clk,    // reloj
    input  logic        we,     // habilitación de escritura
    input  logic [31:0] a,      // dirección de 32-bits (byte address)
    input  logic [31:0] wd,     // dato de escritura
    output logic [31:0] rd      // dato de lectura
);

    // Memoria de datos de 64 palabras de 32 bits (word-addressed)
    logic [31:0] RAM [0:63];

    // Lectura combinacional (alineada a palabra)
    assign rd = RAM[a[31:2]];

    // Escritura síncrona en flanco de subida
    always_ff @(posedge clk) begin
        if (we)
            RAM[a[31:2]] <= wd;
    end

endmodule
