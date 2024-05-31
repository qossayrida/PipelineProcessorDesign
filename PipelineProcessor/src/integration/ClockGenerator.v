module ClockGenerator (output reg clk);
	
	
initial begin 
	clk=LOW; 
    $display("(%0t) ==> The clk was initialize", $time);
end

 
always #10 begin
    clk=~clk;
end
					   

endmodule