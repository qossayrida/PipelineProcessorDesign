module RegisterFile(
	input clk,
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
        registersArray[1] <= 16'h0001;
        registersArray[2] <= 16'h0003;
        registersArray[3] <= 16'h0000;
        registersArray[4] <= 16'h0000;
        registersArray[5] <= 16'h0002;
        registersArray[6] <= 16'h0007;
        registersArray[7] <= 16'h0002;
    end	 
	
	initial begin
		$monitor("%0t ==> RA=%d , RB=%d, RW=%d",$time,RA, RB, RW);
		$monitor("%0t ==> R3 = %b , R4 = %b , R5 = %b , R6 = %b ,R7 = %b",$time,registersArray[3],registersArray[4],registersArray[5],registersArray[6],registersArray[7]);
	end 

endmodule
