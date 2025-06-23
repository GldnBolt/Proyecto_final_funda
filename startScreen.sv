module startScreen (
    input  logic        clk,        // reloj de píxel (25 MHz)
    input  logic        reset_n,    // reset asíncrono activo bajo
    input  logic        btn_left,   // botones
    input  logic        btn_right,
    input  logic        btn_up,
    input  logic        btn_down,
    input  logic [9:0]  x,          // coordenadas VGA
    input  logic [9:0]  y,
    input  logic        visible,    // ventana visible
    output logic [7:0]  r,
    output logic [7:0]  g,
    output logic [7:0]  b
);

    // Parámetros del cuadrado y de la resolución
    localparam int SQUARE_SIZE = 16;
    localparam int HRES        = 640;
    localparam int VRES        = 480;

    // Posición del cuadrado
    logic [9:0] posX, posY;

    // Registro de posición con botones
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            posX <= (HRES - SQUARE_SIZE) >> 1;
            posY <= (VRES - SQUARE_SIZE) >> 1;
        end else begin
            // Movimiento horizontal
            if (btn_left  && posX > 0)                       posX <= posX - 1;
            else if (btn_right && posX < HRES - SQUARE_SIZE) posX <= posX + 1;
            // Movimiento vertical
            if (btn_up    && posY > 0)                       posY <= posY - 1;
            else if (btn_down && posY < VRES - SQUARE_SIZE)  posY <= posY + 1;
        end
    end

    // Señal de “estoy dentro del cuadrado”
    logic in_square;
    // Ahora sí: asignación continua válida
    assign in_square = visible
                       && (x >= posX)
                       && (x <  posX + SQUARE_SIZE)
                       && (y >= posY)
                       && (y <  posY + SQUARE_SIZE);

    // Colores: blanco dentro del cuadrado, negro fuera
    assign r = in_square ? 8'hFF : 8'h00;
    assign g = in_square ? 8'h55 : 8'h00;
    assign b = in_square ? 8'h00 : 8'h00;

endmodule
