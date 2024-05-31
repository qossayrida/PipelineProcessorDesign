module InstructionMemory(
	input wire clk, 
	input wire [15:0] address, 
	output reg [0:15] instruction
);

 
    reg [15:0] instructionMemory [0:255];		  // the size will be 2 ^ 16



    assign instruction = instructionMemory[address[15:0]]; 



    initial begin
        instructionMemory[0] = { ADD, R0, R1, R2,3'b000};       
    end


endmodule