`timescale 1ns/1ps

module top(
    input  logic        clk,
    input  logic        reset,

    // Salidas de depuración (conectables a LEDs si lo deseás)
    output logic [3:0]  WriteData_debug,
    output logic [3:0]  DataAdr_debug,
    output logic        MemWrite,

    // --- Salidas VGA ---
    output logic        vgaclk,
    output logic        hsync,
    output logic        vsync,
    output logic        sync_b,
    output logic        blank_b,
    output logic [7:0]  r,
    output logic [7:0]  g,
    output logic [7:0]  b
);

    // --- Señales internas ---
    logic [31:0] WriteData, DataAdr, PC, Instr, ReadData;

    // Depuración: asignar valores a salidas de debug
    assign WriteData_debug = WriteData[3:0];
    assign DataAdr_debug   = DataAdr[3:0];

    // VGA
    wire [9:0] x, y;
    wire [7:0] start_r, start_g, start_b;

    logic is_initial_state_active;
    logic is_game_over_state_active;

    // FSM señales
    logic p1_start_debounced, p2_start_debounced;
    logic move_valid, winner_found, board_full, timer_done;
    logic reset_timer, p1_led, p2_led, game_over_led;
    logic [3:0] estado;
    logic random_move;
    logic [1:0] current_player;

    // Contador de ciclos
    logic [7:0] cycle_counter;

    // PLL para generar vgaclk desde clk
    pll vgapll(.inclk0(clk), .c0(vgaclk));

    // VGA controller
    vgaController vgaCont(
        .vgaclk(vgaclk), .hsync(hsync), .vsync(vsync),
        .sync_b(sync_b), .blank_b(blank_b), .x(x), .y(y)
    );

    // FSM
    connect4_fsm fsm(
        .clk(clk), .rst(reset),
        .player1_start(p1_start_debounced), .player2_start(p2_start_debounced),
        .move_valid(move_valid), .winner_found(winner_found), .board_full(board_full),
        .timer_done(timer_done), .reset_timer(reset_timer),
        .p1_turn(p1_led), .p2_turn(p2_led), .game_over(game_over_led),
        .estado(estado), .random_move(random_move), .player(current_player)
    );

    // Estado de pantalla
    assign is_initial_state_active    = (estado == 4'b0000);
    assign is_game_over_state_active = (estado == 4'b1000);

    // Pantalla de inicio
    startScreen initialScreenDrawer (
        .x(x), .y(y),
        .visible(is_initial_state_active),
        .r(start_r), .g(start_g), .b(start_b)
    );

    // Multiplexor de video (de momento solo muestra pantalla inicial)
    assign r = start_r;
    assign g = start_g;
    assign b = start_b;

    // Contador de ciclos
    Counter #(8) cycle_counter_inst (
        .clk(clk), .rst(reset), .en(1'b1), .Q(cycle_counter)
    );

    // Procesador ARM simplificado
    arm arm0 (
        .clk(clk), .reset(reset),
        .PC(PC), .Instr(Instr), .MemWrite(MemWrite),
        .ALUResult(DataAdr), .WriteData(WriteData), .ReadData(ReadData)
    );

    // Memoria de instrucciones
    imem imem0 (
        .a(PC),
        .rd(Instr)
    );

    // Memoria de datos
    dmem dmem0 (
        .clk(clk), .we(MemWrite),
        .addr0(DataAdr), .wd0(WriteData), .rd0(ReadData),
        .addr1(32'b0), .rd1()
    );

    // Display para depuración
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            $display("Counter reset to 0");
        end else begin
            $display("Cycle Counter: %d", cycle_counter);
        end
    end

endmodule
