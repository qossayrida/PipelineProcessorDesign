module Compare(
    input wire signed [15:0] A, 
    input wire signed [15:0] B, 
    output reg gt, 
    output reg lt,
    output reg eq
);

    always @(A, B) begin
        // Initialize all outputs to 0
        gt = 0;
        lt = 0;
        eq = 0;

        // Compare A and B
        if (A > B) begin
            lt = 1;
        end else if (A < B) begin
            gt = 1;
        end else begin
            eq = 1;
        end
    end

endmodule



module Compare_TB;

    reg signed [15:0] A, B;
    wire gt;
    wire lt;
    wire eq;

    Compare comp(A, B, gt, lt, eq);

    initial begin
        // Unsigned comparisons
        #0
        A <= 16'd3;
        B <= 16'd2;

        #10
        A <= 16'd30;
        B <= 16'd40;

        #10
        A <= 16'd40;
        B <= 16'd40;

        // Signed comparisons
        #10
        A <= -16'sd10;
        B <= 16'sd10;

        #10
        A <= -16'sd20;
        B <= -16'sd30;

        #10
        A <= -16'sd40;
        B <= -16'sd40;

        #5 $finish;
    end

endmodule
