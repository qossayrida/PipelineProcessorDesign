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
	reg [15:0] data_in,data_out;
	
	
	always @(posedge clk)begin
        if (signals[6]==1)
            data_in = DataMemory;
        else
            data_in = Immediate2;
    end

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

    // Update MemoryResult on clock edge
    always @(posedge clk) begin
	
        if (signals[1:0]==0)
            DataWB <= PC2;
		else if (signals[1:0]==1)
        	DataWB <= AluResult;
		else
			DataWB <= data_out;
    end		
	
	initial begin
		$monitor("%0t ==>  data_in= %b   , DataMemory = %b , imm= %b", $time, data_in,DataMemory,Immediate2);
	end

endmodule
