module MEM2WB (
	input clk,
	input [15:0] DataWB_IN,
	input [2:0] Rd_IN,
	input WB_signal_IN,
	output reg [15:0] DataWB,
	output reg [2:0] Rd,
	output reg  WB_signal
);


  	always @ (posedge clk) begin


	  	DataWB <= DataWB_IN;
		Rd <= Rd_IN;
		WB_signal = WB_signal_IN;

  	end
	  
endmodule