module IDStage (
    input clk, 
    input stall,
	input WB_signals,
    input [1:0] ForwardA,
    input [1:0] ForwardB,
	input [4:0] signals, // SRC1   SRC2   RegDst   ExtOp   ExtPlace
    input [15:0] instruction,
	input [15:0] PC_ID,
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
	
	
	assign RA = signals[4] ? 3'b000 : instruction[8:6];	
	assign RB = signals[3] ? instruction[5:3] : instruction[11:9];
	assign RD2 = signals[2] ? 	3'b111  : instruction[11:9];

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
	
	
    assign    I_TypeImmediate = extended_imm+PC_ID-1;
    assign    J_TypeImmediate = {PC_ID[15:12],instruction[11:0]};
    assign    ReturnAddress = R7;
    assign    Immediate1 = extended_imm;
	  	
	mux_4 #(.LENGTH(16)) mux_ForwardA (
    .in1(BusA),
    .in2(AluResult),
    .in3(MemoryResult),
	.in4(WBResult),
    .sel(ForwardA),
    .out(A)
  );
  
  
  mux_4 #(.LENGTH(16)) mux_ForwardB (
    .in1(BusB),
    .in2(AluResult),
    .in3(MemoryResult),
	.in4(WBResult),
    .sel(ForwardB),
    .out(B)
  );
  
  // Instance of the Compare module
    Compare comp (
        .A(A),
        .B(B),
        .gt(gt),
        .lt(lt),
        .eq(eq)
    ); 
	
	
	initial begin

		$monitor("%0t ==> I_TypeImmediate from decode= %b",$time,I_TypeImmediate); 
		$monitor("%0t ==> J_TypeImmediate from decode= %b",$time,J_TypeImmediate);
		$monitor("%0t ==> PC_ID = %b",$time,PC_ID);
		$monitor("%0t ==> extended_imm= %b",$time,extended_imm); 
	end
	
	
endmodule
