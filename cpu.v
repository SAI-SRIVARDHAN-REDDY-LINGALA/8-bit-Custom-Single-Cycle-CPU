// ============================================================================
// cpu.v
// Top-level CPU (Single-Cycle, Harvard Architecture)
// ============================================================================

module cpu (
    input  wire clk,
    input  wire rst,
    output reg halted   // <--- add this

);

    // -------------------------
    // Program Counter (PC)
    // -------------------------
    reg [7:0] pc;
    wire [15:0] instr;

    // Instruction fields
    wire [3:0] opcode    = instr[15:12];
    wire [1:0] rd        = instr[11:10]; // destination register
    wire [1:0] rs        = instr[9:8];   // source register
    wire [7:0] imm       = instr[7:0];   // immediate / offset

    // -------------------------
    // Control Signals
    // -------------------------
    wire       reg_write_en;
    wire       mem_write_en;
    wire       jump_en;
    wire       alu_src_b_is_imm;
    wire [2:0] alu_op;

    // -------------------------
    // Register File
    // -------------------------
    wire [7:0] reg_data_s; // source register data
    wire [7:0] reg_data_d; // destination register data
    wire [7:0] write_back_data;

    register_file RF (
        .clk(clk),
        .rst(rst),
        .write_enable(reg_write_en),
        .read_addr_s(rs),
        .read_addr_d(rd),
        .write_addr_d(rd),
        .write_data(write_back_data),
        .read_data_s(reg_data_s),
        .read_data_d(reg_data_d)
    );

    // -------------------------
    // ALU
    // -------------------------
    wire [7:0] alu_in_b = alu_src_b_is_imm ? imm : reg_data_s;
    wire [7:0] alu_result;
    wire       zero_flag;

    alu ALU (
        .a(reg_data_d),
        .b(alu_in_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero_flag(zero_flag)
    );

    // -------------------------
    // Data Memory
    // -------------------------
    wire halt;
    wire [7:0] data_mem_out;

    data_mem DM (
        .clk(clk),
        .write_en(mem_write_en),
        .addr(alu_result),      // memory address from ALU
        .write_data(reg_data_s),// store data comes from source register
        .read_data(data_mem_out)
    );

    // -------------------------
    // Write-Back MUX
    // -------------------------
    assign write_back_data =
        (opcode == 4'b0001) ? data_mem_out : // LOAD
        alu_result;                          // otherwise ALU result 

    // -------------------------
    // Instruction Memory
    // -------------------------
    instr_mem IM (
        .addr(pc),
        .instruction(instr)
    );

    // -------------------------
    // Control Unit
    // -------------------------
    control_unit CU (
        .opcode(opcode),
        .reg_write_en(reg_write_en),
        .mem_write_en(mem_write_en),
        .jump_en(jump_en),
        .alu_src_b_is_imm(alu_src_b_is_imm),
        .alu_op(alu_op),
         .halt(halt)   
    );

// -------------------------
// Program Counter Update
// -------------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 8'h00;
        halted <= 1'b0;  // reset HALT state
    end else if (!halted) begin
        if (halt) begin
            halted <= 1'b1;   // enter halt state
        end else if (jump_en) begin
            pc <= imm;        // jump target
        end else begin
            pc <= pc + 1;     // next instruction
        end
    end
end


endmodule
