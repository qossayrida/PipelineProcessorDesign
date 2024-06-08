module IFStage (
	input clk,
	input stall,kill,
	input wire [1:0] PCsrc,
	input[15:0] I_TypeImmediate,J_TypeImmediate,ReturnAddress, 
	output reg [15:0] NPC, instruction );
	
	reg [15:0] PC;
		
	initial begin
		PC = 16'd0;
		
		$monitor("PC = %b",   PC);
	end	
	
	assign NPC = PC + 16'd1;
  
  	InstructionMemory instructions (
		  .clk(clk),
		  .kill(kill),
    	.address(PC),
    	.instruction(instruction)
  	);	
	  
	always @(posedge clk) begin
		if (!stall)
        	case (PCsrc)
            	00: begin     
                	PC = NPC;      
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
	end
  
endmodule 	 


module IFStage_TB;
    // Inputs
    reg clk,stall;
    reg [1:0] PCsrc;
    reg [15:0] I_TypeImmediate;
    reg [15:0] J_TypeImmediate;
    reg [15:0] ReturnAddress;

    // Outputs
    wire [15:0] NPC;
    wire [15:0] instruction;
   

    // Instantiate the Unit Under Test (UUT)
    IFStage uut (
		.clk(clk),
		.stall(stall),
		.kill(kill),
		.PCsrc(PCsrc),
		.I_TypeImmediate(I_TypeImmediate),
		.J_TypeImmediate(J_TypeImmediate),
		.ReturnAddress(ReturnAddress),
		.NPC(NPC),
		.instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        // Monitor changes and display values
        $monitor("At  PCsrc: %b, NPC: %b, Instruction: %b",   PCsrc, NPC, instruction);

        // Initialize inputs
        PCsrc = 2'b00;
        I_TypeImmediate = 16'd4;
        J_TypeImmediate = 16'd8;
        ReturnAddress = 16'd12;

        // Provide stimulus
        #10; // Wait for 10 ns
        PCsrc = 2'b00; // Normal increment
        #10; // Wait for 10 ns
        PCsrc = 2'b01; // Jump type immediate
        #10; // Wait for 10 ns
        PCsrc = 2'b10; // I-Type immediate
        #10; // Wait for 10 ns
        PCsrc = 2'b11; // Return address
        #10; // Wait for 10 ns
        
        // Finish simulation
        $finish;
    end

endmodule