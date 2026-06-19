// ============================================================================
// data_mem.v
// 256 x 8-bit Data Memory
// ============================================================================
module data_mem (
    input  wire        clk,
    input  wire        write_en,
    input  wire [7:0]  addr,
    input  wire [7:0]  write_data,
    output wire [7:0]  read_data
);

    reg [7:0] memory[0:255];

    assign read_data = memory[addr];

    always @(posedge clk) begin
        if (write_en)
            memory[addr] <= write_data;
    end

endmodule
