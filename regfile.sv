// HDL Example 7.8 REGISTER FILE
module regfile(
    input  logic        clk,
    input  logic        we3,       // write enable
    input  logic [3:0]  ra1,       // read address 1
    input  logic [3:0]  ra2,       // read address 2
    input  logic [3:0]  wa3,       // write address
    input  logic [31:0] wd3,       // write data
    input  logic [31:0] wd4,       // link data (for PC+8)
    output logic [31:0] rd1,       // read data 1
    output logic [31:0] rd2        // read data 2
);

    logic [31:0] regs [0:15];

    // two asynchronous reads
    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

    // synchronous write (writes on rising edge)
    always_ff @(posedge clk) begin
        if (we3) begin
            regs[wa3] <= wd3;
        end
        // write link register (R15) separately
        regs[4'hF] <= wd4;
    end

endmodule
