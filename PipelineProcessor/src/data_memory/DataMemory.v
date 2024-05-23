module DataMemory (
    input wire clk,
    input wire wr_enable,
    input wire rd_enable,
    input wire [15:0] addr_bus,
    input wire [15:0] in_bus,
    output reg [15:0] out_bus,
    input wire number_of_byte
);

    reg [7:0] memory [0:1023]; 		// the size will be 2 ^ 16
    
    initial begin
        memory[2] = 8'd2;
        memory[3] = 8'd3; 
		memory[4] = 8'd3;
    end

    always @(posedge clk) begin
        if (wr_enable) begin  
			
            // Writing 16-bit data to two consecutive memory locations
            memory[addr_bus] <= in_bus[7:0];
            memory[addr_bus + 1] <= in_bus[15:8];
			
        end	else if (rd_enable) begin
			
            if (number_of_byte == 1) begin
                // Reading 16-bit data from two consecutive memory locations
                out_bus = {memory[addr_bus + 1], memory[addr_bus]};
            end else if (number_of_byte == 0) begin
                // Reading 8-bit data from one memory location with MSB = 00000000
                out_bus = {8'b00000000, memory[addr_bus]};
            end
			
        end 
    end

endmodule
