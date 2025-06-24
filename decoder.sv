module decoder(
    input  logic [1:0]  Op,
    input  logic [5:0]  Funct,
    input  logic [3:0]  Rd,
    output logic [1:0]  FlagW,
    output logic        PCS,
    output logic        RegW,
    output logic        MemW,
    output logic        MemtoReg,
    output logic        ALUSrc,
    output logic [1:0]  ImmSrc,
    output logic [1:0]  RegSrc,
    output logic [1:0]  ALUControl
);

    // Packed control signals: {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp}
    logic [9:0] controls;
    logic       Branch, ALUOp;

    // Main decoder: generate basic control signals
    always_comb
        casex (Op)
            // Data-processing immediate vs. register
            2'b00: controls = (Funct[5])
                       ? 10'b0000101001  // immediate DP
                       : 10'b0000001001; // register DP
            // Load vs. store
            2'b01: controls = (Funct[0])
                       ? 10'b0001111000  // LDR
                       : 10'b1001110100; // STR
            // Branch
            2'b10: controls = 10'b0110100010;
            default: controls = 10'bx;
        endcase

    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;

    // ALU decoder and flag write logic
    always_comb begin
        // Verificar los valores de Op y Funct antes de asignar ALUControl
        $display("Op: %b, Funct: %b", Op, Funct);

        if (ALUOp) begin
            case (Funct[4:1])  // Aquí estamos usando Funct[4:1] para las operaciones de la ALU
                4'b0100: begin
                    ALUControl = 2'b00; // ADD
                    $display("ALUControl (ADD): %b", ALUControl);
                end
                4'b0010: begin
                    ALUControl = 2'b01; // SUB
                    $display("ALUControl (SUB): %b", ALUControl);
                end
                4'b0000: begin
                    ALUControl = 2'b10; // AND
                    $display("ALUControl (AND): %b", ALUControl);
                end
                4'b1100: begin
                    ALUControl = 2'b11; // ORR
                    $display("ALUControl (ORR): %b", ALUControl);
                end
                default: begin
                    ALUControl = 2'bxx;  // Valor indeterminado si no coincide
                    $display("ALUControl (default): %b", ALUControl);
                end
            endcase
            // Update flags only if S bit (Funct[0]) is set
            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] & ((ALUControl == 2'b00) | (ALUControl == 2'b01));
        end else begin
            ALUControl = 2'b00;    // default ADD
            FlagW      = 2'b00;    // no flag update
        end

        $display("ALUControl: %b", ALUControl); // Mostrar el valor de ALUControl
    end

    // PC select: branch or register writes to PC (Rd == 15)
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

endmodule
