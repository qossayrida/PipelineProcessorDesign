module InstructionMemory(
	input wire clk, 
	input wire [15:0] address, 
	output reg [0:15] instruction
);

 
    reg [15:0] instructionMemory [0:255];		  // the size will be 2 ^ 16



    assign instruction = instructionMemory[address[15:0]]; 


    initial begin
        // R-type
        instructionMemory[0] = {AND, R4, R6, R7, 3'b000};  
		instructionMemory[1] = {ADD, R6, R4, R2, 3'b000};  
		instructionMemory[2] = {SUB, R5, R4, R5, 3'b000};
		
		// I-type
		instructionMemory[3] = {ADDI, R2, R1, 1'b0, 5'b01101};  
		instructionMemory[4] = {ANDI, R4, R5, 1'b0, 5'b11000};
		instructionMemory[5] = {LW, R6, R3, 1'b0, 5'b01001};
		instructionMemory[6] = {LBu, R2, R4, 1'b0, 5'b10100};
		instructionMemory[7] = {LBs, R3, R1, 1'b1, 5'b10001};
		instructionMemory[8] = {SW, R4, R7, 1'b0, 5'b00001};
		instructionMemory[9] = {BGT, R1, R2, 1'b0, 5'b10101};
		instructionMemory[10] = {BGTZ, R1, R2, 1'b1, 5'b00101};
		instructionMemory[11] = {BLT, R4, R4, 1'b0, 5'b10100};
		instructionMemory[12] = {BLTZ, R6, R2, 1'b1, 5'b01010};
		instructionMemory[13] = {BEQ, R5, R1, 1'b0, 5'b10010};
		instructionMemory[14] = {BEQZ, R3, R5, 1'b1, 5'b00010};
		instructionMemory[15] = {BNE, R6, R3, 1'b0, 5'b01001};
		instructionMemory[16] = {BNEZ, R7, R6, 1'b1, 5'b01010};
		
		// J-type
		instructionMemory[17] = {JMP, 12'b100011100101};
		instructionMemory[18] = {CALL, 12'b010101111010};
		instructionMemory[19] = {RET, 12'b100101010010};
		
		// S-type
		instructionMemory[20] = {SV, R4, 1'b0, 8'b10100};       
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