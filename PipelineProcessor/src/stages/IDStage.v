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
	input [2:0] RD4,
    output reg [15:0] I_TypeImmediate,
    output reg [15:0] J_TypeImmediate,
    output reg [15:0] ReturnAddress,
    output reg [15:0] PC1,
    output reg [15:0] Immediate1,
    output reg [15:0] A,
    output reg [15:0] B,
    output reg [2:0] RD2,
	output reg gt,
    output reg lt,
    output reg eq
);

	reg [2:0] RA,RB;
	
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
        .RA(RA),
        .RB(RB),
        .RW(RD4),
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

    always @(posedge clk) begin
		
		if (signals[4])
			RA <= 3'b000;
		else
			RA <= instruction[8:6];	  
			
			
	    if (signals[3])
			RB <= instruction[5:3];
		else
			RB <= instruction[11:9];
			
		
		if (signals[2])
			RD2 <= 3'b111;
		else
			RD2 <= instruction[11:9];

				
        // Decoding immediate values
        I_TypeImmediate <= extended_imm+NPC;
        J_TypeImmediate <= {NPC[15:12],instruction[11:0]};
        ReturnAddress <= R7;

        // Output control signals
        PC1 <= NPC;
        Immediate1 <= extended_imm;
    end		  
	
	
	always @(*) begin	
		     
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


module IDStage_TB;

    reg clk;
    reg stall;
	reg WB_signals;
    reg [1:0] ForwardA;
    reg [1:0] ForwardB;
    reg [4:0] signals;
    reg [15:0] instruction;
    reg [15:0] NPC;
    reg [15:0] AluResult;
    reg [15:0] MemoryResult;
    reg [15:0] WBResult;
    reg [2:0] RD4;
    
    wire [15:0] I_TypeImmediate;
    wire [15:0] J_TypeImmediate;
    wire [15:0] ReturnAddress;
    wire [15:0] PC1;
    wire [15:0] Immediate1;
    wire [15:0] A;
    wire [15:0] B;
    wire [2:0] RD2;
    wire gt;
    wire lt;
    wire eq;

    IDStage uut (
        .clk(clk),
        .stall(stall),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .WB_signals(WB_signals),
        .signals(signals),
        .instruction(instruction),
        .NPC(NPC),
        .AluResult(AluResult),
        .MemoryResult(MemoryResult),
        .WBResult(WBResult),
        .RD4(RD4),
        .I_TypeImmediate(I_TypeImmediate),
        .J_TypeImmediate(J_TypeImmediate),
        .ReturnAddress(ReturnAddress),
        .PC1(PC1),
        .Immediate1(Immediate1),
        .A(A),
        .B(B),
        .RD2(RD2),
        .gt(gt),
        .lt(lt),
        .eq(eq)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize inputs
        stall = 0;
        ForwardA = 0;
        ForwardB = 0;
        WB_signals = 0;
        signals = 5'b00000;
        instruction = 16'b0000000000000000;
        NPC = 16'b0000000000000000;
        AluResult = 16'b0000000000000000;
        MemoryResult = 16'b0000000000000000;
        WBResult = 16'b0000000000000000;
        RD4 = 3'b000;

        // Apply some test vectors
        #10 instruction = 16'b0000001100100011; NPC = 16'b0000000000000010; WBResult = 16'b0000000000001000; WB_signals = 1;
        #10 ForwardA = 1; AluResult = 16'b0000000000001010;
        #10 ForwardB = 2; MemoryResult = 16'b0000000000001100;
        #10 ForwardA = 3; 
		#1WBResult = 16'b0000000000001110;
        #9 ForwardB = 3;
        #10 signals = 5'b11010; instruction = 16'b0000001100110001;
        #10 RD4 = 3'b011; instruction = 16'b0000010001100011;

        // End simulation
        #100 $finish;
    end

    initial begin
        // Monitor the changes
        $monitor("Time = %0d, A = %0h, B = %0h, I_TypeImmediate = %0h, J_TypeImmediate = %0h, ReturnAddress = %0h, PC1 = %0h, Immediate1 = %0h, RD2 = %0h, gt = %0b, lt = %0b, eq = %0b", 
                  $time, A, B, I_TypeImmediate, J_TypeImmediate, ReturnAddress, PC1, Immediate1, RD2, gt, lt, eq);
    end

endmodule
