module startScreen (
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic       visible,
    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);

    always_comb begin
        if (visible) begin
            // Fondo verde con pequeña lógica condicional para evitar optimización completa
            if ((x[2] ^ y[2]) == 1'b1) begin
                r = 8'd0;
                g = 8'd255;
                b = 8'd0;
            end else begin
                r = 8'd0;
                g = 8'd200;
                b = 8'd0;
            end
        end else begin
            r = 8'd0;
            g = 8'd0;
            b = 8'd0;
        end
    end

endmodule
