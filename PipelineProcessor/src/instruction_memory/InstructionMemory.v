module InstructionMemory(
	input wire clk,kill,stall, 
	input wire [15:0] address, 
	output reg [0:15] instruction
);

 
    reg [15:0] instructionMemory [0:255];		  // the size will be 2 ^ 16


	always @(posedge clk) begin
			
		if (!stall)
			instruction <= instructionMemory[address[15:0]];
			
	end 

    initial begin
		
//  	Program 1		
        instructionMemory[0] = {AND, R4, R6, R7, 3'b000};
    	instructionMemory[1] = {ADD, R6, R4, R2, 3'b000};
    	instructionMemory[2] = {SUB, R5, R3, R5, 3'b000}; 
		instructionMemory[3] = {SV , R1, 1'b0 , 8'hFF};
		instructionMemory[4] = {LBu , R7, R0 ,1'b0, 5'h01};
		instructionMemory[5] = {RET , 3'b000,3'b111 ,6'b000000};
		
//		instructionMemory[5] = {CALL , 12'h008};
//		instructionMemory[6] = {LW , R3, R0 ,1'b0, 5'b00001}; 
//		instructionMemory[7] = {LW , R4, R1 ,1'b0, 5'b00000};
//		instructionMemory[8] = {SW , R4, R2 ,1'b0, 5'b00000};
//		instructionMemory[9] = {ADD, R4, R6, R7, 3'b000}; 
//		instructionMemory[10] = {RET , 3'b000,3'b111 ,6'b000000};

//  	Program 2		
//		instructionMemory[0] = {AND, R4, R6, R7, 3'b000};
//		instructionMemory[1] = {JMP, 12'h00A};		
//		instructionMemory[2] = {SUB, R5, R3, R5, 3'b000}; 
//		instructionMemory[3] = {SV , R1, 1'b0 , 8'hFF};
//		instructionMemory[4] = {LBu , R3, R0 ,1'b0, 5'h01};		
//		instructionMemory[10] = {LBs , R3, R1 ,1'b1, 5'h00};
//		instructionMemory[11] = {ADD , R3, R3,R2 ,3'b000};


//  	Program 3
//	   	instructionMemory[0] = {AND, R4, R6, R7, 3'b000};
//      instructionMemory[1] = {JMP, 12'h00A};
//      instructionMemory[2] = {SUB, R5, R3, R5, 3'b000}; 
//      instructionMemory[3] = {SV , R1, 1'b0 , 8'hFF};
//		instructionMemory[4] = {LBu , R3, R0 ,1'b0, 5'h01};	
//      instructionMemory[10] = {AND, R4, R6, R7, 3'b000};
//      instructionMemory[11] = {BEQ , R4, R4 ,1'b0,5'h03};
//      instructionMemory[12] = {AND, R4, R6, R7, 3'b000};
//      instructionMemory[14] = {ADD , R3, R3,R2 ,3'b000};

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