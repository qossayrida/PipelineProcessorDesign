module ID2EXE (
	input clk,stall, 
	input [15:0] valueAIN, valueBIN, immIN, PCIN, 
	input [2:0] RdIN,
	input [10:0] EXE_signals_IN,
	output reg [15:0] valueA, valueB , imm,	PC, 
	output reg [2:0] Rd,
	output reg [10:0] EXE_signals
);


  	always @ (posedge clk) begin

      	if (stall) begin
          	EXE_signals <= 0;
      	end
	  	else begin
		  	valueA <= valueAIN;
			valueB <= valueBIN;
		  	imm	<=  immIN;
			PC <= PCIN;
			Rd <= RdIN;	
			EXE_signals = EXE_signals_IN;
		end

  	end
	  
	 
endmodule