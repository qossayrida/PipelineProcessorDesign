module IDStage (
    input clk, 
    input stall,
    input ForwardA,
    input ForwardB,
	input [4:0] signals, // SRC1   SRC2   RegDst   ExtOp   ExtPlace
    input [15:0] instruction,
	input [15:0] NPC,
    output reg [15:0] I_TypeImmediate,
    output reg [15:0] J_TypeImmediate,
    output reg [15:0] ReturnAddress,
    output reg [15:0] PC1,
    output reg [15:0] Immediate1,
    output reg [15:0] A,
    output reg [15:0] B,
    output reg [2:0] RD2,
	output reg gt,
    output reg lt,
    output reg eq
);

	wire [2:0] RD = instruction[11:9];
    wire [2:0] RS1 = instruction[8:6];
    wire [2:0] RS2 = instruction[5:3];

    // Internal wires for extended immediate values
    wire [15:0] extended_imm;
    wire [15:0] BusA, BusB, R7;

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
        .RA(RS1),
        .RB(RS2),
        .RW(RD),
        .enableWrite(1'b0), // Assuming no writes in ID stage
        .BusW(16'b0),       // No data to write
        .BusA(BusA),
        .BusB(BusB),
        .R7(R7)
    ); 
	
	
	// Instance of the Compare module
    Compare comp (
        .A(A),
        .B(B),
        .gt(gt),
        .lt(lt),
        .eq(eq)
    );

    always @(posedge clk) begin
        if (!stall) begin
            // Fetch values from register file
            A <= BusA;
            B <= BusB;

            // Forwarding logic (simplified)
            if (ForwardA) A <= Immediate1;
            if (ForwardB) B <= Immediate1;

				
            // Decoding immediate values
            I_TypeImmediate <= extended_imm+NPC;
            J_TypeImmediate <= {NPC[15:12],instruction[11:0]};
            ReturnAddress <= R7;

            // Output control signals
            PC1 <= NPC;
            Immediate1 <= extended_imm;
            RD2 <= RD;
        end
    end
	
endmodule
