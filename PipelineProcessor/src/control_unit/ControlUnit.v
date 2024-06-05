module MainAluControl (
	input [3:0] opCode,
	input mode,stall,
	output reg [15:0] signlas
);



  always @ (*) begin
    if (stall == 0) begin
		
      	case (opCode)
            AND:  signlas <= {1'b0 , 1'b1 , 1'b0 , 1'bx , 1'bx , 1'b1 , 1'b0 , 2'b01 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01};
            ADD:  signlas <= {1'b0 , 1'b1 , 1'b0 , 1'bx , 1'bx , 1'b1 , 1'b0 , 2'b00 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01};
            SUB:  signlas <= {1'b0 , 1'b1 , 1'b0 , 1'bx , 1'bx , 1'b1 , 1'b0 , 2'b10 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01};
			ADDI: signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 1'b1 , 2'b01 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01};
			ANDI: signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01};
			LW:   signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 ,	1'b1 , 2'b01 , 1'bx , 1'b1 , 1'b0 , 2'b00 ,	2'b10};
			SW:	  signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'b1 , 2'b01 , 1'b1 , 1'b0 , 1'b1 , 2'bxx ,	2'bxx};
			LoadByte:
				begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 ,	1'b1 , 2'b01 , 1'bx , 1'b1 , 1'b0 , 2'b01 ,	2'b10};
                	end else begin
                    	 signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 ,	1'b1 , 2'b01 , 1'bx , 1'b1 , 1'b0 , 2'b10 ,	2'b10};
                	end
		  		end
		  	
			BranchGreater:
			  	begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end
		  		end
				  
			BranchLess:
			    begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end
		  		end
				  
			BranchEqual: 
			  	begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end
				end
		    
		    BranchNotEqual:
			   	begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
                	end
				end
				
			JMP: signlas <= {1'bx , 1'bx , 1'bx , 1'bx , 1'bx , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
			CALL: signlas <= {1'bx , 1'bx , 1'b1 , 1'bx , 1'bx , 1'b1 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'b00};
			RET: signlas <= {1'bx , 1'bx , 1'bx , 1'bx , 1'bx , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx};
			SV:  signlas <= {1'b1 , 1'b0 , 1'bx , 1'b0 , 1'b1 , 1'b0 ,	1'b0 , 2'b01 , 1'b0 , 1'b0 , 1'b1 , 2'bxx ,	2'bxx};

        endcase
          
    end

    else if (stall ==  1) begin
	   	signlas <= 16'b0;
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
	input [2:0] RS1,RS2
	input stall,
	output reg PcSrc,kill 
); 

	always @ (*) begin  
	
	
	end	
	
	
	      
// If ((Rs != 0) and (Rs == Rd2) and (EX.RegWr))  ForwardA = 1
// Else if ((Rs != 0) and (Rs == Rd3) and (MEM.RegWr)) ForwardA = 2
// Else if ((Rs != 0) and (Rs == Rd4) and (WB.RegWr))  ForwardA = 3
// Else    
// ForwardA = 0	 
//
// If((Rt != 0) and (Rt == Rd2) and (EX.RegWr))  ForwardB = 1
// Else if ((Rt != 0) and (Rt == Rd3) and (MEM.RegWr)) ForwardB = 2
// Else if ((Rt != 0) and (Rt == Rd4) and (WB.RegWr)) ForwardB = 3
// Else    
// ForwardB = 0

	
	
	if ((EX.MemRd == 1)  // Detect Load in EX stage
 and (ForwardA==1 or ForwardB==1)) Stall

endmodule