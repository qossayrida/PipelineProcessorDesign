module Mux4to1 #(parameter integer LENGTH = 16) (
    input wire [1:0] sel,                  // 2-bit selection input
    input wire [LENGTH-1:0] in0,           // Input 0
    input wire [LENGTH-1:0] in1,           // Input 1
    input wire [LENGTH-1:0] in2,           // Input 2
    input wire [LENGTH-1:0] in3,           // Input 3
    output reg [LENGTH-1:0] out            // Output
);

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = {LENGTH{1'b0}}; // Default case to avoid latches
        endcase
    end

endmodule
