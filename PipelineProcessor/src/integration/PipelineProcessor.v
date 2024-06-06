module PipelineProcessor ();
	
	initial begin		 
        #400 $finish; 
    end			
	
	
	
	//******************************************************
	//					clock & registers		
	//******************************************************
	
	wire clk;		
	
	ClockGenerator clock( 
		.clk(clk)
	);
	
	//******************************************************
	//					   registers		
	//******************************************************
	
    
	wire [15:0] instruction, I_TypeImmediate, J_TypeImmediate, ReturnAddress;
	wire stall, GT, LT, EQ, PcSrc, kill;
	wire [1:0] ForwardA, ForwardB;
    wire [15:0] signals;
	wire [10:0] EXE_signals;
	wire [7:0]  MEM_signals;
	wire WB_signals; 
	

	wire [15:0] NPC,PC1,PC2;
	wire [15:0] DataWB;
	wire [2:0] RD2,RD3,RD4;
	wire [15:0] Immediate1 , Immediate2 , A , B ;
	
	
	
	
	//******************************************************
	//					 Control unit		
	//******************************************************

    // Control Unit
    MainAluControl main_alu_control (
        .opCode(instruction[15:12]),
        .mode(instruction[5]),
        .stall(stall),
        .signlas(signals)
    );

    // PC Control
    PcControl pc_control (
        .opCode(instruction[15:12]),
        .stall(stall),
        .GT(GT),
        .LT(LT),
        .EQ(EQ),
        .PcSrc(PcSrc),
        .kill(kill)
    );

    // Hazard Detection
    HazardDetect hazard_detect (
        .opCode(instruction[15:12]),
        .RS1(instruction[11:9]), // Assuming RS1 is bits 11-9
        .RS2(instruction[8:6]),  // Assuming RS2 is bits 8-6
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
        .PCsrc(PcSrc),
        .I_TypeImmediate(I_TypeImmediate),
        .J_TypeImmediate(J_TypeImmediate),
        .ReturnAddress(ReturnAddress),
        .NPC(NPC),
        .instruction(instruction)
    );
	
	
	//******************************************************
	//					 Pipeline ID stages		
	//******************************************************
	
	
	
	
	//******************************************************
	//					Pipeline EXE stages		
	//******************************************************
	
	
	
	//******************************************************
	//					Pipeline MEM stages		
	//****************************************************** 
	
	
	
	
	
	
	//******************************************************
	//					 Pipeline WB stages		
	//******************************************************
	
	
endmodule