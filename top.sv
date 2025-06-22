`timescale 1ns/1ps

module top(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite,
	 
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

  // --- PARÁMETROS GLOBALES ---
    localparam CLK_FREQUENCY = 50_000_000; // ¡AJUSTA ESTO!
    localparam DEBOUNCE_MS = 10;

    // --- Señales Internas ---
    wire [9:0] x, y; // Coordenadas desde vgaController



    // --- Señales RGB intermedias para los dos generadores de video ---
	 wire [7:0] start_r, start_g, start_b; // RGB desde startScreen

    logic is_initial_state_active; // Para controlar el multiplexor de video
	 logic is_game_over_state_active; // << NUEVO >>

   

    // --- Instancia PLL (Sin cambios) ---
    pll vgapll(.inclk0(clk), .c0(vgaclk));

    // --- Instancia Controlador VGA (Sin cambios) ---
    // Genera vgaclk, hsync, vsync, sync_b, blank_b, x, y
    vgaController vgaCont(
        .vgaclk(vgaclk), .hsync(hsync), .vsync(vsync), .sync_b(sync_b),
        .blank_b(blank_b), .x(x), .y(y)
    );
	 
	 

	 
    // --- Instancia FSM (Usa connect4_fsm_2player_fpga) ---
    connect4_fsm fsm(
        .clk(clk), .rst(reset), .player1_start(p1_start_debounced), .player2_start(p2_start_debounced),
        .move_valid(move_valid), .winner_found(winner_found), .board_full(board_full), .timer_done(timer_done),
        .reset_timer(reset_timer), .p1_turn(p1_led), .p2_turn(p2_led), .game_over(game_over_led),
        .estado(estado), .random_move(random_move), .player(current_player)
    );

  


    // --- INSTANCIAR TU MÓDULO startScreen ---
    assign is_initial_state_active = (estado == 4'b0000); // P_INICIO desde FSM
	 assign is_game_over_state_active = (estado == 4'b1000); // GAME_OVER

    startScreen initialScreenDrawer (
        .x(x),                         // Coordenada X desde vgaController
        .y(y),                         // Coordenada Y desde vgaController
        .visible(is_initial_state_active), // Se muestra solo si la FSM está en P_INICIO
        .r(start_r),                   // Salida R de la pantalla de inicio
        .g(start_g),                   // Salida G de la pantalla de inicio
        .b(start_b)                    // Salida B de la pantalla de inicio
    );

    // --- Multiplexor de Salida RGB Final ---
    // Si es el estado inicial, usa los colores de startScreen, si no, los de videoGen (juego)
    assign r = start_r ;
    assign g = start_g ;
    assign b = start_b ;







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
