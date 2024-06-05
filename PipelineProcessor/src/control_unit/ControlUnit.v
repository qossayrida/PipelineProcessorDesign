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
    input GT,LT,EQ,
    output reg PcSrc,kill 
); 
	
	always @ (*) begin	
		if ((opCode==BranchGreater && GT) || (opCode==BranchLess && LT) || (opCode==BranchEqual && EQ) || (opCode==BranchNotEqual && !EQ)) begin
        	PcSrc=2;
        	kill=1;
        end else if (opCode ==  JMP) begin
        	PcSrc=1;
        	kill=1;
        end else if (opCode ==  RET) begin
        	PcSrc=3;
        	kill=1;
        end else begin
    		PcSrc=0;
    		kill=0;
		end
	end


endmodule


module HazardDetect (
	input [3:0] opCode,
	input [2:0] RS1,RS2,Rd2,Rd3,Rd4,
	input EX_RegWr, MEM_RegWr ,WB_RegWr,EX_MemRd,
	output reg stall,ForwardA,ForwardB 
); 

	always @(*) begin  
        // ForwardA logic
        if ((RS1 != 0) && (RS1 == Rd2) && EX_RegWr) 
            ForwardA = 1;
        else if ((RS1 != 0) && (RS1 == Rd3) && MEM_RegWr) 
            ForwardA = 2;
        else if ((RS1 != 0) && (RS1 == Rd4) && WB_RegWr) 
            ForwardA = 3;
        else    
            ForwardA = 0;

        // ForwardB logic
        if ((RS2 != 0) && (RS2 == Rd2) && EX_RegWr) 
            ForwardB = 1;
        else if ((RS2 != 0) && (RS2 == Rd3) && MEM_RegWr) 
            ForwardB = 2;
        else if ((RS2 != 0) && (RS2 == Rd4) && WB_RegWr) 
            ForwardB = 3;
        else    
            ForwardB = 0;

        // Stall logic
        if (EX_MemRd && ((ForwardA == 1) || (ForwardB == 1))) 
            stall = 1;
        else 
            stall = 0;
    end	

endmodule