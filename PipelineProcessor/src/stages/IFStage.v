module IFStage (
	input clk, 		   
	input wire [1:0] PCsrc,
	input[15:0] I_TypeImmediate,J_TypeImmediate,ReturnAddress, 
	output reg [15:0] NPC, instruction);
	
	reg [15:0] PC;
		
	initial begin
		PC = 16'd0;
	end	  
  
  	InstructionMemory instructions (
    	.clk(clk),
    	.address(PC),
    	.instruction(instruction)
  	);	
	  
	always @(posedge clk) begin
        case (PCsrc)
            00: begin     
                PC = PC + 16'd2;      
            end  
            01:  begin
				PC = J_TypeImmediate;    
            end  
            10: begin   
                PC = I_TypeImmediate;
            end  
            11: begin
                PC = ReturnAddress;  
            end  
        endcase	 
		NPC =  PC + 16'd2;
	end
  
endmodule 