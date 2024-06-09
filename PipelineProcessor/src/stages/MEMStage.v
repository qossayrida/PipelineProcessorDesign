module MEMStage (
    input wire clk,
    input wire [15:0] AluResult,
	input wire [15:0] Immediate2,
	input wire [15:0] PC2,
    input wire [15:0] DataMemory,
    input wire [6:0] signals, 	// DataInSrc  MemRd   MemWr  NumOfByte{2}   WBdata{2}
    output reg [15:0] DataWB
);

    // Internal wires
	wire [15:0] data_in,data_out;
	
	assign data_in = signals[6] ? DataMemory : Immediate2;
	

    // DataMemory instance
    DataMemory data_memory (
        .clk(clk),
        .wrEnable(signals[4]),
        .rdEnable(signals[5]),
        .numberOfByte(signals[3:2]),
        .address(AluResult),
        .in(data_in),
        .out(data_out)
    );
	
  	mux_3 #(.LENGTH(16)) mux_MemoryResult (
	    .in1(PC2),
	    .in2(AluResult),
	    .in3(data_out),
	    .sel(signals[1:0]),
	    .out(DataWB)
  	);
	
	initial begin
		$monitor("%0t ==> AluResult=%b , data_in= %b   , data_out = %b , imm= %b", $time,AluResult, data_in,data_out,Immediate2);
	end

endmodule
