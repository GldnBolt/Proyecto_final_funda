module startScreen(
    // Los pines 'x' e 'y' ya no se usan, pero los mantenemos 
    // para que la conexión en el módulo 'toplevel' no se rompa.
    input logic [9:0] x, y, 
    input logic visible,
    output logic [7:0] r, g, b
);

    // La lógica ahora es muy simple.
    // Usamos asignaciones continuas (assign) que son perfectas para esto.

    // El rojo y el azul siempre estarán en cero.
    assign r = 8'h00;
    assign b = 8'h00;

    // El verde ('g') dependerá únicamente de la señal 'visible'.
    // Si visible es 1 (true), g = 255. Si no, g = 0.
    assign g = visible ? 8'hFF : 8'h00;

endmodule