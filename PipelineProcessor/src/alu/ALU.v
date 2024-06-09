module ALU(
	input wire signed  [15:0] A, B, 
	input wire [1:0] ALUop, 
	output reg signed  [15:0] Output
);


	always @(*) begin
        case (ALUop)
            ALU_OP_AND:  Output <= A & B;
            ALU_OP_ADD:  Output <= A + B;
            ALU_OP_SUB:  Output <= A - B;
			default:    Output <= 16'b0;
        endcase
    end


endmodule	  


module ALU_TB;
	
    reg signed [15:0] A, B; // Declare testbench registers as signed
    wire signed [15:0] Output; // Declare output wire as signed
    reg [1:0] ALUop;

    // Instantiate the ALU
    ALU alu(A, B, ALUop , Output);

    initial begin
        // Unsigned test cases
        #0
        A <= 16'd3;
        B <= 16'd2;
        ALUop <= ALU_OP_AND;
        #10;

        A <= 16'd30;
        B <= 16'd20;
        ALUop <= ALU_OP_SUB;
        #10;

        A <= 16'd30;
        B <= 16'd30;
        ALUop <= ALU_OP_ADD;
        #10;

        // Signed test cases
        A <= 16'sd15;
        B <= -16'sd10;
        ALUop <= ALU_OP_ADD;
        #10;

        A <= -16'sd20;
        B <= 16'sd25;
        ALUop <= ALU_OP_SUB;
        #10;

        A <= -16'sd10;
        B <= -16'sd5;
        ALUop <= ALU_OP_AND;
        #10;

        $finish;
    end

endmodule

