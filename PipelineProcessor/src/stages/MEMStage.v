module MEMStage (
    input wire clk,
    input wire [15:0] AluResult_MEM,
	input wire [15:0] immediate_MEM,
    input wire [15:0] valueB_MEM, 
	input wire [15:0] PC_MEM,
    input wire [6:0] signals, 	// DataInSrc  MemRd   MemWr  NumOfByte{2}   WBdata{2}
    output reg [15:0] DataWB_MEM
);

    // Internal wires
	wire [15:0] data_in,data_out;
	
	assign data_in = signals[6] ? valueB_MEM : immediate_MEM;
	

    // DataMemory instance
    DataMemory data_memory (
        .clk(clk),
        .wrEnable(signals[4]),
        .rdEnable(signals[5]),
        .numberOfByte(signals[3:2]),
        .address(AluResult_MEM),
        .in(data_in),
        .out(data_out)
    );
	
  	mux_3 #(.LENGTH(16)) mux_MemoryResult (
	    .in1(PC_MEM),
	    .in2(AluResult_MEM),
	    .in3(data_out),
	    .sel(signals[1:0]),
	    .out(DataWB_MEM)
  	);
	

endmodule
