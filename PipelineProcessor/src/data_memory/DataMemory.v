module DataMemory (
    input wire clk,
    input wire wrEnable,
    input wire rdEnable,
    input wire [15:0] address,
    input wire [15:0] in,
    output reg [15:0] out,
    input wire numberOfByte
);

    reg [7:0] memory [0:1023]; 		// the size will be 2 ^ 16
    
    initial begin	
		memory[1] = 8'd1;
        memory[2] = 8'd2;
        memory[3] = 8'd3; 
		memory[4] = 8'd3;
    end

    always @(posedge clk) begin
        if (wrEnable) begin  
			
            // Writing 16-bit data to two consecutive memory locations
            memory[address] <= in[7:0];
            memory[address + 1] <= in[15:8];
			
        end	else if (rdEnable) begin
			
            if (numberOfByte == 1) begin
                // Reading 16-bit data from two consecutive memory locations
                out = {memory[address + 1], memory[address]};
            end else if (numberOfByte == 0) begin
                // Reading 8-bit data from one memory location with MSB = 00000000
                out = {8'b00000000, memory[address]};
            end
			
        end 
    end

endmodule
