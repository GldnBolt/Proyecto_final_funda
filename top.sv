module top(
    input  logic        clk,
    input  logic        reset,
    
    // --- Salidas VGA ---
    output vgaclk,
    output hsync,
    output vsync,
    output sync_b,
    output blank_b,
    output [7:0] r, // << Salidas finales multiplexadas
    output [7:0] g,
    output [7:0] b

);

// --- Conexiones de memoria ---
    logic [31:0] WriteData; // Conectando WriteData
    logic [31:0] DataAdr;   // Conectando DataAdr
    logic MemWrite;          // Conectando MemWrite

    logic [31:0] PC, Instr;

    // Señales internas para el contador de ciclos
    logic [7:0] cycle_counter;  // Instancia de un contador de 8 bits

    // --- Señales Internas ---
    wire [9:0] x, y; // Coordenadas desde vgaController
    wire [7:0] start_r, start_g, start_b; // RGB desde startScreen

    // --- Instancia PLL ---
    pll vgapll(.inclk0(clk), .c0(vgaclk));

    // --- Instancia Controlador VGA ---
    vgaController vgaCont(
        .vgaclk(vgaclk), .hsync(hsync), .vsync(vsync), .sync_b(sync_b),
        .blank_b(blank_b), .x(x), .y(y)
    );

    // --- Instancia Pantalla de Inicio ---
    startScreen initialScreenDrawer (
        .x(x), .y(y), .visible(1'b1), .r(start_r), .g(start_g), .b(start_b)
    );

    // --- Multiplexor de Salida RGB Final ---
    assign r = start_r;
    assign g = start_g;
    assign b = start_b;

    // --- Instancia del Procesador ---
    arm arm0 (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr),
        .WriteData(WriteData),
        .ReadData()  // No es necesario pasar ReadData aquí, se maneja internamente
    );

    // --- Memoria de Instrucciones ---
    imem imem0 (
        .a(PC),    // byte-address de instrucción
        .rd(Instr)  // instrucción de 32 bits
    );

    // --- Memoria de Datos ---
    dmem dmem0 (
        .clk(clk),
        .we(MemWrite),   // habilita escritura en puerto 0
        .addr0(DataAdr), // dirección byte-address puerto 0
        .wd0(WriteData), // dato a escribir (puerto 0)
        .rd0(),          // dato leído (puerto 0, conectado a una señal interna)
        .addr1(32'b0),   // puerto 1 sólo lectura: dirección fija a 0
        .rd1()            // puerto 1 sólo lectura: salida no conectada
    );

endmodule
