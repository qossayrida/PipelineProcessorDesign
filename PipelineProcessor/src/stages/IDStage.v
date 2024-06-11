module IDStage (
    input clk, 	
    input [1:0] ForwardA,
    input [1:0] ForwardB,
	input WB_signals,
	input [5:0] signals, // SRC1   SRC2   RegDst   ExtOp   ExtPlace
    input [15:0] inst_ID,
	input [15:0] PC_ID,
	input [15:0] AluResult_EXE,DataWB_MEM,DataWB_WB,
	input [2:0] DestinationRegister,
    output reg [15:0] I_TypeImmediate,
    output reg [15:0] J_TypeImmediate,
    output reg [15:0] ReturnAddress,
    output reg [15:0] immediate_ID,
    output reg [15:0] valueA_ID,
    output reg [15:0] valueB_ID,
    output reg [2:0] Rd_ID,Ra_ID,Rb_ID,
	output reg gt,
    output reg lt,
    output reg eq,
);


    // Internal wires for extended immediate values
    wire [15:0] extended_imm;
    wire [15:0] BusA, BusB;
	
	
	assign Ra_ID =  (signals[5:4]==2'b01) ? 3'b000 :
					(signals[5:4]==2'b01) ? inst_ID[8:6] :
					(signals[5:4]==2'b10) ? 3'b111 :3'bxxx ;	   
	
	assign Rb_ID = signals[3] ? inst_ID[5:3] : inst_ID[11:9];
	assign Rd_ID = signals[2] ? 3'b111  : inst_ID[11:9];

    // Instance of the extender module for immediate values
    Extender imm_extender (
        .in(inst_ID[7:0]),
        .ExtOp(signals[1]),
        .ExtPlace(signals[0]),
        .out(extended_imm)
    );


    // Register file instance
    RegisterFile reg_file (
		.clk(clk),
        .RA(Ra_ID),
        .RB(Rb_ID),
        .RW(DestinationRegister),
        .enableWrite(WB_signals), 
        .BusW(DataWB_WB),      
        .BusA(BusA),
        .BusB(BusB)
    ); 
	
	
    assign    I_TypeImmediate = extended_imm+PC_ID-1;
    assign    J_TypeImmediate = {PC_ID[15:12],inst_ID[11:0]};
    assign    ReturnAddress = valueA_ID;
    assign    immediate_ID = extended_imm;
	  	
	mux_4 #(.LENGTH(16)) mux_ForwardA (
    .in1(BusA),
    .in2(AluResult_EXE),
    .in3(DataWB_MEM),
	.in4(DataWB_WB),
    .sel(ForwardA),
    .out(valueA_ID)
  );
  
  
  mux_4 #(.LENGTH(16)) mux_ForwardB (
    .in1(BusB),
    .in2(AluResult_EXE),
    .in3(DataWB_MEM),
	.in4(DataWB_WB),
    .sel(ForwardB),
    .out(valueB_ID)
  );
  
  // Instance of the Compare module
    Compare comp (
        .A(valueA_ID),
        .B(valueB_ID),
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
