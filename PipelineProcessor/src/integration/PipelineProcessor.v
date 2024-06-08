module PipelineProcessor ();
	
	initial begin
        #150 $finish; 
    end				 
	

	
	
	
	//******************************************************
	//						 clock 		
	//******************************************************
	
	wire clk;		
	
	ClockGenerator clock( 
		.clk(clk)
	);
	
	//******************************************************
	//					   registers		
	//****************************************************** 
	
	wire [15:0] inst_IF, inst_ID;
	wire [15:0] PC_IF, PC_ID, PC_EXE,PC_MEM;
	
    
	wire [15:0] valueA_ID, valueA_EXE;
	wire [15:0] valueB_ID, valueB_EXE,valueB_MEM;
	wire [15:0] immediate_ID , immediate_EXE,immediate_MEM;
	wire [2:0] Rd_ID,Rd_EXE,Rd_MEM,Rd_WB;
	
	wire [15:0] AluResult_EXE,AluResult_MEM;
	
	
	wire [15:0] DataWB_MEM,DataWB_WB;
	
	wire stall, GT, LT, EQ, kill;
	wire [1:0] PcSrc,ForwardA, ForwardB;
	
	
    wire [15:0] signals;
	wire [10:0] EXE_signals;
	wire [7:0]  MEM_signals;
	wire WB_signals; 
	

	wire [15:0] I_TypeImmediate, J_TypeImmediate, ReturnAddress;
	
	

	
	
	
	
	//******************************************************
	//					 Control unit		
	//******************************************************

    // Control Unit
    MainAluControl main_alu_control (
        .opCode(inst_ID[15:12]),
        .mode(inst_ID[5]),
        .stall(stall),
        .signlas(signals)
    );

    // PC Control
    PcControl pc_control (
        .opCode(inst_ID[15:12]),
        .stall(stall),
        .GT(GT),
        .LT(LT),
        .EQ(EQ),
        .PcSrc(PcSrc),
        .kill(kill)
    );

    // Hazard Detection
    HazardDetect hazard_detect (
		.clk(clk),
        .opCode(inst_ID[15:12]),
        .RS1(RA), 
        .RS2(RB),  
        .Rd2(RD2),
        .Rd3(RD3),
        .Rd4(RD4),
        .EX_RegWr(EXE_signals[0]),
        .MEM_RegWr(MEM_signals[0]),
        .WB_RegWr(WB_signals),
        .EX_MemRd(EXE_signals[6]),
        .stall(stall),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
	
	
	//******************************************************
	//					 Pipeline IF stages		
	//******************************************************
	 
	
	// IF Stage
    IFStage if_stage (
	.clk(clk),
	.stall(stall),
	.kill(kill),
    .PCsrc(PcSrc),
    .I_TypeImmediate(I_TypeImmediate),
    .J_TypeImmediate(J_TypeImmediate),
    .ReturnAddress(ReturnAddress),
    .NPC(PC_IF),
    .instruction(inst_IF)
    );	   
	
	IF2ID IF2ID_registers (
		.clk(clk),
		.stall(stall),
		.PCIN(PC_IF),
		.instructionIN(inst_IF),
		
		//output
		.PC(PC_ID),
		.instruction(inst_ID)
	);
	
	
	
	//******************************************************
	//					 Pipeline ID stages		
	//******************************************************
	
	
	IDStage id_stage (
        .clk(clk), 
        .stall(stall),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .WB_signals(WB_signals),
        .signals(signals[15:11]), // Passing relevant bits of signals
        .instruction(inst_ID),
        .NPC(PC_ID),
        .AluResult(AluResult_EXE),
        .MemoryResult(DataWB_MEM), 
        .WBResult(DataWB_WB), 
        .DestinationRegister(Rd_WB),
        .I_TypeImmediate(I_TypeImmediate),
        .J_TypeImmediate(J_TypeImmediate),
        .ReturnAddress(ReturnAddress),
        .Immediate1(immediate_ID),
        .A(valueA_ID),
        .B(valueB_ID),
        .RD2(Rd_ID),
		.RA(RA),
		.RB(RB),
        .gt(GT),
        .lt(LT),
        .eq(EQ)
    );
	
	ID2EXE ID2EXE_registers (
		.clk(clk),
		.stall(stall),
		.valueAIN(valueA_ID) ,
		.valueBIN(valueB_ID),
		.immIN(immediate_ID),
		.PCIN(PC_ID),
		.RdIN(Rd_ID),
		.EXE_signals_IN(signals[10:0]),
		
		// output
		.valueA(valueA_EXE),
		.valueB(valueB_EXE),
		.imm(immediate_EXE),
		.PC(PC_EXE),
		.Rd(Rd_EXE),
		.EXE_signals(EXE_signals)
	);	  
		
	//******************************************************
	//					Pipeline EXE stages		
	//******************************************************
	
	EXEStage exe_stage (
		.clk(clk),
        .Immediate1(immediate_EXE),
        .A(valueA_EXE),
        .B(valueB_EXE),
        .signals(EXE_signals[10:8]),
        .AluResult(AluResult_EXE)
    ); 
	
	EXE2MEM EXE2MEM_registers (
		.clk(clk),
		.valueFromALU_IN(AluResult_EXE),
		.valueFromReg_IN(valueB_EXE),
		.immIN(immediate_EXE),
		.PCIN(PC_EXE),
		.RdIN(Rd_EXE),
		.MEM_signals_IN(EXE_signals[7:0]),
		
		// output
		.valueFromALU(AluResult_MEM),
		.valueFromReg(valueB_MEM),
		.imm(immediate_MEM),
		.PC(PC_MEM),
		.Rd(Rd_MEM),
		.MEM_signals(MEM_signals)
	);
	
	
	
	//******************************************************
	//					Pipeline MEM stages		
	//****************************************************** 
	
	
	MEMStage mem_stage (
        .clk(clk),
        .AluResult(AluResult),
        .Immediate2(Immediate2),
        .PC2(PC2),
        .DataMemory(DataMemory),
        .signals(MEM_signals[7:1]),
        .DataWB(DataWB_MEM)
    );	
	
	MEM2WB MEM2WB_registers(
	.clk(clk),
	.DataWB_IN(DataWB_MEM),
	.Rd_IN(Rd_MEM),
	.WB_signal_IN(MEM_signals[0]),
	.DataWB(DataWB_WB),
	.Rd(Rd_WB),
	.WB_signal(WB_signals)
	);
	
	
endmodule