module Extender (
    input [7:0] in,
    input ExtOp,
    input ExtPlace,
    output reg [15:0] out
);

    always @(*) begin
        if (ExtPlace == 1) begin
            out <= {8'b0, in};
        end else begin
            // Extend from 5-bit position
            if (ExtOp) begin
                // Signed extension
                out <= {{11{in[4]}}, in[4:0]};
            end else begin
                // Unsigned extension
                out <= {11'b0, in[4:0]};
            end
        end
    end
endmodule


module Extender_TB;

    // Testbench signals
    reg [7:0] in;
    reg ExtOp;
    reg ExtPlace;
    wire [15:0] out;

    // Instantiate the Extender module
    Extender uut (
        .in(in),
        .ExtOp(ExtOp),
        .ExtPlace(ExtPlace),
        .out(out)
    );

    initial begin
        // Display the output
        $monitor("in=%b, ExtOp=%b, ExtPlace=%b -> out=%b", in, ExtOp, ExtPlace, out);
        
        // Test cases
        // Test signed extension from MSB
        in = 8'b10000000; ExtOp = 0; ExtPlace = 1;
        #10;

        // Test unsigned extension from MSB
        in = 8'b10000000; ExtOp = 1; ExtPlace = 1;
        #10;

        // Test signed extension from 5-bit position
        in = 8'b00011100; ExtOp = 0; ExtPlace = 0;
        #10;

        // Test unsigned extension from 5-bit position
        in = 8'b00011100; ExtOp = 1; ExtPlace = 0;
        #10;

        // Add more test cases as needed
        in = 8'b01111111; ExtOp = 0; ExtPlace = 1;
        #10;

        in = 8'b01111111; ExtOp = 1; ExtPlace = 1;
        #10;

        in = 8'b00011111; ExtOp = 0; ExtPlace = 0;
        #10;

        in = 8'b00011111; ExtOp = 1; ExtPlace = 0;
        #10;

        // Finish the simulation
        $finish;
    end

endmodule
