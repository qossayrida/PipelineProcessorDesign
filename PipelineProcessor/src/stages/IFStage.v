module IFStage (
	input clk, 		   
	input wire [1:0] PCsrc,
	input[WordSize-1:0] I_TypeImmediate,J_TypeImmediate,ReturnAddress, 
	output reg [WordSize-1:0] PC, instruction);


  	PC FindTargetAddress(
  		.clk(clk),
    	.I_TypeImmediate(I_TypeImmediate),
    	.J_TypeImmediate(J_TypeImmediate),
    	.ReturnAddress(ReturnAddress),
		.PCsrc(PCsrc),
    	.PC(PC)
  	);	  
  
  	InstructionMemory instructions (
    	.clk(clk),
    	.address(PC),
    	.instruction(instruction)
  	);
  
endmodule 