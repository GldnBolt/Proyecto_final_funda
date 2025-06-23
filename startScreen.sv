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

    // Parámetros del tamaño de las barras y resolución
    localparam int BAR_WIDTH  = 15;  // Ampliamos el ancho de las barras
    localparam int BAR_HEIGHT = 200; // Ampliamos la altura de las barras
    localparam int SQUARE_SIZE = 16;
    localparam int HRES       = 640;
    localparam int VRES       = 480;

    // Posición de las barras
    logic [9:0] left_bar_posY, right_bar_posY;
    // Posición de la bola
    logic [9:0] ball_posX, ball_posY;

    // Registro de posición con botones para las barras
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Posición inicial de las barras centradas (ligeramente movidas)
            left_bar_posY <= (VRES - BAR_HEIGHT) >> 1;   // Centrada verticalmente
            right_bar_posY <= (VRES - BAR_HEIGHT) >> 1;  // Centrada verticalmente
            // Posición inicial de la bola centrada
            ball_posX <= (HRES - SQUARE_SIZE) >> 1;
            ball_posY <= (VRES - SQUARE_SIZE) >> 1;
        end else begin
            // Movimiento de la barra izquierda (arriba o abajo)
            if (btn_up && left_bar_posY > 0)               left_bar_posY <= left_bar_posY - 1;
            else if (btn_down && left_bar_posY < VRES - BAR_HEIGHT) left_bar_posY <= left_bar_posY + 1;
            
            // Movimiento de la barra derecha (arriba o abajo)
            if (btn_up && right_bar_posY > 0)              right_bar_posY <= right_bar_posY - 1;
            else if (btn_down && right_bar_posY < VRES - BAR_HEIGHT) right_bar_posY <= right_bar_posY + 1;
            
            // Movimiento de la bola (cuadrado)
            // Aquí puedes agregar la lógica de movimiento de la bola si la deseas dinámica
        end
    end

    // Señales para las barras y la bola
    logic in_left_bar, in_right_bar, in_ball;

    // Asignación continua de las dos barras (izquierda y derecha) y la bola
    assign in_left_bar = visible && (x >= 0) && (x < BAR_WIDTH) && (y >= left_bar_posY) && (y < left_bar_posY + BAR_HEIGHT);
    assign in_right_bar = visible && (x >= (HRES - BAR_WIDTH)) && (x < HRES) && (y >= right_bar_posY) && (y < right_bar_posY + BAR_HEIGHT);
    assign in_ball = visible && (x >= ball_posX) && (x < ball_posX + SQUARE_SIZE) && (y >= ball_posY) && (y < ball_posY + SQUARE_SIZE);

    // Colores: blanco para las barras y la bola
    assign r = (in_left_bar || in_right_bar || in_ball) ? 8'hFF : 8'h00;
    assign g = (in_left_bar || in_right_bar || in_ball) ? 8'hFF : 8'h00;
    assign b = (in_left_bar || in_right_bar || in_ball) ? 8'hFF : 8'h00;

endmodule
