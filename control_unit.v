// ============================================================================
// control_unit.v
// Decodes opcode and generates control signals
// ============================================================================
module control_unit (
    input  wire [3:0] opcode,
    output wire       reg_write_en,
    output wire       mem_write_en,
    output wire       jump_en,
    output wire       alu_src_b_is_imm,
    output wire       halt,
    output wire [2:0] alu_op
);

    // Opcode Definitions
    localparam HALT  = 4'b0000,
               LOAD  = 4'b0001,
               STORE = 4'b0010,
               ADD   = 4'b0011,
               SUB   = 4'b0100,
               ADDI  = 4'b0101,
               JMP   = 4'b0110,
               AND   = 4'b0111;

    // Control logic
    assign halt = (opcode == HALT );
    assign reg_write_en     = (opcode == LOAD) || (opcode == ADD) || 
                              (opcode == SUB) || (opcode == ADDI) || (opcode == AND);

    assign mem_write_en     = (opcode == STORE);
    assign jump_en          = (opcode == JMP);
    assign alu_src_b_is_imm = (opcode == ADDI) || (opcode == LOAD) || (opcode == STORE);
    assign alu_op = (opcode == ADD || opcode == ADDI) ? 3'b000 :
                    (opcode == SUB)                   ? 3'b001 :
                    (opcode == AND)                   ? 3'b010 :
                    (opcode == LOAD || opcode == STORE)? 3'b011 :
                                                         3'b000;

endmodule
