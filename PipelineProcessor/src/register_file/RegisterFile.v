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
