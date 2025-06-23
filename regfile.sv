module regfile(
    input  logic        clk,
    input  logic        we3,
    input  logic [3:0]  ra1, ra2, wa3,
    input  logic [31:0] wd3,
    input  logic [31:0] r15,              
    output logic [31:0] rd1, rd2
);

    logic [31:0] regs[14:0];

    always_ff @(posedge clk)
        if (we3 && wa3 != 4'd15)
            regs[wa3] <= wd3;

    // Lógica para lectura
    assign rd1 = (ra1 == 4'd15) ? r15 : regs[ra1];
    assign rd2 = (ra2 == 4'd15) ? r15 : regs[ra2];

endmodule