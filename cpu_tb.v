// ============================================================================
// cpu_tb.v
// Testbench for 8‑bit Single‑Cycle CPU with waveform dump and comprehensive
// cycle‑by‑cycle monitoring.
// ============================================================================
`timescale 1ns/1ps

module cpu_tb;

    reg clk;
    reg rst;
    wire halted;  // Declare in testbench

    // Instantiate CPU
    cpu uut (
        .clk(clk),
        .rst(rst),
        .halted(halted)
    );

    // Clock generation: 100 MHz (10 ns period)
    always #5 clk = ~clk;

    // Initial reset and VCD dump
    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);

        clk = 0;
        rst = 1;
        #10 rst = 0;          // de‑assert reset after one clock cycle
    end

    // Cycle‑by‑cycle monitoring (prints on every positive clock edge)
    always @(posedge clk) begin
        $display("Time=%0t | PC=%h | Instr=%h | Opcode=%h | R0=%h R1=%h R2=%h R3=%h | Mem[32]=%h Mem[33]=%h",
                 $time,
                 uut.pc,
                 uut.instr,
                 uut.instr[15:12],
                 uut.RF.registers[0],
                 uut.RF.registers[1],
                 uut.RF.registers[2],
                 uut.RF.registers[3],
                 uut.DM.memory[32],
                 uut.DM.memory[33]
        );

        // Stop simulation when CPU halts
        if (halted) begin
            $display("CPU halted at time %0t, PC=%h", $time, uut.pc);
            $finish;
        end
    end

    // Timeout safeguard (if HALT never reached)
    initial begin
        #500;                 // run for 500 ns max
        $display("Simulation finished (timeout).");
        $finish;
    end

endmodule