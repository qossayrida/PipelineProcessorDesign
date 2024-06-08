module EXE2MEM (
	input clk,
	input [15:0] valueFromALU_IN, valueFromReg_IN, immIN, PCIN, 
	input [2:0] RdIN,
	input [7:0] MEM_signals_IN,
	output reg [15:0] valueFromALU, valueFromReg , imm,	PC, 
	output reg [2:0] Rd,
	output reg [7:0] MEM_signals
);


  	always @ (posedge clk) begin


	  	valueFromALU <= valueFromALU_IN;
		valueFromReg <= valueFromReg_IN;
	  	imm	<=  immIN;
		PC <= PCIN;
		Rd <= RdIN;	
		MEM_signals = MEM_signals_IN;


  	end
	  

	  
endmodule