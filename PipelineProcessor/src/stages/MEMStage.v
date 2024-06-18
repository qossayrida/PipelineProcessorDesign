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



module MEMStage_TB;

    // Test bench signals
    reg clk;
    reg [15:0] AluResult_MEM;
    reg [15:0] immediate_MEM;
    reg [15:0] valueB_MEM;
    reg [15:0] PC_MEM;
    reg [6:0] signals;
    wire [15:0] DataWB_MEM;

    // Instantiate the MEMStage module
    MEMStage mem_stage (
        .clk(clk),
        .AluResult_MEM(AluResult_MEM),
        .immediate_MEM(immediate_MEM),
        .valueB_MEM(valueB_MEM),
        .PC_MEM(PC_MEM),
        .signals(signals),
        .DataWB_MEM(DataWB_MEM)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test cases
    initial begin
        // Initialize inputs
        AluResult_MEM = 16'h0000;
        immediate_MEM = 16'h0000;
        valueB_MEM = 16'h0000;
        PC_MEM = 16'h0000;
        signals = 7'b0000000;
        
        // Test case 1: Write immediate_MEM to memory
        #10;
        AluResult_MEM = 16'h0002;
        immediate_MEM = 16'h1234;
        signals = 7'b0011000; // MemWr, NumOfByte = 2 (16-bit write)
        
        // Test case 2: Read from memory
        #10;
        AluResult_MEM = 16'h0002;
        signals = 7'b0100010; // MemRd, NumOfByte = 0 (16-bit read)

        
        // Test case 3: Write valueB_MEM to memory
        #10;
        AluResult_MEM = 16'h0004;
        valueB_MEM = 16'h5678;
        signals = 7'b1010000; // DataInSrc = valueB_MEM, MemWr, NumOfByte = 0 (16-bit write)
        
        // Test case 4: Read 8-bit value from memory with zero extension
        #10;
        AluResult_MEM = 16'h0004;
        signals = 7'b0100110; // MemRd, NumOfByte = 1 (8-bit read, zero extend)

        
        // Test case 5: Read 8-bit value from memory with sign extension
        #10;
        AluResult_MEM = 16'h0005;
        signals = 7'b0101010; // MemRd, NumOfByte = 2 (8-bit read, sign extend)

        
        // Test case 6: Write immediate_MEM to memory, single byte
        #10;
        AluResult_MEM = 16'h0006;
        immediate_MEM = 16'h00FF;
        signals = 7'b0010100; // MemWr, NumOfByte = 0 (8-bit write)

       
        
        // Stop simulation
        #10;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t,DataWB_MEM: %h", 
            $time,DataWB_MEM);
    end


endmodule

