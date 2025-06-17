`timescale 1ns/1ps

module testbench();
    logic        clk;
    logic        reset;
    logic [31:0] WriteData, DataAdr;
    logic        MemWrite;

    // instantiate device to be tested
    top dut(
        .clk      (clk),
        .reset    (reset),
        .WriteData(WriteData),
        .DataAdr  (DataAdr),
        .MemWrite (MemWrite)
    );

    // initialize reset for first two clock cycles
    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    // generate clock with 10 ns period
    always begin
        clk <= 1; 
        #5; 
        clk <= 0; 
        #5;
    end

    // check that 7 gets written to address 0x64 at end of program
    always @(negedge clk) begin
		  $display("DataAdr: %d, WriteData: %d", DataAdr, WriteData);
        if (MemWrite) begin
            if (DataAdr === 100 && WriteData === 7) begin
                $display("Simulation succeeded");
                $stop;
            end else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

endmodule
