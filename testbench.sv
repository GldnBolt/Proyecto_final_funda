
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
	 
	 // Señal para el contador de ciclos
    logic [7:0] cycle_counter;

    // Instanciación del contador de ciclos
    Counter #(8) cycle_counter_inst (
        .clk(clk),
        .rst(reset),
        .en(1'b1),
        .Q(cycle_counter)
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
		
		// Verifica que la simulación termine al llegar al ciclo 255
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            $display("Reset active. Counter reset to 0");
        end else if (cycle_counter == 24) begin
            $display("Simulation finished after 24 cycles.");
            $stop;  
        end
    end
	 
    // check that 7 gets written to address 0x64 at end of program
    always @(negedge clk) begin
		  $display("DataAdr: %d, WriteData: %d", DataAdr, WriteData);
        if (MemWrite) begin
            if (DataAdr === 100 && WriteData === 10) begin
                $display("Simulation succeeded");
                $stop;
            end else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

endmodule