// ============================================================================
// register_file.v
// Contains 4 general-purpose registers (R0–R3), each 8-bit wide
// Supports synchronous write and asynchronous read
// ============================================================================

module register_file (
    input  wire        clk,           // Clock
    input  wire        rst,           // Reset (active high)
    input  wire        write_enable,  // Write enable signal
    input  wire [1:0]  read_addr_s,   // Source register address
    input  wire [1:0]  read_addr_d,   // Destination register address
    input  wire [1:0]  write_addr_d,  // Write register address
    input  wire [7:0]  write_data,    // Data to be written
    output wire [7:0]  read_data_s,   // Data from source register
    output wire [7:0]  read_data_d    // Data from destination register
);

    // Register array (4 registers, 8 bits each)
    reg [7:0] registers[0:3];

    // Asynchronous read
    assign read_data_s = registers[read_addr_s];
    assign read_data_d = registers[read_addr_d];

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            for (i = 0; i < 4; i = i + 1)
                registers[i] <= 8'h00;
        end else if (write_enable) begin
            // Write data to register
            registers[write_addr_d] <= write_data;
        end
    end

endmodule
