// HDL Example 7.13 TOP-LEVEL MODULE
module top(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

    // Internal wires connecting processor and memories
    logic [31:0] PC, Instr, ReadData;

    // Instantiate single-cycle processor and memories
    arm   arm0 (clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
    imem  imem0(PC, Instr);
    dmem  dmem0(clk, MemWrite, DataAdr, WriteData, ReadData);

endmodule :contentReference[oaicite:0]{index=0}

// HDL Example 7.14 DATA MEMORY
module dmem(
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

    // 64-word data memory (word-addressed)
    logic [31:0] RAM[63:0];

    // Read (combinational)
    assign rd = RAM[a[31:2]]; // word aligned

    // Write (synchronous)
    always_ff @(posedge clk)
        if (we)
            RAM[a[31:2]] <= wd;

endmodule :contentReference[oaicite:1]{index=1}

// HDL Example 7.15 INSTRUCTION MEMORY
module imem(
    input  logic [31:0] a,
    output logic [31:0] rd
);

    // 64-word instruction memory
    logic [31:0] RAM[63:0];

    // Initialize from hex file at simulation start
    initial
        $readmemh("memfile.dat", RAM);

    // Read (combinational)
    assign rd = RAM[a[31:2]]; // word aligned

endmodule :contentReference[oaicite:2]{index=2}
