`timescale 1ns/1ps

module dmem (
    input  logic        clk,      // reloj
    input  logic        we,       // habilitación de escritura (puerto 0)
    input  logic [31:0] addr0,    // dirección byte-address (puerto 0)
    input  logic [31:0] wd0,      // dato de escritura (puerto 0)
    output logic [31:0] rd0,      // dato de lectura (puerto 0)
    
    input  logic [31:0] addr1,    // dirección byte-address (puerto 1, solo lectura)
    output logic [31:0] rd1       // dato de lectura (puerto 1)
);

    // Banco de 64 palabras de 32 bits
    logic [31:0] RAM [0:1023];

    // Inicialización desde fichero (igual que en imem)
    initial begin
        $readmemh("C:/Users/andre/OneDrive/Escritorio/Proyecto_final_funda/RAM.dat", RAM);
    end

    // Lecturas combinacionales en ambos puertos (alineadas a palabra)
    assign rd0 = RAM[ addr0[31:2] ];
    assign rd1 = RAM[ addr1[31:2] ];

    // Escritura síncrona en puerto 0
    always_ff @(posedge clk) begin
        if (we)
            RAM[ addr0[31:2] ] <= wd0;
    end

endmodule
