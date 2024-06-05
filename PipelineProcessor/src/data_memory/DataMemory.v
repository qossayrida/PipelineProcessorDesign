module DataMemory (
    input wire clk,
    input wire wrEnable,
    input wire rdEnable,
	input wire [1:0]numberOfByte,
    input wire [15:0] address,
    input wire [15:0] in,
    output reg [15:0] out,
);

    reg [7:0] memory [0:255]; 		// the size will be 2 ^ 16
    
    initial begin	
		memory[1] = 8'd1;
        memory[2] = 8'd2;
        memory[3] = 8'd3; 
		memory[4] = 8'd3;
    end

    always @(*) begin
        if (wrEnable) begin  
			
            // Writing 16-bit data to two consecutive memory locations
            memory[address] <= in[7:0];
            memory[address + 1] <= in[15:8];
			
        end	else if (rdEnable) begin
			
            if (numberOfByte == 2'b00) begin
                // Reading 16-bit data from two consecutive memory locations
                out = {memory[address + 1], memory[address]};
            end else if (numberOfByte == 2'b01) begin
                // Reading 8-bit data from one memory location with MSB = 00000000
                out = {8'b00000000, memory[address]};	 
			end else if (numberOfByte == 2'b01) begin
                // Sign extend memory[address] and store to out
            	out = {{8{memory[address][7]}}, memory[address]};
            end
			
        end 
    end

endmodule
