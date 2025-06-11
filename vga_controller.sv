module vga_controller (
    input clk,               // Reloj principal
    input reset,             // Reset
    output reg [3:0] hsync,  // Señal de sincronización horizontal
    output reg [3:0] vsync,  // Señal de sincronización vertical
    output reg [9:0] x,      // Coordenada X
    output reg [9:0] y,      // Coordenada Y
    output reg [3:0] red,    // Canal de color rojo
    output reg [3:0] green,  // Canal de color verde
    output reg [3:0] blue    // Canal de color azul
);

    // Parámetros de la resolución VGA 640x480 @60Hz
    parameter H_SYNC_CYCLES = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_ACTIVE_VIDEO = 640;
    parameter H_FRONT_PORCH = 16;
    parameter V_SYNC_CYCLES = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_ACTIVE_VIDEO = 480;
    parameter V_FRONT_PORCH = 10;

    // Contadores de píxeles
    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_counter <= 0;
            v_counter <= 0;
        end else begin
            // Contador horizontal
            if (h_counter == H_SYNC_CYCLES + H_BACK_PORCH + H_ACTIVE_VIDEO + H_FRONT_PORCH - 1) begin
                h_counter <= 0;
                // Contador vertical
                if (v_counter == V_SYNC_CYCLES + V_BACK_PORCH + V_ACTIVE_VIDEO + V_FRONT_PORCH - 1) begin
                    v_counter <= 0;
                end else begin
                    v_counter <= v_counter + 1;
                end
            end else begin
                h_counter <= h_counter + 1;
            end
        end
    end

    always @(*) begin
        // Sincronización VGA
        hsync = (h_counter < H_SYNC_CYCLES) ? 0 : 1;
        vsync = (v_counter < V_SYNC_CYCLES) ? 0 : 1;

        // Coordenadas de píxel
        x = h_counter - (H_SYNC_CYCLES + H_BACK_PORCH);
        y = v_counter - (V_SYNC_CYCLES + V_BACK_PORCH);

        // Color: Pantalla negra por defecto
        red = 4'b0000;
        green = 4'b0000;
        blue = 4'b0000;

        // Dibuja una línea horizontal (paddle superior)
        if (y > 100 && y < 120 && x > 100 && x < 140) begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b0000;
        end

        // Dibuja una línea horizontal (paddle inferior)
        if (y > 360 && y < 380 && x > 100 && x < 140) begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b0000;
        end
    end
endmodule
