`timescale 1ns/1ps

module imem(
    input  logic [31:0] a,    // dirección de 32 bits (byte-address)
    output logic [31:0] rd    // instrucción de 32 bits
);

    // Banco de 64 palabras de 32 bits
    logic [31:0] RAM [0:63];

    // Inicializa la ROM desde el fichero ROM.dat
    initial begin
        $readmemh("C:/Users/Xpc/Documents/GitHub/Proyecto_Final/Proyecto_final_funda/memfile.dat", RAM);
    end

    // Lectura combinacional, alineada a palabra
    assign rd = RAM[a[31:2]];

endmodule
