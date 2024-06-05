module ALU( 
	input wire [15:0] A, B, 
	output reg [15:0] Output, 
	input wire [1:0] ALUop
);


    always @(A,B) begin 
        case (ALUop)
            ALU_OP_AND:  Output <= A & B;
            ALU_OP_ADD:  Output <= A + B;
            ALU_OP_SUB:  Output <= A - B;
        endcase
    end


endmodule	  


module ALU_tb;


    reg [15:0] A, B;
    wire [15:0] Output;
    reg [1:0] ALUop;


    ALU alu(A, B, Output,ALUop);

    initial begin

        #0
        A <= 16'd3;
        B <= 16'd2;
        ALUop <= ALU_OP_AND;

        #10

        A <= 16'd30;
        B <= 16'd20;
        ALUop <= ALU_OP_SUB;



        #10
        A <= 16'd30;
        B <= 16'd30;
        ALUop <= ALU_OP_ADD;

        #5 $finish;
    end

endmodule
