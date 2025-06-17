module Counter #(parameter N = 8) (
    input  logic clk,        // Reloj
    input  logic rst,        // Reset
    input  logic en,         // Habilitación
    output logic [N-1:0] Q   // Salida de N bits
);

    // Inicializa Q en 0 o lo reinicia al reset
    always_ff @(negedge clk or posedge rst) begin
        if (rst)
            Q <= {N{1'b0}};    // Reinicia Q a 0 (N bits)
        else if (en)
            Q <= Q + 1'b1;     // Incrementa Q en 1
    end

endmodule
