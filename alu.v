// ============================================================================
// alu.v
// Arithmetic Logic Unit (ALU)
// Supports basic arithmetic and logical operations
// ============================================================================

module alu (
    input  wire [7:0] a,          // Operand A
    input  wire [7:0] b,          // Operand B
    input  wire [2:0] alu_op,     // ALU operation selector
    output reg  [7:0] result,     // ALU result
    output reg        zero_flag   // Zero flag (1 if result = 0)
);

    // Operation codes
    localparam OP_ADD    = 3'b000;  // Addition
    localparam OP_SUB    = 3'b001;  // Subtraction
    localparam OP_AND    = 3'b010;  // Bitwise AND
    localparam OP_PASS_B = 3'b011;  // Pass operand B (used for LOAD/STORE)

    // ALU logic
    always @(*) begin
        case (alu_op)
            OP_ADD:    result = a + b;
            OP_SUB:    result = a - b;
            OP_AND:    result = a & b;
            OP_PASS_B: result = b;
            default:   result = 8'h00;
        endcase

        // Set zero flag
        zero_flag = (result == 8'h00);
    end

endmodule
