module EXEStage (
    input wire clk,
    input wire [15:0] Immediate1,
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [2:0] signals,		// AluSRC   ALUOP{2}
    output reg [15:0] AluResult 
);

    // Internal wires
    wire signed [15:0] ALU_in_B;
    wire signed [15:0] ALU_output;
	
	// ALU input selection based on ALUsrc
   assign ALU_in_B = signals[2] ? Immediate1 : B;
	
	
    // ALU instance
    ALU alu (
        .A(A),
        .B(ALU_in_B),
        .Output(AluResult),
        .ALUop(signals[1:0])
    );

endmodule




module EXEStage_TB;

    // Inputs
    reg clk;
    reg [15:0] Immediate1;
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] signals;

    // Outputs
    wire [15:0] AluResult;

    // Instantiate the EXEStage
    EXEStage uut (
        .clk(clk),
        .Immediate1(Immediate1),
        .A(A),
        .B(B),
        .signals(signals),
        .AluResult(AluResult)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        Immediate1 = 16'd0;
        A = -16'sd10;
        B = 16'd0;
        signals = 3'b000;

        // Wait for global reset
        #10;

        // Test 1: AND operation with ALUsrc = 0 (use B)
        Immediate1 = 16'd5;
        A = 16'd15;         
        B = -16'sd10;       
        signals = 3'b000;   // ALUop = 00 (AND), ALUsrc = 0
        #10;

        // Test 2: ADD operation with ALUsrc = 0 (use B)
        signals = 3'b001;   // ALUop = 01 (ADD), ALUsrc = 0
        #10;

        // Test 3: SUB operation with ALUsrc = 0 (use B)
        signals = 3'b010;   // ALUop = 10 (SUB), ALUsrc = 0
        #10;

        // Test 4: AND operation with ALUsrc = 1 (use Immediate1)
        signals = 3'b100;   // ALUop = 00 (AND), ALUsrc = 1
        #10;

        // Test 5: ADD operation with ALUsrc = 1 (use Immediate1)
        signals = 3'b101;   // ALUop = 01 (ADD), ALUsrc = 1
        #10;

        // Test 6: SUB operation with ALUsrc = 1 (use Immediate1)
        signals = 3'b110;   // ALUop = 10 (SUB), ALUsrc = 1
        #10;

        // Finish simulation
        $stop;
    end

    // Monitor values
    initial begin
        $monitor("At time %t, A = %d, B = %d, Immediate1 = %d, signals = %b, AluResult = %d",
                 $time, A, B, Immediate1, signals, AluResult);
    end

endmodule

