module IFStage (
	input clk,
	input stall,kill,
	input wire [1:0] PCsrc,
	input[15:0] I_TypeImmediate,J_TypeImmediate,ReturnAddress, 
	output reg [15:0] NPC, inst_IF 
);				 
	
	reg [15:0] PC;
	wire [15:0] instruction_wire;	
	
  	InstructionMemory instructions (
		.clk(clk),
		.kill(kill),
		.stall(stall),
    	.address(PC),
    	.instruction(instruction_wire)
  	);
	  
	  
	mux_2 #(.LENGTH(16)) mux_kill (
	    .in1(instruction_wire),
	    .in2({ADD, R1, R1, R0, 3'b000}),
	    .sel(kill),
	    .out(inst_IF)
  	);
	  
	always @(posedge clk) begin
		if (!stall) begin     
            PC <= PC + 16'd2;       
			NPC <= PC + 16'd2; 
		end
	end	
	
	
	always @(*) begin 
		#1fs
		if (!stall) 
		  	case (PCsrc)  
	            1:  begin
					PC = J_TypeImmediate;
					NPC = J_TypeImmediate;
	            end  
	            2: begin   
	                PC = I_TypeImmediate;
					NPC =  I_TypeImmediate;
	            end  
	            3: begin
	                PC = ReturnAddress;
					NPC = ReturnAddress;
	            end  
	        endcase
	end
	
	
	initial begin
		PC = 16'd0;
		NPC = 16'd0;
		$monitor("%0t ==> kill= %b",$time,kill);
		$monitor("%0t ==> I_TypeImmediate= %b",$time,I_TypeImmediate);
		$monitor("%0t ==> J_TypeImmediate= %b",$time,J_TypeImmediate);
		$monitor("%0t ==> NPC= %b",$time,NPC);
		$monitor("%0t ==> PC= %b",$time,PC); 
	end
  
endmodule 	 


module IFStage_TB;

  // Inputs
  reg clk;
  reg stall;
  reg kill;
  reg [1:0] PCsrc;
  reg [15:0] I_TypeImmediate;
  reg [15:0] J_TypeImmediate;
  reg [15:0] ReturnAddress;

  // Outputs
  wire [15:0] NPC;
  wire [15:0] inst_IF;

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
    .inst_IF(inst_IF)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // 10 time units period clock
  end

  // Stimulus
  initial begin
    // Initialize Inputs
    stall = 0;
    kill = 0;
    PCsrc = 0;
    I_TypeImmediate = 16'hA;
    J_TypeImmediate = 16'h0;
    ReturnAddress = 16'h4;

    // Monitor values
    $monitor("Time: %0t | clk: %b | stall: %b | kill: %b | PCsrc: %b | I_TypeImmediate: %h | J_TypeImmediate: %h | ReturnAddress: %h | NPC: %h | inst_IF: %h", 
              $time, clk, stall, kill, PCsrc, I_TypeImmediate, J_TypeImmediate, ReturnAddress, NPC, inst_IF);

    // Test sequence
    #10;
    // Test : Normal operation, no stall, no kill
    #20;

    // Test : Apply stall
    stall = 1;
    #21;
    stall = 0;
    // Test : Change PCsrc to I_TypeImmediate
    PCsrc = 2; 
    kill = 1;
    #21;
    PCsrc = 0;
    kill = 0;
    #21;
    // Test : Change PCsrc to J_TypeImmediate
    PCsrc = 1;
    kill = 1;
    #21;
    PCsrc = 0;
    kill = 0;
    #21
    // Test 6: Change PCsrc to ReturnAddress
    PCsrc = 3;
    kill =1;
    #21;
    PCsrc = 0;
    kill = 0;

    // Test complete
    #50;
    $finish;
  end

endmodule