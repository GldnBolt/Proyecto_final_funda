
module imem(
    input  logic [31:0] a,    // dirección de 32 bits (byte-address)
    output logic [31:0] rd    // instrucción de 32 bits
);

    // Banco de 64 palabras de 32 bits
    logic [31:0] RAM [0:63];
	 logic [9:0] rom_index;
	 assign rom_index = a[11:2];

    initial begin
        //$readmemh("C:/Users/Gabriel/Desktop/Proyecto_final_funda/ROM.dat", RAM);
		  $readmemh("C:/Users/Gabriel/Desktop/funda_nuevo/Proyecto_final_funda/ROM.dat", RAM);
    end

    // Lectura combinacional, alineada a palabra
    assign rd = RAM[rom_index];

endmodule
