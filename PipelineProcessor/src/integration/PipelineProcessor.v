module PipelineProcessor ();
	
	initial begin
        #170 $finish; 
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
	
	wire [2:0] Ra_ID,Rb_ID;
	
	wire [15:0] AluResult_EXE,AluResult_MEM;
	
	
	wire [15:0] DataWB_MEM,DataWB_WB;
	
	wire stall, GT, LT, EQ, kill;
	wire [1:0] PcSrc,ForwardA, ForwardB;
	
	
    wire [16:0] signals;
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
		.Rd(inst_ID[11:9]),
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
        .opCode(inst_ID[15:12]),
        .RS1(Ra_ID), 
        .RS2(Rb_ID),  
        .Rd2(Rd_EXE),
        .Rd3(Rd_MEM),
        .Rd4(Rd_WB),
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
    .inst_IF(inst_IF)
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
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .WB_signals(WB_signals),
        .signals(signals[16:11]), // Passing relevant bits of signals
        .inst_ID(inst_ID),
        .PC_ID(PC_ID),
        .AluResult_EXE(AluResult_EXE),
        .DataWB_MEM(DataWB_MEM), 
        .DataWB_WB(DataWB_WB), 
        .DestinationRegister(Rd_WB),
        .I_TypeImmediate(I_TypeImmediate),
        .J_TypeImmediate(J_TypeImmediate),
        .ReturnAddress(ReturnAddress),
        .immediate_ID(immediate_ID),
        .valueA_ID(valueA_ID),
        .valueB_ID(valueB_ID),
        .Rd_ID(Rd_ID),
		.Ra_ID(Ra_ID),
		.Rb_ID(Rb_ID),
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
        .immediate_EXE(immediate_EXE),
        .valueA_EXE(valueA_EXE),
        .valueB_EXE(valueB_EXE),
        .signals(EXE_signals[10:8]),
        .AluResult_EXE(AluResult_EXE)
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
        .AluResult_MEM(AluResult_MEM),
        .immediate_MEM(immediate_MEM),
		.valueB_MEM(valueB_MEM),
        .PC_MEM(PC_MEM),
        .signals(MEM_signals[7:1]),
        .DataWB_MEM(DataWB_MEM)
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