module PipelineProcessor ();
	
	initial begin		 
        #400 $finish; 
    end			
	
	
	
	//******************************************************
	//					clock & registers		
	//******************************************************
	
	wire clk;		
	
	ClockGenerator clock( 
		.clk(clk)
	);
	
	
	
	//******************************************************
	//					Control unit registers		
	//****************************************************** 
	
	
	
	
	
	
	//******************************************************
	//					   Pipeline stages		
	//******************************************************  
	

	
	
endmodule