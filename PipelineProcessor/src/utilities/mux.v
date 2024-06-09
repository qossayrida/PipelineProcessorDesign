module mux_4 #(parameter integer LENGTH) (in1, in2, in3, in4, sel, out);
  input [LENGTH-1:0] in1, in2, in3, in4;
  input [1:0] sel;
  output [LENGTH-1:0] out;

  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 :
               (sel == 2'd2) ? in3 : in4;
endmodule
