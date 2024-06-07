module WBStage (
	input clk, 		   
	input [15:0] DataWB,
	input [2:0] RD4, 
	output reg [15:0] DataBus,
	output reg [2:0] DestinationRegister);
	  
	always @(posedge clk) begin
		DataBus	 <=	  DataWB ;
		DestinationRegister  <= RD4;
	end
  
endmodule 