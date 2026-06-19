// ============================================================================
// instr_mem.v
// 256 x 16-bit Instruction Memory (Harvard Architecture)
// ============================================================================
module instr_mem (
    input  wire [7:0] addr,        // Program counter address
    output wire [15:0] instruction // Fetched instruction
);

    reg [15:0] instructions[0:255];

    assign instruction = instructions[addr];

    initial 
      begin 

    // Initialize registers with immediate values
    instructions[0]  = 16'b0101_00_00_00000101; // ADDI R0, 5
    instructions[1]  = 16'b0101_01_00_00001010; // ADDI R1, 10
    instructions[2]  = 16'b0101_10_00_00000111; // ADDI R2, 7
    instructions[3]  = 16'b0101_11_00_00000011; // ADDI R3, 3

    // Perform arithmetic operations
    instructions[4]  = 16'b0011_00_01_00000000; // ADD R0, R1   ; R0 = 5 + 10 = 15
    instructions[5]  = 16'b0100_10_11_00000000; // SUB R2, R3   ; R2 = 7 - 3 = 4
    instructions[6]  = 16'b0111_01_10_00000000; // AND R1, R2   ; R1 = 10 & 4 = 0

    // Store and load from memory
    instructions[7]  = 16'b0010_00_00_00100000; // STORE R0, [32] ; Memory[32] = 15
    instructions[8]  = 16'b0001_11_00_00100000; // LOAD R3, [32]  ; R3 = 15

    // More arithmetic
    instructions[9]  = 16'b0011_00_11_00000000; // ADD R0, R3   ; R0 = 15 + 15 = 30
    instructions[10] = 16'b0101_01_00_00000101; // ADDI R1, 5   ; R1 = 0 + 5 = 5
    instructions[11] = 16'b0100_11_01_00000000; // SUB R3, R1   ; R3 = 15 - 5 = 10

    // Jump example (conditional not implemented, but shows JMP usage)
//    instructions[12] = 16'b0110_00_00_00000110; // JMP 6 
// Option A: remove the loop entirely — just delete this line

// Option B: jump forward instead of backward, so it still demonstrates JMP
instructions[12] = 16'b0110_00_00_00001111; // JMP 15 (skip dead HALT/ADDI at 13/14)

    // HALT the CPU
    instructions[13] = 16'b0000_00_00_00000000; // HALT 
    instructions[14] = 16'b0101_10_00_00001000; // ADDI R2, 8   ; will be skipped by HALT/JMP

    // Optional: more memory operations
    instructions[15] = 16'b0010_00_11_00100001; // STORE R3, [33] ; Memory[33] = 10
    instructions[16] = 16'b0001_10_00_00100001; // LOAD R2, [33]  ; R2 = 10
    instructions[17] = 16'b0011_01_10_00000000; // ADD R1, R2    ; R1 = 5 + 10 = 15

    // HALT at the end
    instructions[18] = 16'b0000_00_00_00000000; // HALT
end


endmodule
