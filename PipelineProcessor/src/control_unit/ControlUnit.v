module MainAluControl (
	input [3:0] opCode,
	input mode,stall,
	output reg [15:0] signlas
);

// SRC1   SRC2   RegDst   ExtOp   ExtPlace   AluSRC   ALUOP{2}  DataInSrc  MemRd   MemWr  NumOfByte{2}   WBdata{2}  RegWr

always @ (*) begin

    if (stall == 0) begin
      	case (opCode)
            AND:  signlas <= {1'b0 , 1'b1 , 1'b0 , 1'bx , 1'bx , 1'b0 , 2'b00 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01 , 1'b1};
            ADD:  signlas <= {1'b0 , 1'b1 , 1'b0 , 1'bx , 1'bx , 1'b0 , 2'b01 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01 , 1'b1};
            SUB:  signlas <= {1'b0 , 1'b1 , 1'b0 , 1'bx , 1'bx , 1'b0 , 2'b10 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01 , 1'b1};
			ADDI: signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 2'b01 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01 , 1'b1};
			ANDI: signlas <= {1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 2'b00 , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b01 , 1'b1};
			LW:   signlas <= {1'b0 , 1'bx , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 2'b01 , 1'bx , 1'b1 , 1'b0 , 2'b00 , 2'b10 , 1'b1};
			SW:	  signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 , 1'b1 , 2'b01 , 1'b1 , 1'b0 , 1'b1 , 2'b10 , 2'bxx , 1'b0};
			LoadByte:
				begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'bx , 1'b0 , 1'b1 , 1'b0 ,	1'b1 , 2'b01 , 1'bx , 1'b1 , 1'b0 , 2'b01 ,	2'b10 , 1'b1};
                	end else begin
                    	 signlas <= {1'b0 , 1'bx , 1'b0 , 1'b1 , 1'b0 ,	1'b1 , 2'b01 , 1'bx , 1'b1 , 1'b0 , 2'b10 ,	2'b10 , 1'b1};
                	end
		  		end
		  	
			BranchGreater:
			  	begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end
		  		end
				  
			BranchLess:
			    begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end
		  		end
				  
			BranchEqual: 
			  	begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end
				end
		    
		    BranchNotEqual:
			   	begin
                	if (!mode) begin
                    	 signlas <= {1'b0 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end else begin
                    	 signlas <= {1'b1 , 1'b0 , 1'bx , 1'b1 , 1'b0 ,	1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx ,	2'bxx , 1'b0};
                	end
				end
				
			JMP:  signlas <= {1'bx , 1'bx , 1'bx , 1'bx , 1'bx , 1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'bxx , 1'b0};
			CALL: signlas <= {1'bx , 1'bx , 1'b1 , 1'bx , 1'bx , 1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'b00 , 1'b1};
			RET:  signlas <= {1'bx , 1'bx , 1'bx , 1'bx , 1'bx , 1'bx , 2'bxx , 1'bx , 1'b0 , 1'b0 , 2'bxx , 2'bxx , 1'b0};
			SV:   signlas <= {1'b1 , 1'b0 , 1'bx , 1'b0 , 1'b1 , 1'b0 , 2'b01 , 1'b0 , 1'b0 , 1'b1 , 2'bxx , 2'bxx , 1'b0};

        endcase
          
    end

    else begin
	   	signlas <= 16'b0;
    end	   
	
  end 	
  
  
endmodule 		  






module PcControl (
    input [3:0] opCode,
    input stall,
    input GT,LT,EQ,
    output reg [1:0] PcSrc,
	output reg kill 
); 

	initial begin
		PcSrc=0;
	 	kill=0;
	end
	
	always @ (*) begin	
		if ((opCode==BranchGreater && GT) || (opCode==BranchLess && LT) || (opCode==BranchEqual && EQ) || (opCode==BranchNotEqual && !EQ)) begin
        	PcSrc=2;
        	kill=1;
        end else if (opCode ==  JMP || opCode == CALL) begin
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
	input clk,
	input [3:0] opCode,
	input [2:0] RS1,RS2,Rd2,Rd3,Rd4,
	input EX_RegWr, MEM_RegWr ,WB_RegWr,EX_MemRd,
	output reg stall, 
	output reg [1:0] ForwardA,ForwardB
); 	

	initial begin
		stall=0;
	end

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