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

    always @(posedge clk) begin
		#1
        if (wrEnable) begin  
			
			memory[address] = in[7:0];
			
            // Writing 16-bit data to two consecutive memory locations
			if (numberOfByte == 2'b10)
            	memory[address + 1] = in[15:8];
			
        end 
    end	
	
	
	always @(posedge clk) begin
		#1	
 	 	if (rdEnable)	
         	if (numberOfByte == 2'b00) begin
                // Reading 16-bit data from two consecutive memory locations
                out = {memory[address + 1], memory[address]};
         	end else if (numberOfByte == 2'b01) begin
                // Reading 8-bit data from one memory location with MSB = 00000000
                out = {8'b00000000, memory[address]};	 
		 	end else if (numberOfByte == 2'b10) begin
                // Sign extend memory[address] and store to out
            	out = {{8{memory[address][7]}}, memory[address]};
        	end
			
    end
	
	initial begin
		$monitor("%0t  ==> memory[0]=%b , memory[1]=%b , memory[2]=%b , memory[3]=%b , memory[4]=%b",$time,memory[0],memory[1],memory[2],memory[3],memory[4]);
		$monitor("%0t  ==> memory[5]=%b , memory[6]=%b , memory[7]=%b , memory[8]=%b , memory[9]=%b",$time,memory[5],memory[6],memory[7],memory[8],memory[9]);
	end
endmodule
