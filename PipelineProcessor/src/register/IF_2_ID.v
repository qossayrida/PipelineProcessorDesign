module IF2ID(
	input clk,stall, 
	input [15:0] PCIN, instructionIN, 
	output reg [15:0] PC, instruction
);


  	always @ (posedge clk) begin

      	if (~stall) begin
          	instruction <= instructionIN;
          	PC <= PCIN;
      	end

  	end
endmodule