module RegisterFile(
	input clk,
	input wire [2:0] RA, RB, RW, 
	input wire enableWrite, 
	input wire [15:0] BusW , 
	output reg [15:0] BusA, BusB
);


    reg [15:0] registersArray [0:7];
   
	
    // read registers always


    always @(negedge clk) begin
        if (enableWrite && (RW != 3'b000)) begin 
            registersArray[RW] = BusW;
        end
    end
	
	
    assign  BusA = registersArray[RA];
    assign  BusB = registersArray[RB];
	assign	R7 = registersArray[7];
  

    initial begin
        registersArray[0] <= 16'h0000;
        registersArray[1] <= 16'h0001;
        registersArray[2] <= 16'h0003;
        registersArray[3] <= 16'h0000;
        registersArray[4] <= 16'h0000;
        registersArray[5] <= 16'h0002;
        registersArray[6] <= 16'h0007;
        registersArray[7] <= 16'h0002;
    end	 
	
	initial begin
		$monitor("%0t  ==> R0=%b  ,  R1=%b  ,  R2=%b  ,  R3=%b ",$time,registersArray[0],registersArray[1],registersArray[2],registersArray[3]);  
		$monitor("%0t  ==> R4=%b  ,  R5=%b  ,  R6=%b  ,  R7=%b ",$time,registersArray[4],registersArray[5],registersArray[6],registersArray[7]);
	end 

endmodule 

module RegisterFile_TB;

    // Inputs
    reg clk;
    reg [2:0] RA;
    reg [2:0] RB;
    reg [2:0] RW;
    reg enableWrite;
    reg [15:0] BusW;

    // Outputs
    wire [15:0] BusA;
    wire [15:0] BusB;

    // Instantiate the Unit Under Test (UUT)
    RegisterFile uut (
        .clk(clk),
        .RA(RA),
        .RB(RB),
        .RW(RW),
        .enableWrite(enableWrite),
        .BusW(BusW),
        .BusA(BusA),
        .BusB(BusB)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    initial begin
        // Initialize Inputs
        RA = 0;
        RB = 0;
        RW = 0;
        enableWrite = 0;
        BusW = 0;

        // Wait for global reset to finish
        #10;
        
        // Test sequence

        // Read initial values
        RA = 3'b000; RB = 3'b001; #10; // Read R0 and R1
        RA = 3'b010; RB = 3'b011; #10; // Read R2 and R3
        RA = 3'b100; RB = 3'b101; #10; // Read R4 and R5
        RA = 3'b110; RB = 3'b111; #10; // Read R6 and R7

        // Write to registers
        enableWrite = 1;
        RW = 3'b001; BusW = 16'hAAAA; #10; // Write 0xAAAA to R1
        RW = 3'b010; BusW = 16'hBBBB; #10; // Write 0xBBBB to R2
        RW = 3'b011; BusW = 16'hCCCC; #10; // Write 0xCCCC to R3
        RW = 3'b100; BusW = 16'hDDDD; #10; // Write 0xDDDD to R4
        RW = 3'b111; BusW = 16'hEEEE; #10; // Write 0xEEEE to R7

        // Disable writing
        enableWrite = 0;
        
        // Read back written values
        RA = 3'b001; RB = 3'b010; #10; // Read R1 and R2
        RA = 3'b011; RB = 3'b100; #10; // Read R3 and R4
        RA = 3'b000; RB = 3'b111; #10; // Read R0 and R7

        // End of simulation
        $finish;
    end

    // Display register file contents for debugging
    initial begin
        $monitor("At time %t, RA = %b, BusA = %h, RB = %b, BusB = %h", $time, RA, BusA, RB, BusB);
    end

endmodule

