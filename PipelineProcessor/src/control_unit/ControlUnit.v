module MainAluControl (
	input [3:0] opCode,
	input mode,stall,
	output reg [15:0] signlas
);



  always @ (*) begin
    if (stall == 0) begin
//     case (opCode)
        
		  
//      endcase
	  
    end

    else if (stall ==  1) begin

    end	   
	
  end 	
  
  
endmodule 		  


// SRC1   SRC2   RegDst   ExtOp   ExtPlace    RegWr   AluSRC   ALUOP{2}  DataInSrc  MemRd   MemWr  NumOfByte{2}   WBdata{2}



module PcControl (
	input [3:0] opCode,
	input stall,
	output reg PcSrc,kill 
); 


	initial begin 
		PcSrc = 0 ;
		kill = 0;
	end
	

endmodule		 



module HazardDetect (
	input [3:0] opCode,
	input stall,
	output reg PcSrc,kill 
); 


endmodule