module ps2KB(
    input  wire       iRST_n,
    input  wire       iCLK_50,
    inout  wire       PS2_CLK,
    inout  wire       PS2_DAT,
    output reg [3:0]  char_code,
    output reg        char_valid
);
    // Scancodes para las flechas (flecha arriba y flecha abajo)
    localparam SC_UP    = 8'h75;  // Flecha arriba
    localparam SC_DOWN  = 8'h72;  // Flecha abajo

    // clk_ps2
    reg [8:0] clk_div;
    wire clk_ps2 = clk_div[8];
    always @(posedge iCLK_50) clk_div <= clk_div + 1;

    // sincronización
    reg ps2_clk_i, ps2_clk_d;
    reg ps2_dat_i, ps2_dat_d;
    always @(posedge clk_ps2) begin
        ps2_clk_d <= PS2_CLK; ps2_clk_i <= ps2_clk_d;
        ps2_dat_d <= PS2_DAT; ps2_dat_i <= ps2_dat_d;
    end

    // shift
    reg [10:0] shift;
    reg [3:0]  bit_cnt;
    always @(negedge ps2_clk_i or negedge iRST_n) begin
        if (!iRST_n) begin 
            shift <= 0; 
            bit_cnt <= 0; 
        end else begin
            shift <= {ps2_dat_i, shift[10:1]};
            bit_cnt <= (bit_cnt == 4'd11) ? 4'd0 : bit_cnt + 1;
        end
    end

    // decodificación y flag
    always @(posedge clk_ps2 or negedge iRST_n) begin
        if (!iRST_n) begin 
            char_code <= 4'hF; 
            char_valid <= 0; 
        end else if (bit_cnt == 4'd11) begin
            char_valid <= 1;
            case (shift[8:1])
                SC_UP:   char_code <= 4'h1; // Flecha arriba
                SC_DOWN: char_code <= 4'h2; // Flecha abajo
                default: char_code <= 4'hF; // No reconocido
            endcase
        end else begin
            char_valid <= 0;
        end
    end
endmodule
