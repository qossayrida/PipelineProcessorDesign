module IDStage (
    input clk, 
    input stall,
	input WB_signals,
    input [1:0] ForwardA,
    input [1:0] ForwardB,
	input [4:0] signals, // SRC1   SRC2   RegDst   ExtOp   ExtPlace
    input [15:0] instruction,
	input [15:0] NPC,
	input [15:0] AluResult,MemoryResult,WBResult,
	input [2:0] DestinationRegister,
    output reg [15:0] I_TypeImmediate,
    output reg [15:0] J_TypeImmediate,
    output reg [15:0] ReturnAddress,
    output reg [15:0] Immediate1,
    output reg [15:0] A,
    output reg [15:0] B,
    output reg [2:0] RD2,RA,RB,
	output reg gt,
    output reg lt,
    output reg eq,
);
	
    // Internal wires for extended immediate values
    wire [15:0] extended_imm;
    wire [15:0] BusA, BusB, R7;

    // Instance of the extender module for immediate values
    Extender imm_extender (
        .in(instruction[7:0]),
        .ExtOp(signals[1]),
        .ExtPlace(signals[0]),
        .out(extended_imm)
    );


    // Register file instance
    RegisterFile reg_file (
		.clk(clk),
        .RA(RA),
        .RB(RB),
        .RW(DestinationRegister),
        .enableWrite(WB_signals), 
        .BusW(WBResult),      
        .BusA(BusA),
        .BusB(BusB),
        .R7(R7)
    ); 
	
	
	// Instance of the Compare module
    Compare comp (
        .A(A),
        .B(B),
        .gt(gt),
        .lt(lt),
        .eq(eq)
    ); 
	
	
	assign RA = signals[4] ? 3'b000 : instruction[8:6];	
	assign RB = signals[3] ? instruction[5:3] : instruction[11:9];

    always @(posedge clk) begin
				
		if (signals[2])
			RD2 <= 3'b111;
		else
			RD2 <= instruction[11:9];

		// Decoding immediate values
        I_TypeImmediate <= extended_imm+NPC;
        J_TypeImmediate <= {NPC[15:12],instruction[11:0]};
        ReturnAddress <= R7;


        Immediate1 <= extended_imm;
    end		  
	
	
	always @(posedge clk) begin	
		#2    
        if (ForwardA==0) 
			A <= BusA;
		else if (ForwardA==1)
			A <= AluResult;
		else if (ForwardA==2)
			A <= MemoryResult; 
		else 
			A <= WBResult;
			
				
        if (ForwardB==0) 
			B <= BusB;
		else if (ForwardB==1)
			B <= AluResult;
		else if (ForwardB==2)
			B <= MemoryResult; 
		else 
			B <= WBResult;
	end
	
endmodule
