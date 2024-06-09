module InstructionMemory(
	input wire clk,kill,stall, 
	input wire [15:0] address, 
	output reg [0:15] instruction
);

 
    reg [15:0] instructionMemory [0:255];		  // the size will be 2 ^ 16


	always @(posedge clk) begin
		#1fs 	// wait the value for PC
			
		if (stall)
			instruction <= instruction;
		else if (!kill)
			instruction <= instructionMemory[address[15:0]];
		else
			instruction <= {ADD, R1, R1, R0, 3'b000};
			
	end 

    initial begin
        // R-type
        instructionMemory[0] = {AND, R4, R6, R7, 3'b000};
    	instructionMemory[1] = {ADD, R6, R4, R2, 3'b000};
    	instructionMemory[2] = {SUB, R5, R3, R5, 3'b000}; 
		
//		instructionMemory[1] = {SV , R1, 1'b0 , 8'hFF};
//		instructionMemory[2] = {LBu , R3, R0 ,1'b0, 5'h01};
//		instructionMemory[3] = {LBs , R3, R1 ,1'b1, 5'h00};
//		instructionMemory[4] = {LW , R3, R0 ,1'b0, 5'b00001};
//		instructionMemory[5] = {LW , R4, R1 ,1'b0, 5'b00000};
//		instructionMemory[6] = {SW , R4, R2 ,1'b0, 5'b00000};
    end

endmodule



module instructionMemory_TB;
    // Clock signal declaration
    wire clock;        
    ClockGenerator clock_generator(clock);

    
    reg [15:0] address;
    wire [15:0] instruction; 

    // Instantiate InstructionMemory module
    InstructionMemory insMem (
		.clk(clock),
		.kill(kill),
		.stall(stall),
        .address(address), 
        .instruction(instruction)
    );

    initial begin
       
        $monitor("At Address: %b, Instruction: %b", address, instruction);

        
        address <= 16'd0; // set address to 0
        #5;
        address <= 16'd1; // set address to 1
        #10;
        address <= 16'd2; // set address to 2
        #10;
        address <= 16'd3; // set address to 3
        #10; 
         address <= 16'd4; // set address to 4
        #10;
         address <= 16'd5; // set address to 5
        #10;
            
        $finish;
    end
endmodule