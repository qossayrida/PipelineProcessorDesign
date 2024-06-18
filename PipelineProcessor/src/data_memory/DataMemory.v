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
		memory[0] = 8'd0;
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


module DataMemory_TB;
    // Inputs
    reg clk;
    reg wrEnable;
    reg rdEnable;
    reg [1:0] numberOfByte;
    reg [15:0] address;
    reg [15:0] in;

    // Outputs
    wire [15:0] out;

    // Instantiate the DataMemory module
    DataMemory uut (
        .clk(clk),
        .wrEnable(wrEnable),
        .rdEnable(rdEnable),
        .numberOfByte(numberOfByte),
        .address(address),
        .in(in),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period is 10 units
    end

    // Test sequence
    initial begin
        // Initialize inputs
        wrEnable = 0;
        rdEnable = 0;
        numberOfByte = 2'b00;
        address = 16'd0;
        in = 16'd0;

        // Wait for the initial memory content to be displayed
        #10;
        
        // Test writing 8-bit data
        wrEnable = 1;
        address = 16'd1;
        in = 16'h0045; // Write 0x45 to memory[1]
        numberOfByte = 2'b00;
        #10;
        
        // Test writing 16-bit data
        address = 16'd2;
        in = 16'h1294; // Write 0x34 to memory[2] and 0x12 to memory[3]
        numberOfByte = 2'b10;
        #10;
        
        // Disable write enable
        wrEnable = 0;

        // Test reading 16-bit data
        rdEnable = 1;
        address = 16'd2;
        numberOfByte = 2'b00; // Read 16-bit data from memory[2] and memory[3]
        #10;
        
        // Test reading 8-bit data with zero extension
        address = 16'd2;
        numberOfByte = 2'b01; // Read 8-bit data from memory[1] with zero extension
        #10;

        // Test reading 8-bit data with sign extension
        address = 16'd2;
        numberOfByte = 2'b10; // Read 8-bit data from memory[4] with sign extension
        #10;

        // Disable read enable
        rdEnable = 0;
        
        // Finish the simulation
        #10;
        $finish;
    end
    
    // Monitor output and memory content
    initial begin
        $monitor("Time: %0t | address = %h | in = %h | out = %h | wrEnable = %b | rdEnable = %b | numberOfByte = %b",
                  $time, address, in, out, wrEnable, rdEnable, numberOfByte);
    end
endmodule
