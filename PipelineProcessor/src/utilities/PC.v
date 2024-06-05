module PC(
	input wire clk,  
	input wire I_TypeImmediate, J_TypeImmediate, ReturnAddress, 
	input wire [1:0] PCsrc,
	output reg [15:0] PC
);


 
    wire [15:0] nextPC;

    
    assign nextPC = PC + 16'd2;
	
	
    initial begin
		PC <= 32'd0;
	end


    always @(posedge clk) begin
        case (PCsrc)
            00: begin     
                PC = nextPC;      
            end  
            01:  begin
				PC = J_TypeImmediate;    
            end  
            10: begin   
                PC = I_TypeImmediate;
            end  
            11: begin
                PC = ReturnAddress;  
            end  
        endcase
	end

    

endmodule