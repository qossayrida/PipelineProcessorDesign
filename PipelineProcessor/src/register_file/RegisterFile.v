module RegisterFile(
	input wire clk, 
	input wire [2:0] RA, RB, RW, 
	input wire enableWrite, 
	input wire [15:0] BusW , 
	output reg [15:0] BusA, BusB,
	output reg [15:0] R7
);


    reg [15:0] registersArray [0:7];
   
	
    // read registers always
    always @(posedge clk) begin
        BusA = registersArray[RA];
        BusB = registersArray[RB];
		R7 = registersArray[7];
    end

    always @(posedge clk) begin
        if (enableWrite && (RW != 3'b000)) begin 
            registersArray[RW] = BusW;
        end
    end

    initial begin
        registersArray[0] <= 16'h0000;
        registersArray[1] <= 16'h0000;
        registersArray[2] <= 16'h0000;
        registersArray[3] <= 16'h0000;
        registersArray[4] <= 16'h0000;
        registersArray[5] <= 16'h0000;
        registersArray[6] <= 16'h0000;
        registersArray[7] <= 16'h0000;
    end

endmodule
