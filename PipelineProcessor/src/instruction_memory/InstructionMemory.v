module InstructionMemory(
	input wire clk,kill,stall, 
	input wire [15:0] address, 
	output reg [0:15] instruction
);

 
    reg [7:0] instructionMemory [0:255];		  // the size will be 2 ^ 16


	always @(posedge clk) begin
			
		if (!stall)
			instruction <= {instructionMemory[address + 1], instructionMemory[address]};
			
	end 

    initial begin	
		
		// ******************************************************************************
		// ******************************************************************************
		//					  	  		Courtesy of Dr. Aziz
		//				We change the format for I-type instruction as follows
		// 			
		//			  [15-12] Opcode , [11-9] Rd , [8-6] Rs1 , [5] M , [4-0] Imm 
		// ******************************************************************************
		// ****************************************************************************** 
		
		{instructionMemory[1],instructionMemory[0]} = {LW, R1, R0, 1'b0, 5'b00001}; // Load memory[1:2] into R1
		{instructionMemory[3],instructionMemory[2]} = {LW, R2, R0, 1'b0, 5'b00011}; // Load memory[3:4] into R2
		{instructionMemory[5],instructionMemory[4]} = {ADD, R3, R1, R2, 3'b000};   // R3 = R1 + R2
		{instructionMemory[7],instructionMemory[6]} = {SW, R3, R0, 1'b0, 5'b00101}; // Store R3 in memory[5:6]
		
//		{instructionMemory[1],instructionMemory[0]}   = {AND, R4, R6, R7, 3'b000};
//        {instructionMemory[3],instructionMemory[2]}   = {ADD, R6, R4, R2, 3'b000};
//        {instructionMemory[5],instructionMemory[4]}   = {SUB, R5, R3, R5, 3'b000}; 
//        {instructionMemory[7],instructionMemory[6]}   = {SV , R1, 1'b0 , 8'hFF};
//        {instructionMemory[9],instructionMemory[8]}   = {LW , R7, R0 ,1'b0, 5'h01};
//        {instructionMemory[11],instructionMemory[10]} = {CALL , 12'h010};
//        {instructionMemory[13],instructionMemory[12]} = {LW , R3, R0 ,1'b0, 5'b00001}; 
//        {instructionMemory[15],instructionMemory[14]} = {LW , R4, R1 ,1'b0, 5'b00000};
//        {instructionMemory[17],instructionMemory[16]} = {SW , R4, R2 ,1'b0, 5'b00000};
//        {instructionMemory[19],instructionMemory[18]} = {ADD, R4, R6, R7, 3'b000}; 
//		{instructionMemory[21],instructionMemory[20]} = {RET , 12'h000};
			

//  	Program 2		
//		{instructionMemory[1],instructionMemory[0]}   = {AND, R4, R6, R7, 3'b000};
//		{instructionMemory[3],instructionMemory[2]}   = {JMP, 12'h00A};		
//		{instructionMemory[5],instructionMemory[4]}   = {SUB, R5, R3, R5, 3'b000}; 
//		{instructionMemory[7],instructionMemory[6]}   = {SV , R1, 1'b0 , 8'hFF};
//		{instructionMemory[9],instructionMemory[8]}   = {LBu , R3, R0 ,1'b0, 5'h01};		
//		{instructionMemory[11],instructionMemory[10]} = {LBs , R3, R1 ,1'b1, 5'h00};
//		{instructionMemory[13],instructionMemory[12]} = {ADD , R3, R3,R2 ,3'b000};


//  	Program 3
//	   	{instructionMemory[1],instructionMemory[0]}   = {AND, R4, R6, R7, 3'b000};
//      {instructionMemory[3],instructionMemory[2]}   = {JMP, 12'h00A};
//      {instructionMemory[5],instructionMemory[4]}   = {SUB, R5, R3, R5, 3'b000}; 
//      {instructionMemory[7],instructionMemory[6]}   = {SV , R1, 1'b0 , 8'hFF};
//		{instructionMemory[9],instructionMemory[8]}   = {LBu , R3, R0 ,1'b0, 5'h01};	
//      {instructionMemory[11],instructionMemory[10]} = {AND, R4, R6, R7, 3'b000};
//      {instructionMemory[13],instructionMemory[12]} = {BEQ , R4, R4 ,1'b0,5'h03};
//      {instructionMemory[15],instructionMemory[14]} = {AND, R4, R6, R7, 3'b000};
//      {instructionMemory[17],instructionMemory[16]} = {ADD , R3, R3,R2 ,3'b000};

    end

endmodule


module InstructionMemory_TB;

    // Inputs
    reg clk;
    reg kill;
    reg stall;
    reg [15:0] address;

    // Outputs
    wire [15:0] instruction;

    // Instantiate the Unit Under Test (UUT)
    InstructionMemory uut (
        .clk(clk),
        .kill(kill),
        .stall(stall),
        .address(address),
        .instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    initial begin
        // Initialize Inputs
        kill = 0;
        stall = 0;
        address = 0;

        // Wait for global reset to finish
        #10;

        // Test sequence
        address = 16'h0000; #10; // Expecting first instruction
        address = 16'h0002; #10; // Expecting second instruction
        address = 16'h0004; #10; // Expecting third instruction
        address = 16'h0006; #10; // Expecting fourth instruction
        address = 16'h0008; #10; // Expecting fifth instruction
        address = 16'h000A; #10; // Expecting sixth instruction
        address = 16'h000C; #10; // Expecting seventh instruction
        address = 16'h000E; #10; // Expecting eighth instruction
        address = 16'h0010; #10; // Expecting ninth instruction
        address = 16'h0012; #10; // Expecting tenth instruction

        // Test stall signal
        stall = 1;
        address = 16'h0014; #10; // No change in instruction
        stall = 0; #10; // Fetch new instruction

        // End of simulation
        $finish;
    end

    // Display instruction output for debugging
    initial begin
        $monitor("At time %t, Address = %h, Instruction = %h", $time, address, instruction);
    end

endmodule


