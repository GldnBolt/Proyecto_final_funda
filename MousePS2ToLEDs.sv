module MousePS2ToLEDs(
    input wire clk,              // Reloj del sistema
    input wire reset,            // Reset
    input wire ps2_clk,          // PS/2 Clock
    input wire ps2_data,         // PS/2 Data
    output reg [4:0] leds        // LEDs: D, I, U, A, Click
);

    // Estado de recepción
    reg [1:0] state = 2'b00;
    localparam WAIT_START = 2'b00;
    localparam READ_BYTE  = 2'b01;
    localparam PROCESS    = 2'b10;

    reg [7:0] mouse_data0, mouse_data1, mouse_data2;
    reg [3:0] bit_count = 0;
    reg [7:0] shift_reg = 8'd0;
    reg [1:0] byte_index = 0;
    reg prev_ps2_clk = 1;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            bit_count <= 0;
            byte_index <= 0;
            leds <= 5'b00000;
        end else begin
            // Detecta flanco de bajada en ps2_clk
            if (prev_ps2_clk && !ps2_clk) begin
                shift_reg <= {ps2_data, shift_reg[7:1]};
                bit_count <= bit_count + 1;

                if (bit_count == 10) begin
                    case (byte_index)
                        2'd0: mouse_data0 <= shift_reg;
                        2'd1: mouse_data1 <= shift_reg;
                        2'd2: mouse_data2 <= shift_reg;
                    endcase

                    byte_index <= byte_index + 1;
                    bit_count <= 0;

                    if (byte_index == 2) begin
                        state <= PROCESS;
                    end
                end
            end
            prev_ps2_clk <= ps2_clk;

            // Procesamiento
            if (state == PROCESS) begin
                // Convertir X e Y como números con signo
                integer dx, dy;
                dx = $signed(mouse_data1);
                dy = $signed(mouse_data2);

                // Reset para próxima lectura
                leds <= 5'b00000;

                // Detectar dirección del mouse
                if (dx > 0) leds[0] = 1; // Derecha
                else if (dx < 0) leds[1] = 1; // Izquierda

                if (dy < 0) leds[2] = 1; // Arriba
                else if (dy > 0) leds[3] = 1; // Abajo

                // Verificación de los clics
                if (mouse_data0[0] || mouse_data0[1]) leds[4] = 1; // Clic izquierdo o derecho
                else leds[4] = 0; // Apagar LED 4 si no hay clic

                // Reset para próxima lectura
                state <= WAIT_START;
                byte_index <= 0;
            end
        end
    end

endmodule
